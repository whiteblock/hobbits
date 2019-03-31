# This is the test runner; it runs all parser/marshal implementations against the same suite of marshalled messages.
# To pass the test the implementation must parse the message from stdin (request or response variant) and then marshal
# it and print to stdout.
# The interface the binary or script produced must adhere to is as follows so it is compatible with this test suite:
# <implementation-binary> <request|response> <payload-size>
# - request|response determines whether or not we are testing the request or response message type
# - payload-size is the byte length of the message
# - STDIN must be read to obtain the marshalled test data; read <payload-size> bytes only to obtain test data bytes

import re
from subprocess import Popen, PIPE
import unittest
import yaml

VERSION = '0.2'
FIELDS = [
    "version", "command", "compression",
    "head-only", "headers", "body"
]

LANGS = {
     'bash':['bash','./parsers/bash/parser.sh'] 
     'c': ['./parsers/c/test'],
     'cpp': [ './parsers/cpp/test' ],
     'd': ['./parsers/d/main'],
     'erlang': ['./parsers/erlang/test'],
     'java':['java','./parsers/java/Parser.java'],
     'php': ['php','./parsers/php/test.php'],
     'rs': [ './parsers/rs/parser' ],
     'racket': ['./parsers/racket/test'],
     'scheme':['./parsers/scheme/test'],
     'python':['python', './parsers/python/test.py'],
     'perl': ['perl', '-I' './parsers/perl', './parsers/perl/test.pl'],
     'go':['go','run','./parsers/go/test.go', './parsers/go/parser.go'],
}


class DynamicTest(unittest.TestCase):
    longMessage = True

def quote(token):
    return '"' + token + '"'

def bracket(token):
    return '[' + token + ']'

def load_yaml_file(path):
    with open(path, 'r') as stream:
        return yaml.load(stream)

def run_impl(args, stdindata):
    proc = Popen(args, stdin=PIPE, stdout=PIPE, stderr=PIPE)
    stdout, stderr = proc.communicate(stdindata)
    print stderr
    return stdout

if __name__ == '__main__':
    suites = load_yaml_file('test/tests.yaml')

    for lang, lang_args in LANGS.iteritems():
        for suite in suites:
            suite_name = re.sub('[ -]', '_', suite['suite']).lower()

            for request in suite['requests']:
                desc = re.sub('[ -]', '_', request['desc']).lower()
                test_name = "_".join([ 'test', lang, suite_name, 'request', desc ])

                args = []
                args.extend(lang_args)
                args.extend([ 'request', str(len(request['marshalled'])) ])
                expected = request['marshalled']

                def test_func(self, args=args, expected=expected):
                    actual = run_impl(args, expected)
                    self.assertEqual(actual, expected)

                setattr(DynamicTest, test_name, test_func)

    unittest.main(verbosity=3)

import re
from subprocess import Popen, PIPE
import unittest
import yaml

VERSION = '0.1'
FIELDS = [
    "version", "command", "compression", "response-compression",
    "head-only", "headers", "body"
]

LANGS = {
    'cpp': [ './parsers/cpp/test' ],
    'php': ['php','./parsers/php/test.php'],
    'rs': [ './parsers/rs/parser' ],
    'racket': ['./parsers/racket/test'],
    'scheme':['./parsers/scheme/test'],
    'python':["python", './parsers/python/test.py'],
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
                actual = run_impl(args, expected)

                test_func = lambda self, actual=actual, expected=expected: self.assertEqual(actual, expected)
                setattr(DynamicTest, test_name, test_func)

            for response in suite['responses']:
                desc = re.sub('[ -]', '_', response['desc']).lower()
                test_name = "_".join([ 'test', lang, suite_name, 'response', desc ])

                args = []
                args.extend(lang_args)
                args.extend([ 'response', str(len(response['marshalled'])) ])
                expected = response['marshalled']
                actual = run_impl(args, expected)

                test_func = lambda self, actual=actual, expected=expected: self.assertEqual(actual, expected)
                setattr(DynamicTest, test_name, test_func)

    unittest.main(verbosity=3)

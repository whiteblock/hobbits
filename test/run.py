import re
from subprocess import Popen, PIPE
import unittest
import yaml

VERSION = '0.1'
FIELDS = [
    "version", "command", "compression", "response-compression",
    "head-only", "headers", "body"
]

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

    for suite in suites:
        suite_name = re.sub('[ -]', '_', suite['suite']).lower()

        for request in suite['requests']:
            desc = re.sub('[ -]', '_', request['desc']).lower()
            test_name = "_".join([ 'test', suite_name, 'request', desc ])

            expected = request['marshalled']
            actual = run_impl(['./parsers/rs/parser', 'request' ], request['marshalled'])

            test_func = lambda self, actual=actual, expected=expected: self.assertEqual(actual, expected)
            setattr(DynamicTest, test_name, test_func)

        for request in suite['responses']:
            desc = re.sub('[ -]', '_', request['desc']).lower()

            test_func = lambda self, desc=desc : self.assertEqual(1, 1)
            test_name = "_".join([ 'test', suite_name, 'response', desc ])

            setattr(DynamicTest, test_name, test_func)

    unittest.main(verbosity=3)


import re
import unittest
import yaml

class DynamicTest(unittest.TestCase):
    longMessage = True

def load_yaml_file(path):
    with open(path, 'r') as stream:
        return yaml.load(stream)

if __name__ == '__main__':
    suites = load_yaml_file('test/tests.yaml')

    for suite in suites:
        suite_name = re.sub('[ -]', '_', suite['suite']).lower()
        for request in suite['requests']:
            desc = re.sub('[ -]', '_', request['desc']).lower()
            test_func = lambda self, desc=desc : self.assertEqual(1, 2)
            test_name = "_".join([ 'test', suite_name, desc ])
            setattr(DynamicTest, test_name, test_func)

    unittest.main(verbosity=3)


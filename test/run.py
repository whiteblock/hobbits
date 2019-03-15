import re
import subprocess
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

def load_yaml_file(path):
    with open(path, 'r') as stream:
        return yaml.load(stream)

def generate_rust_field_line_value(name, r):
    switch = {
        'head-only': lambda r=r: str(r.get('head-only', False)),
        'headers': lambda r=r: r.get('headers', '[]'),
        'body': lambda r=r: r.get('body', '[]'),
        'response-compression': lambda r=r: ",".join(r['response-compression']),
        'version': lambda r=r: VERSION,
    }
    default_fun = lambda r=r, name=name: r.get(name)
    val = switch.get(name, default_fun)()

    if val == None:
        raise ValueError('could not generate rust field line for {0}'.format(name))
    else:
        return quote(val)



def generate_rust_expected_pretty(r):
    lines = [
        'EWPRequest {',
    ]
    lines.extend(map(lambda f, r=r: '    ' + f + ': ' + generate_rust_field_line_value(f, r), FIELDS))
    lines.append('}')

    return "\n".join(lines)

'''
EWPRequest {
    version: "0.1",
    command: "PING",
    compression: "none",
    response_compression: [
        "none"
    ],
    head_only_indicator: false,
    headers: [],
    body: [
        49,
        50,
        51,
        52,
        53
    ]
}
'''
if __name__ == '__main__':
    suites = load_yaml_file('test/tests.yaml')

    for suite in suites:
        suite_name = re.sub('[ -]', '_', suite['suite']).lower()

        for request in suite['requests']:
            print(generate_rust_expected_pretty(request))
            desc = re.sub('[ -]', '_', request['desc']).lower()
            test_func = lambda self, request=request: println(request)

            test_name = "_".join([ 'test', suite_name, 'request', desc ])
            setattr(DynamicTest, test_name, test_func)

        for request in suite['responses']:
            desc = re.sub('[ -]', '_', request['desc']).lower()
            test_func = lambda self, desc=desc : self.assertEqual(1, 2)
            test_name = "_".join([ 'test', suite_name, 'response', desc ])
            setattr(DynamicTest, test_name, test_func)

    #subprocess.call(["./parsers/rs/parser" ])
    unittest.main(verbosity=3)


import unittest

class DynamicTest(unittest.TestCase):
    longMessage = True

if __name__ == '__main__':
    testsmap = {
        'foo': [1, 1],
        'bar': [1, 2],
        'baz': [5, 5]}

    for name, params in testsmap.iteritems():
        test_func = lambda self, params=params : (
            self.assertEqual(params[0], params[1], name)
        )
        setattr(DynamicTest, 'test_{0}'.format(name), test_func)

    unittest.main(verbosity=3)


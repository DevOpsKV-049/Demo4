import unittest
from getPredictions.main import get_predictions


class MyFunTest(unittest.TestCase):

    def test_negative(self):
        self.assertEquals(get_predictions(""), 0)


if __name__ == '__main__':
    unittest.main()
import unittest
from toZamb.main import message_from_topic2


class MyFunTest(unittest.TestCase):

    def test_negative(self):
        self.assertEquals(message_from_topic2("", self), 0)


if __name__ == '__main__':
    unittest.main()
import unittest
from getFromDB.main import get_from_db


class MyFunTest(unittest.TestCase):

    def test_negative(self):
        self.assertEquals(get_from_db(""), 0)


if __name__ == '__main__':
    unittest.main()
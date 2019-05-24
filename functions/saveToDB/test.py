import unittest
from saveToDB.main import message_from_topic1


class MyFunTest(unittest.TestCase):

    def test_negative(self):
#        pass
        self.assertEquals(message_from_topic1("", self), 0)

#    def test_negative(self):
#        pass
#            self.assertEquals(get_data_from_api(self), 1)

if __name__ == '__main__':
    unittest.main()

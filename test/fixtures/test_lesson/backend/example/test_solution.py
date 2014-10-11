import unittest
import redis
import solution

class TestSolution(unittest.TestCase):
    def setUp(self):
        self.r = redis.StrictRedis(host='0.0.0.0', port=6379, db=0)

    def test_set(self):
        solution.set("key", "value", self.r)
        self.assertEqual("value", self.r.get("key"))

    def test_get(self):
        self.r.set("key", "value")
        self.assertEqual("value", solution.get("key", self.r))

if __name__ == '__main__':
    unittest.main()

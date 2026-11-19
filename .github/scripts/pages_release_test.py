import unittest

from pages_release import latest_stable


class LatestStableTests(unittest.TestCase):
    def test_numeric_order_and_prerelease(self):
        refs = [("v1.9", "a"), ("v1.10", "b"), ("v2.0", "c"), ("v5.0-rc", "d"), ("v9.0.0", "e")]
        versions = {"a": "1.9.9", "b": "1.10.2", "c": "2.0.0-rc.1"}
        self.assertEqual(latest_stable(refs, versions.__getitem__), ("v1.10", "b"))

    def test_first_stable_release_promotes_its_channel(self):
        refs = [("v1.10", "old"), ("v2.0", "new")]
        self.assertEqual(latest_stable(refs, {"new": "2.0.0"}.__getitem__), ("v2.0", "new"))

    def test_no_stable_branch_fails_closed(self):
        with self.assertRaisesRegex(ValueError, "No stable"):
            latest_stable([("edge", "a"), ("v1.0", "b")], lambda _: "1.0.0-rc.1")

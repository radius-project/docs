import subprocess
import tempfile
import unittest
from pathlib import Path

from pages_release import latest_stable, release_site


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

    def test_release_layout_is_read_from_each_ref_not_the_current_worktree(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo = Path(tmp)
            subprocess.run(["git", "init", "-q", repo], check=True)

            def tree():
                subprocess.run(["git", "-C", repo, "add", "-A"], check=True)
                return subprocess.check_output(["git", "-C", repo, "write-tree"], text=True).strip()

            old = repo / "docs" / "config.toml"
            old.parent.mkdir()
            old.write_bytes(b'[params]\nchart_version = "0.62.0"\n')
            nested = tree()
            new = repo / "config.toml"
            new.write_bytes(b'[params]\nchart_version = "0.63.0"\n')
            with self.assertRaisesRegex(ValueError, "Expected one Hugo config"):
                release_site(tree(), repo)
            old.unlink()
            flat = tree()
            self.assertEqual(release_site(nested, repo), (old.parent, "0.62.0"))
            self.assertEqual(release_site(flat, repo), (repo, "0.63.0"))

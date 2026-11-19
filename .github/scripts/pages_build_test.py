import tempfile
import unittest
from pathlib import Path

from build_pages import publish_default_channel


class DefaultChannelTests(unittest.TestCase):
    def test_unversioned_urls_use_stable_pages_and_downloads(self):
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp)
            latest = output / "latest"
            for path in ("index.html", "guides/a b/index.html", "old.html", "404.html", "edge/index.html"):
                file = latest / path
                file.parent.mkdir(parents=True, exist_ok=True)
                file.write_text("stable")
            (latest / "sample.bicep").write_bytes(b"sample\r\n")
            (output / "edge").mkdir()
            (output / "edge/index.html").write_text("edge")

            publish_default_channel(output, "https://pages.example/project")

            for path, route in (("index.html", ""), ("guides/a b/index.html", "guides/a%20b/"), ("old.html", "old.html")):
                page = (output / path).read_text()
                self.assertIn(f'href="https://pages.example/project/latest/{route}"', page)
            self.assertEqual((output / "sample.bicep").read_bytes(), b"sample\r\n")
            self.assertEqual((output / "404.html").read_text(), "stable")
            self.assertEqual((output / "edge/index.html").read_text(), "edge")

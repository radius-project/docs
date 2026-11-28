import os
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import algolia


class SearchIndexTests(unittest.TestCase):
    def test_index_uses_versioned_url_and_docsy_breadcrumbs(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp, "index.html")
            path.write_text(
                '<meta property="og:url" content="https://docs.example/edge/install/">'
                '<li class="td-breadcrumbs__item">Getting Started</li>'
                '<li class="td-breadcrumbs__item">Install</li>', encoding="utf-8",
            )
            env = {"ALGOLIA_APP_ID": "test", "ALGOLIA_API_KEY": "test", "ALGOLIA_INDEX_NAME": "docs"}
            with patch.dict(os.environ, env), patch.object(algolia, "SearchClientSync", autospec=True) as client:
                algolia.main(path.parent)
            submit = client.return_value.__enter__.return_value.replace_all_objects
            submit.assert_called_once()
            self.assertEqual(submit.call_args.kwargs["index_name"], "docs")
            record, = submit.call_args.kwargs["objects"]
            self.assertEqual((record["objectID"], record["lvl1"], record["rank"]), ("/edge/install/", "Getting Started", 2))

    def test_index_text_covers_lists_tables_and_headings_but_not_site_chrome(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp, "index.html")
            path.write_text(
                '<meta property="og:url" content="https://docs.example/edge/routes/">'
                '<nav><p>Navbar</p></nav>'
                '<div class="td-content"><h1>Routes</h1><p>Radius creates:</p>'
                '<ul><li>A <code>GatewayClass</code> named <code>contour</code>.</li><li>A Gateway</li></ul>'
                '<h2>Limits</h2><table><tr><th>Resource</th><th>Count</th></tr>'
                '<tr><td>ConfigMap</td><td>Multiple</td></tr></table>'
                '<div class="highlight"><pre><code>kubectl get gateway</code></pre></div>'
                '<div class="d-print-none"><h2 class="feedback--title">Feedback</h2><p>Was this page helpful?</p></div>'
                '<div class="td-page-meta__lastmod">Last modified November 18, 2026</div></div>'
                '<footer><p>Copyright</p></footer>', encoding="utf-8",
            )
            record = algolia.parse_file(path)
            self.assertEqual(
                record["text"],
                "Routes Radius creates: A GatewayClass named contour. A Gateway Limits Resource Count ConfigMap Multiple",
            )

    def test_index_text_falls_back_to_whole_page_without_docsy_content(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp, "index.html")
            path.write_text(
                '<meta property="og:url" content="https://docs.example/edge/api/">'
                '<main><h1>API</h1><p>Endpoints</p></main>', encoding="utf-8",
            )
            self.assertEqual(algolia.parse_file(path)["text"], "API Endpoints")

    def test_404_hidden_and_alias_only_site_never_replaces_index(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            meta = '<meta property="og:url" content="https://docs.example/latest/">'
            (root / "404.html").write_text(meta)
            (root / "hidden.html").write_text("<!-- DISABLE_ALGOLIA -->" + meta)
            (root / "index.html").write_text('<meta http-equiv="refresh" content="0;url=latest/">')
            with patch.object(algolia, "SearchClientSync") as client, self.assertRaisesRegex(SystemExit, "No indexable pages"):
                algolia.main(root)
            client.assert_not_called()


if __name__ == "__main__":
    unittest.main()

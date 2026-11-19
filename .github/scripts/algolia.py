import os
import sys
from pathlib import Path
from urllib.parse import urlsplit

from bs4 import BeautifulSoup
from algoliasearch.search.client import SearchClientSync

rankings = {
    "concepts": 100,
    "getting started": 0,
    "developer guides": 200,
    "operator guides": 300,
    "reference": 400,
    "contributing": 500,
    "home": 600,
}


def parse_file(path: Path):
    content = path.read_text(encoding="utf-8")
    if '<!-- DISABLE_ALGOLIA -->' in content:
        return None
    soup = BeautifulSoup(content, "html.parser")
    data = {"hierarchy": {}, "rank": 999, "type": "lvl2", "lvl0": "", "lvl1": "", "lvl2": "", "lvl3": ""}
    for meta in soup.find_all("meta"):
        if meta.get("name") == "description":
            data["lvl2"] = meta.get("content")
            data["hierarchy"]["lvl1"] = meta.get("content")
        elif meta.get("property") == "og:title":
            data["lvl0"] = meta.get("content")
            data["hierarchy"]["lvl0"] = meta.get("content")
            data["hierarchy"]["lvl2"] = meta.get("content")
        elif meta.get("property") == "og:url" and meta.get("content"):
            data["url"] = meta.get("content")
            data["path"] = urlsplit(data["url"]).path
            data["objectID"] = data["path"]
    if "objectID" not in data:
        return None
    breadcrumbs = soup.select("li.td-breadcrumbs__item, li.breadcrumb-item")
    data["subrank"] = len(breadcrumbs)
    if breadcrumbs:
        section = breadcrumbs[0].get_text(strip=True)
        data["lvl1"] = section
        data["hierarchy"]["lvl0"] = section
        rank = rankings.get(section.casefold())
        data["rank"] = rank + len(breadcrumbs) if rank is not None else 998
    data["text"] = "".join(p.get_text() for p in soup.find_all("p"))
    return data


def main(starting_directory: Path):
    payload = [
        record for page in sorted(starting_directory.rglob("*.html"))
        if page.name != "404.html" and (record := parse_file(page)) is not None
    ]
    if not payload:
        sys.exit(f"No indexable pages in {starting_directory}; refusing to replace the search index.")
    print(f"Indexing {len(payload)} pages from {starting_directory}")
    with SearchClientSync(os.environ["ALGOLIA_APP_ID"], os.environ["ALGOLIA_API_KEY"]) as client:
        client.replace_all_objects(index_name=os.environ["ALGOLIA_INDEX_NAME"], objects=payload)


if __name__ == "__main__":
    main(Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd())

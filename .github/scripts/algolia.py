import os
from re import S
import sys
import json
from bs4 import BeautifulSoup
from algoliasearch.search_client import SearchClient

url = "radapp.dev"
if len(sys.argv) > 1:
    starting_directory = os.path.join(os.getcwd(), str(sys.argv[1])) 
else:
    starting_directory = os.getcwd()

ALGOLIA_APP_ID = os.getenv('ALGOLIA_APP_ID')
ALGOLIA_API_KEY = os.getenv('ALGOLIA_API_KEY')
ALGOLIA_INDEX_NAME = os.getenv('ALGOLIA_INDEX_NAME')

client = SearchClient.create(ALGOLIA_APP_ID, ALGOLIA_API_KEY)
index = client.init_index(ALGOLIA_INDEX_NAME)

excluded_files = [
    "404.html",
]

rankings = {
    "Concepts": 100,
    "Getting started": 0,
    "Developer guides": 200,
    "Administrator guides": 300,
    "Reference": 400,
    "Contributing": 500,
    "Home": 600
}

def scan_directory(directory: str, pages: list):
    for file in os.listdir(directory):
        path = os.path.join(directory, file)
        if os.path.isfile(path):
            if file.endswith(".html") and file not in excluded_files:
                if '<!-- DISABLE_ALGOLIA -->' not in open(path).read():
                    print(f'Indexing: {path}')
                    pages.append(path)
                else:
                    print(f'Skipping hidden page: {path}')
        else:
            scan_directory(path, pages)

def parse_file(path: str):
    data = {}
    data["hierarchy"] = {}
    data["rank"] = 999
    data["type"] = "lvl2"
    data["lvl0"] = ""
    data["lvl1"] = ""
    data["lvl2"] = ""
    data["lvl3"] = ""
    text = ""
    subrank = 0
    with open(path, "r", errors='ignore') as file:
        content = file.read()
        soup = BeautifulSoup(content, "html.parser")
    for meta in soup.find_all("meta"):
        if meta.get("name") == "description":
            data["lvl2"] = meta.get("content")
            data["hierarchy"]["lvl1"] = meta.get("content")
        elif meta.get("property") == "og:title":
            data["lvl0"] = meta.get("content")
            data["hierarchy"]["lvl0"] = meta.get("content")
            data["hierarchy"]["lvl2"] = meta.get("content")
        elif meta.get("property") == "og:url":
            data["url"] = meta.get("content")
            data["path"] = meta.get("content").split(url)[1]
            data["objectID"] = meta.get("content").split(url)[1]
    # Promote parent pages over child pages in rankings
    subrank = soup.find_all("li", class_="breadcrumb-item").count()
    for bc in soup.find_all("li", class_="breadcrumb-item"):
        section = bc.text.strip()
        data["lvl1"] = section
        data["hierarchy"]["lvl0"] = section
        try:
            data["rank"] = rankings[section] + subrank
        except:
            print(f"Rank not found for section {section}")
            data["rank"] = 998
        break
    for p in soup.find_all("p"):
        if p.text != "":
            text = text + p.text
    data["text"] = text
    return data

def index_payload(payload):
    res = index.replace_all_objects(payload)
    res.wait()


if __name__ == "__main__":
    pages = []
    payload = []
    scan_directory(starting_directory, pages)
    for page in pages:
        data = parse_file(page)
        if "objectID" in data:
            payload.append(data)
    index_payload(payload)

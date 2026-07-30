# ------------------------------------------------------------
# Copyright 2023 The Radius Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#    
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ------------------------------------------------------------

# This script parses the auto-generated resource markdown references
# and generates Hugo pages for each resource.

import os
import sys
import json
import re

# Generated resource pages (namespace indexes, API-version indexes, and
# individual resource schema pages) omit a description. The listing partials
# render the page title as the link text, so a "Reference documentation for
# <title>" description would only repeat the title.
hugo_template = """---
type: docs
title: "{}"
linkTitle: "{}"
---

"""

# Namespace segment display-name overrides, used for capitalization that does
# not follow simple title-casing (e.g. "ai" -> "AI").
namespace_segment_overrides = {"ai": "AI"}

# Namespace-parent directories to skip. The legacy "applications" tree holds the
# retired Applications.* resource types, which are no longer documented.
excluded_namespace_parents = {"applications"}

def display_name(namespace):
    return ".".join(
        namespace_segment_overrides.get(segment, segment.capitalize())
        for segment in namespace.split(".")
    )

# The resource markdown filenames are all lowercase (e.g. "bicepsettings.md"),
# but the canonical resource name is camelCased (e.g. "bicepSettings"). The
# authoritative casing lives in the sibling "types.json" as fully qualified type
# names like "Radius.Core/bicepSettings@2025-08-01-preview". Build a map from the
# lowercased resource segment to its canonical camelCase spelling so headings and
# link titles use the correct casing.
def load_canonical_resource_names(types_json_path):
    canonical = {}
    if not os.path.exists(types_json_path):
        return canonical
    try:
        data = json.load(open(types_json_path, 'r'))
    except (ValueError, OSError):
        return canonical

    def walk(node):
        if isinstance(node, dict):
            for key, value in node.items():
                if key == 'name' and isinstance(value, str) and '/' in value and '@' in value:
                    resource_segment = value.split('/', 1)[1].split('@', 1)[0]
                    canonical[resource_segment.lower()] = resource_segment
                walk(value)
        elif isinstance(node, list):
            for item in node:
                walk(item)

    walk(data)
    return canonical

# The emitter wraps the resource @doc prose under a top-level "## Description"
# heading, but the authored prose uses "##" for its own subsections (e.g.
# "Defining an Application"), which makes them siblings of Description instead of
# children. Demote every "##" heading between "## Description" and the first
# schema section to "###", leaving "## Description" and the schema section
# headings untouched. Fenced code blocks are skipped so "##" inside code is not
# altered.
def demote_description_headings(markdown_content):
    schema_headings = ("## Top-Level Properties", "## Object Properties", "## Properties")
    in_description = False
    in_fence = False
    result = []
    for line in markdown_content.splitlines(keepends=True):
        stripped = line.rstrip("\n")
        if stripped.startswith("```"):
            in_fence = not in_fence
            result.append(line)
            continue
        if not in_fence:
            if stripped == "## Description":
                in_description = True
                result.append(line)
                continue
            if in_description and stripped in schema_headings:
                in_description = False
            if in_description and stripped.startswith("## "):
                line = "#" + line
        result.append(line)
    return "".join(result)

# Each schema table carries "Required" and "Read-Only" columns that only ever
# hold "false"/"true". That information is already restated in the Description
# column, which begins with "(Optional)", "(Required)", or "(Read Only)", so the
# dedicated boolean columns are redundant and waste horizontal space (crowding
# the Description). Drop those columns from every table, keeping Property, Type,
# and Description. Columns to remove are identified per-table from the header row.
# Cells are split on unescaped pipes only, so enum unions such as
# "'A' \| 'B' \| 'C'" in the Type column are kept intact rather than mistaken for
# extra columns.
_UNESCAPED_PIPE = re.compile(r"(?<!\\)\|")

def strip_boolean_columns(markdown_content):
    columns_to_drop = {"Required", "Read-Only"}
    drop_indices = None
    result = []
    for line in markdown_content.splitlines(keepends=True):
        newline = "\n" if line.endswith("\n") else ""
        stripped = line.strip()
        if stripped.startswith("|") and stripped.endswith("|"):
            # Split on unescaped pipes; drop the empty leading/trailing cells
            # produced by the outer table pipes.
            raw_cells = _UNESCAPED_PIPE.split(stripped)[1:-1]
            cells = [c.strip() for c in raw_cells]
            if drop_indices is None and columns_to_drop.issubset(set(cells)):
                drop_indices = {idx for idx, c in enumerate(cells) if c in columns_to_drop}
            if drop_indices is not None:
                kept = [c for idx, c in enumerate(raw_cells) if idx not in drop_indices]
                result.append("|" + "|".join(kept) + "|" + newline)
                continue
        else:
            # A non-table line ends the current table.
            drop_indices = None
        result.append(line)
    return "".join(result)

# Top-level section index for the flattened resource schema tree. The
# namespace-parent directory level (e.g. "radius") is flattened away so the
# namespaces appear directly under a single "Resource schemas" section.
section_index_template = """---
type: docs
title: "Resource Types"
linkTitle: "Resource Types"
description: "Schema reference for built-in Resource Types"
weight: 200
---

## Introduction

Resource Types define the schema for the resources developers use to model their applications—the properties you can configure, the values Radius returns, and the API versions each type supports. For a deeper explanation of what Resource Types are and how they abstract the underlying infrastructure, see the [Resource Types concepts]({{< ref "concepts/resource-types" >}}) page.

`Radius.Core` Resource Types are embedded in the Radius control plane. All other Resource Types are sourced from the [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) repository.

All of the schema information on these pages is also available directly from your environment using [`rad resource-type list`]({{< ref rad_resource-type_list >}}) and [`rad resource-type show`]({{< ref rad_resource-type_show >}}), as well as through the [Radius Dashboard]({{< ref "/installation/dashboard" >}}).

## How this section is organized

Resource Types are organized first by namespace (such as `Radius.Core`, `Radius.Compute`, and `Radius.Data`) and then by API version (for example, `2025-08-01-preview`). Open a Resource Type to view its schema reference, which documents the resource's properties, including which fields are required and read-only.

"""

# Ensure that the script is called with the correct number of arguments
if len(sys.argv) != 3:
    print("Usage: python generate_resource_references.py <source_directory> <target_directory>")
    sys.exit(1)

# Pass in "source_directory" as input parameter
# This directory should contain the auto-generated
# resource markdown files for a given provider (applications, aws, etc.)
# Example: radius/hack/generated/
source_directory = sys.argv[1]

# Pass in "target_directory" as input parameter
# This directory should contain the Hugo content directory
# This script will generate the pages and directories as needed
# Example: docs/docs/content/reference/resources
target_directory = sys.argv[2]

# Get all the directories in the source directory
# Example: applications, aws, etc.
namespace_parents = os.listdir(source_directory)
if not namespace_parents:
    print("No namespace parents found in source directory: {}".format(source_directory))
    sys.exit(1)

# Create the top-level "Resource schemas" section index.
os.makedirs(target_directory, exist_ok=True)
with open(os.path.join(target_directory, '_index.md'), 'w') as f:
    f.write(section_index_template)

# Iterate through each namespace parent directory for each namespace
for namespace_parent in namespace_parents:
    if not os.path.isdir(os.path.join(source_directory, namespace_parent)):
        continue

    # Skip retired namespace-parent trees (e.g. legacy Applications.* types).
    if namespace_parent in excluded_namespace_parents:
        continue

    namespaces = os.listdir(os.path.join(source_directory, namespace_parent))
    if not namespaces:
        print("No namespaces found in namespace parent: {}".format(namespace_parent))
        continue

    for namespace in namespaces:
        if not os.path.isdir(os.path.join(source_directory, namespace_parent, namespace)):
            continue

        # Create _index.md file for namespace (flattened directly under target)
        target_namespace_dir = os.path.join(target_directory, namespace, '_index.md')
        os.makedirs(os.path.dirname(target_namespace_dir), exist_ok=True)
        with open(target_namespace_dir, 'w') as f:
            f.write(hugo_template.format(display_name(namespace), display_name(namespace)))

        api_versions = os.listdir(os.path.join(source_directory, namespace_parent, namespace))
        if not api_versions:
            print("No API versions found in namespace: {}".format(namespace_parent))
            continue

        for api_version in api_versions:
            if not os.path.isdir(os.path.join(source_directory, namespace_parent, namespace, api_version)):
                continue

            # Create _index.md file for API version
            target_api_version_dir = os.path.join(target_directory, namespace, api_version, '_index.md')
            os.makedirs(os.path.dirname(target_api_version_dir), exist_ok=True)
            with open(target_api_version_dir, 'w') as f:
                f.write(hugo_template.format(api_version, api_version))

            resource_markdown_files = os.listdir(os.path.join(source_directory, namespace_parent, namespace, api_version, 'docs'))
            if not resource_markdown_files:
                print("No resource markdown files found in namespace {} and API version: {}".format(namespace, api_version))
                continue

            # Canonical (camelCase) resource names keyed by lowercase segment.
            canonical_resource_names = load_canonical_resource_names(
                os.path.join(source_directory, namespace_parent, namespace, api_version, 'types.json'))

            for resource_markdown_file in resource_markdown_files:
                if not resource_markdown_file.endswith(".md"):
                    continue

                resource_name = resource_markdown_file.split(".")[0]
                # Use the canonical camelCase spelling for the resource segment
                # (e.g. "bicepSettings" instead of the lowercase filename).
                canonical_name = canonical_resource_names.get(resource_name.lower(), resource_name)
                # PascalCase title for the sidebar/table of contents link.
                link_title = canonical_name[:1].upper() + canonical_name[1:]
                print("Processing resource: {}/{}@{}".format(namespace, canonical_name, api_version))
                target_resource_dir = os.path.join(target_directory, namespace, api_version, resource_name)

                qualified_name = '{}/{}@{}'.format(display_name(namespace), canonical_name, api_version)
                hugo_content = hugo_template.format(qualified_name, link_title)
                hugo_content += "{{< schemaExample >}}\n\n"

                ## Check if a Bicep file exists for the resource
                #bicep_file = os.path.join(source_directory, namespace_parent, namespace, api_version, 'examples', resource_name + ".bicep")
                #if os.path.exists(bicep_file):
                #    # Copy Bicep file to target directory
                #    bicep_target_file = os.path.join(target_resource_dir, 'snippets', resource_name + ".bicep")
                #    print("   Bicep example found")
                #    os.makedirs(os.path.dirname(bicep_target_file), exist_ok=True)
                #    os.system("cp {} {}".format(bicep_file, bicep_target_file))
                #
                #    bicep_hugo_link = "snippets/{}.bicep".format(resource_name)
                #    hugo_content += "## Example\n\n"
                #    hugo_content += "{{{{< rad file=\"{}\" embed=true marker=""//SNIPPET"" >}}}}\n\n".format(bicep_hugo_link)
                
                # Add in the resource markdown file
                markdown_content = open(os.path.join(source_directory, namespace_parent, namespace, api_version, 'docs', resource_markdown_file), 'r').read()
                hugo_content += strip_boolean_columns(demote_description_headings(markdown_content))

                # Create the target markdown file
                target_markdown_file = os.path.join(target_resource_dir, 'index.md')
                os.makedirs(os.path.dirname(target_markdown_file), exist_ok=True)
                with open(target_markdown_file, 'w') as f:
                    f.write(hugo_content)

                
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

hugo_template = """---
type: docs
title: "Reference: {}"
linkTitle: "{}"
description: "Detailed reference documentation for {}"
---

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

# Iterate through each namespace parent directory for each namespace
for namespace_parent in namespace_parents:
    if not os.path.isdir(os.path.join(source_directory, namespace_parent)):
        continue

    # Create _index.md file for namespace parent
    target_namespace_parent_dir = os.path.join(target_directory, namespace_parent, '_index.md')
    os.makedirs(os.path.dirname(target_namespace_parent_dir), exist_ok=True)
    with open(target_namespace_parent_dir, 'w') as f:
        f.write(hugo_template.format(namespace_parent, namespace_parent, namespace_parent))

    namespaces = os.listdir(os.path.join(source_directory, namespace_parent))
    if not namespaces:
        print("No namespaces found in namespace parent: {}".format(namespace_parent))
        continue

    for namespace in namespaces:
        if not os.path.isdir(os.path.join(source_directory, namespace_parent, namespace)):
            continue

        # Create _index.md file for namespace
        target_namespace_dir = os.path.join(target_directory, namespace_parent, namespace, '_index.md')
        os.makedirs(os.path.dirname(target_namespace_dir), exist_ok=True)
        with open(target_namespace_dir, 'w') as f:
            f.write(hugo_template.format(namespace, namespace, namespace))

        api_versions = os.listdir(os.path.join(source_directory, namespace_parent, namespace))
        if not api_versions:
            print("No API versions found in namespace: {}".format(namespace_parent))
            continue

        for api_version in api_versions:
            if not os.path.isdir(os.path.join(source_directory, namespace_parent, namespace, api_version)):
                continue

            # Create _index.md file for API version
            target_api_version_dir = os.path.join(target_directory, namespace_parent, namespace, api_version, '_index.md')
            os.makedirs(os.path.dirname(target_api_version_dir), exist_ok=True)
            with open(target_api_version_dir, 'w') as f:
                f.write(hugo_template.format(api_version, api_version, api_version))

            resource_markdown_files = os.listdir(os.path.join(source_directory, namespace_parent, namespace, api_version, 'docs'))
            if not resource_markdown_files:
                print("No resource markdown files found in namespace {} and API version: {}".format(namespace, api_version))
                continue

            for resource_markdown_file in resource_markdown_files:
                if not resource_markdown_file.endswith(".md"):
                    continue

                resource_name = resource_markdown_file.split(".")[0]
                print("Processing resource: {}/{}@{}".format(namespace, resource_name, api_version))
                target_resource_dir = os.path.join(target_directory, namespace_parent, namespace, api_version, resource_name)

                hugo_content = hugo_template.format('{}/{}@{}'.format(namespace, resource_name, api_version), resource_name, '{}/{}@{}'.format(namespace, resource_name, api_version))
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
                hugo_content += "## Schema\n\n"
                hugo_content += markdown_content

                # Create the target markdown file
                target_markdown_file = os.path.join(target_resource_dir, 'index.md')
                os.makedirs(os.path.dirname(target_markdown_file), exist_ok=True)
                with open(target_markdown_file, 'w') as f:
                    f.write(hugo_content)

                
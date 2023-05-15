# ------------------------------------------------------------
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
# ------------------------------------------------------------

# This script parses docs version from PR and set the parsed version to
# environment variables, DOCS_CHANNEL.

# We set the environment variable REL_CHANNEL based on the kind of build. This is used for
# versioning of our assets.
#
# DOCS_CHANNEL is:
# 'edge': for most builds
# '1.0': for PR builds

# DOCS_CHANNEL is used to upload assets to different paths

import os
import sys

gitRefName = os.getenv("GITHUB_BASE_REF")
print("GITHUB_BASE_REF: {}".format(gitRefName))

with open(os.getenv("GITHUB_ENV"), "a") as githubEnv:
    version = "DOCS_CHANNEL=edge"

    if gitRefName is None:
        print("This is not running in github, GITHUB_REF_NAME is null. Assuming a local build. Setting DOCS_CHANNEL to 'edge'")
        version = "DOCS_CHANNEL=edge"
    elif gitRefName.lower() == 'edge':
        print("This is an edge build, setting DOCS_CHANNEL to 'edge'")
        version = "DOCS_CHANNEL=edge"
    elif gitRefName.startswith('v'):
        print("This is a release build, setting DOCS_CHANNEL to version")
        versionNumber = gitRefName.split('v')[1]
        version = "DOCS_CHANNEL=" + versionNumber

    print("Setting: {}".format(version))
    githubEnv.write(version + "\n")
    sys.exit(0)

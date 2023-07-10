---
type: docs
title: "Maintainer guides for Radius"
linkTitle: "Maintainers"
description: "Guides and requirements for Radius maintainers"
weight: 999
---

## Docs repo

In this guide, you’ll learn how to perform routine Radius docs maintainer and approver responsibilities. In order to successfully accomplish these tasks, you need either approver or maintainer status in the [`project-radius/docs`](https://github.com/project-radius/docs) repo. 

To learn how to contribute to Radius docs, review the [Contributor guide]({{< ref contributing-docs >}}).

### Branch guidance

The Radius docs handles branching differently than most code repositories. Instead of a `main` branch, every branch is labeled to match the major and minor version of a runtime release, plus an `edge` branch for in-flight work. For example, the `v1.0` branch contains the docs for the `v1.0` release. The `edge` branch contains the latest in-flight work.

### Managing content between branches

As a docs approver or maintainer, you need to perform routine **upmerges** to keep the pre-release `edge` branch aligned with updates to the current release branch. It is recommended to upmerge the current branch into the pre-release branch on a weekly basis.

For the following steps, treat `v1.0` as the current release and `edge` as the pre-release branch.

1. Open Visual Studio Code to the Radius docs repo.
1. From your local repo, switch to the latest branch (`v1.0`) and synchronize changes:

   ```bash
   git pull upstream v1.0
   git push origin v1.0
   ```

1. Switch to the upcoming branch (`edge`) and synchronize changes:

   ```bash
   git pull upstream edge
   git push origin edge
   ```

1. Create a new branch from `edge`:

   ```bash
   git checkout -b upmerge_MM-DD
   ```

1. Open a terminal and stage a merge from the latest release into the upmerge branch:

   ```bash
   git merge --no-ff --no-commit v1.0
   ```

1. Make sure included files look accurate. Inspect any merge conflicts in VS Code. Remove configuration changes or version information that does not need to be merged. Examples of files that usually shouldn't be merged:
   - docs/config.toml
   - docs/layouts/partials/hooks/body-end.html
   - docsy sub-module
1. Commit the staged changes and push to the upmerge branch (`upmerge_MM-DD`).
1. Open a PR from the upmerge branch to the upcoming release branch (`edge`).
1. Review the PR and double check that no unintended changes were pushed to the upmerge branch.

---
type: docs
title: "Contributing to Radius"
linkTitle: "Contributing"
description: "Guides and requirements for contributing to and engaging with the Radius community"
weight: 1000
aliases:
  - "/community/"
  - "/community/overview/"
  - "/community/contributing/overview/"
  - "/contributing/overview/"
---

Radius is built and maintained by an open community, and you're invited to contribute. Whether you write code, improve the docs, share a Recipe, file a bug, or answer questions, every contribution strengthens Radius. Use this page as your starting point.

## Get started in three steps

1. **Introduce yourself**: join the [Radius Discord](#stay-connected) to get help and connect with other contributors.
2. **Find something to work on**: browse the [good-first-issues](https://aka.ms/radius-first-issues) and `/assign` a beginner-friendly task to yourself.
3. **Make your change**: choose a [way to contribute](#ways-to-contribute) below, follow that repository's contribution guide, and open a pull request.

<a class="btn btn-primary" href="https://aka.ms/radius-first-issues" role="button" target="_blank">Browse good-first-issues</a>

## Ways to contribute

You don't need to write code to make an impact. Using Radius and sharing your experience is a valuable contribution in itself. Radius spans several repositories — choose the path that matches your interests and follow that repository's contribution guide to get started.

{{< cardpane >}}
  {{% card header="**🚀 Use Radius & share feedback**" footer="[**Get started with Radius →**]({{< ref getting-started >}})" %}}
  Run Radius on your own apps, build a sample with Resource Types and Recipes, and [report bugs or request features](https://github.com/radius-project/radius/issues/new/choose). Real-world feedback shapes the roadmap.
  {{% /card %}}
  {{% card header="**💻 Contribute code**" footer="[**Radius contribution guide →**](https://github.com/radius-project/radius/blob/main/CONTRIBUTING.md)" %}}
  Fix a bug or add a feature to the [`rad` CLI](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-cli/README.md), [control plane](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-control-plane/README.md), or other components in the main [radius-project/radius](https://github.com/radius-project/radius) repo, or help [review pull requests](https://github.com/radius-project/radius/pulls).
  {{% /card %}}
{{< /cardpane >}}
{{< cardpane >}}
  {{% card header="**🧩 Share Recipes & Resource Types**" footer="[**Resource Types contribution guide →**](https://github.com/radius-project/resource-types-contrib/tree/main/docs/contributing)" %}}
  Add to the shared library of Radius Resource Types and Recipes in [radius-project/resource-types-contrib](https://github.com/radius-project/resource-types-contrib) that the whole community can reuse.
  {{% /card %}}
  {{% card header="**📝 Improve the docs**" footer="[**Docs contribution guide →**]({{< ref contributing-docs >}})" %}}
  Fix typos, clarify guides, or write new content in [radius-project/docs](https://github.com/radius-project/docs). Documentation changes are one of the easiest ways to start contributing.
  {{% /card %}}
{{< /cardpane >}}

### Radius repositories

All Radius source lives under the [radius-project](https://github.com/radius-project) organization on GitHub. The most common repositories to contribute to are:

| Repository | Description |
|------------|-------------|
| [radius-project/radius](https://github.com/radius-project/radius) | Main repository with the source for the `rad` CLI, control plane, and other core Radius components |
| [radius-project/resource-types-contrib](https://github.com/radius-project/resource-types-contrib) | Shared library of Radius Resource Types and Recipes for Radius applications |
| [radius-project/docs](https://github.com/radius-project/docs) | Documentation for Radius (this site) |
| [radius-project/dashboard](https://github.com/radius-project/dashboard) | The frontend experience for Radius |
| [radius-project/blog](https://github.com/radius-project/blog) | Source for the Radius blog |
| [radius-project/samples](https://github.com/radius-project/samples) | Sample applications that demonstrate Radius |

## Before your first pull request

Review these requirements before you contribute:

- **Read the Code of Conduct**: the Radius community follows the [CNCF Code of Conduct](https://github.com/radius-project/radius/blob/main/CODE_OF_CONDUCT.md). Be respectful and inclusive.
- **Sign your commits (DCO)**: every commit must be cryptographically signed. See the [contribution guide](https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-first-commit/first-commit-06-creating-a-pr/index.md#signing-your-commits) for details.
- **Follow the repository's contribution guide**: each repository has its own setup and workflow instructions. Start there.
- **Ask for help when you need it**: reach out on [Discord](#stay-connected) or comment on the issue you're working on.

## Stay connected

Connect with the community on the Radius Discord server:

{{< button link="https://aka.ms/radius/discord" text="Join the Radius Discord" newtab="true" >}}

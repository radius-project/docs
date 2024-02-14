---
type: docs
title: "Overview: Contributing to Radius"
linkTitle: "Overview"
description: "Guides and requirements for contributing to Radius"
weight: 100
---

We welcome contributions to Radius! Contributions can come in different ways such as engaging with the community, contributing code, or improving the documentation. This page provides an overview of the different ways you can contribute to Radius.

## Community

Check out the [Radius Community]({{< ref community >}}) page to learn about the different ways you can engage with the Radius community.

## GitHub

If you would like to file Issues, access the source code, or use Codespaces please visit the [Radius GitHub repo](https://github.com/radius-project). 

### good-first-issues

To quickly get started with contributing to code on Radius, here are some identified [good-first-issues](https://aka.ms/radius-first-issues) that you can `/assign` to yourself and start contributing. 

### Contributing to Radius

Check out the following table to learn where and how you can contribute:

| Repository | Description | Contribution guides |
|------------|-------------|---------------------|
| **Radius** | Main repository that contains source code for [`rad` CLI]((https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-cli/running-rad-cli.md)), [control plane]((https://github.com/radius-project/radius/blob/main/docs/contributing/contributing-code/contributing-code-control-plane/README.md)) and other components of Radius | [radius-project/radius](https://github.com/radius-project/radius/blob/main/CONTRIBUTING.md)|
| **Docs** | Documentation for Radius | [[Contributing to docs]]({{< ref contributing-docs>}})|
| **Recipes** | Commonly used [Recipe](https://docs.radapp.io/recipes) templates for Radius Environments | [radius-project/recipes](https://github.com/radius-project/recipes/blob/main/CONTRIBUTING.md) |(https://github.com/radius-project/recipes/blob/main/CONTRIBUTING.md) |
| **Dashboard** | The frontend experience for Radius |[radius-project/dashboard](https://github.com/radius-project/dashboard/blob/main/CONTRIBUTING.md) |
| **Bicep** |  Temporary fork of the [Bicep repo](https://github.com/azure/bicep) used to inject the Radius types into the Bicep language. Contains both the Bicep CLI and the Bicep VS Code extension. | [radius-project/bicep](https://github.com/radius-project/bicep/blob/radius-compiler/CONTRIBUTING.md) |

### Troubleshooting common issues

#### Visual Studio not authorized for single sign-on

If you receive an error saying Visual Studio Code or another application is not authorized to clone any of the Radius repositories you may need to re-authorize the GitHub app:

1. Open a browser to https://github.com/settings/applications
1. Find the applicable app and select Revoke
1. Reopen app on local machine and re-auth
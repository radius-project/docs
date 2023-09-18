---
type: docs
title: "Overview: Using Radius in Visual Studio Code"
linkTitle: "Overview"
description: "Learn how to use Radius in Visual Studio Code"
weight: 100
categories: "Overview"
tags: ["VSCode"]
---

When using Visual Studio Code with Radius there are a set of extensions that you can install to help author, validate, and manage your Radius applications and environments.

## Radius Bicep extension

The Radius Bicep extension provides formatting, intellisense, and validation for Bicep templates.

<img src="vscode-bicep.png" alt="Screenshot of the Radius Bicep extension showing available Radius resource types" width=600px >
<br /><br/>

{{< button text="Radius Bicep guide" page="howto-vscode-bicep" >}}

{{< alert title="Note" color="secondary" >}}
The Radius Bicep extension is a temporary extension that exists in order to extend the set of Bicep types with the Radius types. When the Bicep project adds extensibility support to their tooling the Radius Bicep extension will be deprecated. Stay tuned for updates.

**The Radius Bicep extension is not compatible with the official Bicep extension.** If you have the official Bicep extension installed you will need to disable or uninstall it before installing the Radius Bicep extension.
{{< /alert >}}

## Terraform extension

When authoring [Terraform Recipes]({{< ref "/guides/recipes/overview" >}}) you can use the HashiCorp Terraform extension to help author, validate, and manage your Terraform templates.

{{< button text="Terraform extension" link="https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform" newtab="true" >}}
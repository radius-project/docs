---
type: docs
title: "Overview: Using Radius in Visual Studio Code"
linkTitle: "Overview"
description: "Learn how to use Radius in Visual Studio Code"
weight: 100
categories: "Overview"
tags: ["VSCode"]
---

When using Visual Studio Code with Radius there are a set of extensions you can install to help author, validate, and manage your Radius Applications and environments.

## Bicep extension

The Bicep extension provides formatting, intellisense, and validation for Bicep templates.

{{< image src="vscode-bicep.png" alt="Screenshot of the Bicep extension showing available Radius resource types" width=600px >}}
<br /><br/>

{{< button text="Bicep guide" page="howto-vscode-bicep" >}}

{{< alert title="Note" color="secondary" >}}


**The official Bicep extension is not compatible with the Radius Bicep extension.** Previously, Radius made use of the Radius Bicep extension, a temporary extension used to model Radius and AWS resource types. The Radius Bicep extension has been deprecated and we have upstreamed our extensibility updates to the official Bicep. If you have the Radius Bicep extension installed you will need to disable or uninstall it before installing the Bicep extension. 
{{< /alert >}}

## Terraform extension

When authoring [Terraform Recipes]({{< ref "/guides/recipes/overview" >}}) you can use the HashiCorp Terraform extension to help author, validate, and manage your Terraform templates.

{{< button text="Terraform extension" link="https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform" newtab="true" >}}
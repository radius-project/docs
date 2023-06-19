---
type: docs
title: "Extender resource"
linkTitle: "Extender"
description: "Learn how to use Extender resource in Radius"
weight: 999
slug: "extender"
---

## Overview

An extender resource could be used to bring in a custom resource into Radius for which there is no first class support to "extend" the Radius functionality. The resource can define arbitrary key-value pairs and secrets. These properties and secret values can then be used to connect it to other Radius resources.

## Resource format

{{< tabs Recipe Manual >}}

{{< codetab >}}

{{< rad file="snippets/extender-recipe.bicep" embed=true marker="//EXTENDER" >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/extender-manual.bicep" embed=true marker="//EXTENDER" >}}

{{< /codetab >}}

{{< /tabs >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. | `mongo`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| \<user-defined key-value pairs\> | n | User-defined properties of the extender. Can accept any key name except 'secrets'. | `fromNumber: '222-222-2222'`
| secrets | n | Secrets in the form of key-value pairs | `password: '******'`
| resourceProvisioning | n | Specifies how to build the Link resource. Options are to build automatically via 'recipe' or build manually via 'manual'. Selection determines which set of fields to additionally require. | `manual`
| [recipe](#recipe)  | n | The recipe to deploy. | [See below](#recipe)

#### Recipe

| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| name | n | Specifies the name of the Recipe that should be deployed. If not set, the name defaults to `default`. | `name: 'azure-prod'`
| parameters | n | An object that contains a list of parameters to set on the Recipe. | `{ size: 'large' }`

## Methods

The following methods are available on the Extender link:

| Method | Description |
|--------|-------------|
| secrets('SECRET_NAME') | Get the value of a secret. |

## Resource provisioning

### Provision with a Recipe

[Recipes]({{< ref "/author-apps/recipes" >}}) automate infrastructure provisioning using approved templates.
You can specify a Recipe name that is registered in the environment or omit the name and use the "default" Recipe.

Parameters can also optionally be specified for the Recipe.

### Provision manually

If you want to manually manage your infrastructure provisioning outside of Recipes, you can set `resourceProvisioning` to `'manual'` and provide all necessary parameters and values in order for Radius to be able to deploy/connect to the desired infrastructure.
---
type: docs
title: "Dapr Binding resource"
linkTitle: "Binding"
description: "Learn how to use Dapr Binding in Radius"
weight: 300
slug: "binding"
---

## Overview

An `Applications.Dapr/bindings` resource represents a [Dapr binding](https://docs.dapr.io/developing-applications/building-blocks/bindings/bindings-overview/).

## Resource format

{{< tabs Recipe Manual >}}

{{< codetab >}}

{{< rad file="snippets/dapr-binding-recipe.bicep" embed=true marker="//SAMPLE" >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/dapr-binding-manual.bicep" embed=true marker="//SAMPLE" >}}

{{< /codetab >}}

{{< /tabs >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of the Binding. Names must contain at most 63 characters, contain only lowercase alphanumeric characters, '-', or '.', start with an alphanumeric character, and end with an alphanumeric character. | `my-config` |
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| application | n | The ID of the application resource this resource belongs to. | `app.id`
| [auth](#auth) | n | Authentication information for this component. | [See below](#auth)
| environment | y | The ID of the environment resource this resource belongs to. | `env.id`
| [resourceProvisioning](#resource-provisioning) | n | Specifies how the underlying service/resource is provisioned and managed. Options are to provision automatically via 'recipe' or provision manually via 'manual'. Selection determines which set of fields to additionally require. Defaults to 'recipe'. | `manual`
| [recipe](#recipe) | n | Configuration for the Recipe which will deploy the backing infrastructure. | [See below](#recipe)
| [resources](#resources) | n | An array of resources which underlay this resource. For example, an Azure Redis Cache ID if the Dapr Binding resource is leveraging Azure Redis Cache. | [See below](#resources)
| type | n | The Dapr component type. Set only when resourceProvisioning is 'manual'. | `binding.cron` |
| metadata | n | Metadata object for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-bindings/). Set only when resourceProvisioning is 'manual'. | `{ redisHost: 'localhost:6379' }` |
| version | n | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-bindings/) for available versions. Set only when resourceProvisioning is 'manual'. | `v1` |
| componentName | n | _(read-only)_ The name of the Dapr component that is generated and applied to the underlying system. Used by the Dapr SDKs or APIs to access the Dapr component. | `mybinding` |

#### Auth
| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| secretStore | n | The name of the secret store to retrieve secrets from. | `secretstore.id` |

#### Recipe

| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| name | n | Specifies the name of the Recipe that should be deployed. If not set, the name defaults to `default`. | `name: 'azure-prod'`
| parameters | n | An object that contains a list of parameters to set on the Recipe. | `{ size: 'large' }`

#### Resources

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| id | n | Resource ID of the supporting resource. | `account.id`

## Resource provisioning

### Provision with a Recipe

[Recipes]({{< ref "guides/recipes/overview" >}}) automate infrastructure provisioning using approved templates.

You can specify a Recipe name that is registered in the environment or omit the name and use the "default" Recipe.

Parameters can also optionally be specified for the Recipe.

### Provision manually

If you want to manually manage your infrastructure provisioning outside of Recipes, you can set `resourceProvisioning` to `'manual'` and specify `type`, `metadata`, and `version` for the Dapr component. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-bindings/).

## Environment variables for connections

Other Radius resources, such as [containers]({{< ref "guides/author-apps/containers" >}}), may connect to a Dapr Binding resource via [connections]({{< ref "application-graph#connections-and-injected-values" >}}). When a connection to Dapr Binding named, for example, `myconnection` is declared, Radius injects values into environment variables that are then used to access the connected Dapr Binding resource:

| Environment variable | Example(s) |
|----------------------|------------|
| CONNECTION_MYCONNECTION_COMPONENTNAME | `mybinding` |
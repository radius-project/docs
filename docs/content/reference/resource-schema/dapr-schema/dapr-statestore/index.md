---
type: docs
title: "Dapr State Store resource"
linkTitle: "State Store"
description: "Learn how to use a Dapr State Store resource in Radius"
weight: 300
slug: "statestore"
categories: "Schema"
---

## Overview

A `Applications.Dapr/stateStores` resource represents a [Dapr state store](https://docs.dapr.io/developing-applications/building-blocks/state-management/) topic.

This resource will automatically create and deploy the Dapr component spec for the state store.

## Resource format

{{< tabs Recipe Manual >}}

{{< codetab >}}

{{< rad file="snippets/dapr-statestore-recipe.bicep" embed=true marker="//SAMPLE" >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/dapr-statestore-manual.bicep" embed=true marker="//SAMPLE" >}}

{{< /codetab >}}

{{< /tabs >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of the resource. Names must contain at most 63 characters, contain only lowercase alphanumeric characters, '-', or '.', start with an alphanumeric character, and end with an alphanumeric character. | `my-statestore` |
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
| [resources](#resources)  | n | An array of IDs of the underlying resources. | [See below](#resources)
| type | n | The Dapr component type. Used when `resourceProvisioning` is set to `manual`. | `state.couchbase`
| metadata | n | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-state-stores/). Used when `resourceProvisioning` is set to `manual`. | `{ couchbaseURL: {value: 'https://*****' }` |
| version | n | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-state-stores/) for available versions. Used when `resourceProvisioning` is set to `manual`. | `v1` |
| componentName | n | _(read-only)_ The name of the Dapr component that is generated and applied to the underlying system. Used by the Dapr SDKs or APIs to access the Dapr component. | `mystatestore` |

#### Auth
| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| secretStore | n | The name of the secret store to retrieve secrets from. | `secretstore.id` |

#### Recipe

| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| name | n | Specifies the name of the Recipe that should be deployed. If not set, the name defaults to `default`. | `name: 'azure-prod'`
| parameters | n | An object that contains a list of parameters to set on the Recipe. | `{ version: 'v1' }`

#### Resources

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| id | n |  Resource ID of the supporting resource. |`account::tableService::table.id`

## Resource provisioning

### Provision with a Recipe

[Recipes]({{< ref howto-author-recipes >}}) automate infrastructure provisioning using approved templates.
When no Recipe configuration is set Radius will use the Recipe registered as the **default** in the environment for the given resource. Otherwise, a Recipe name and parameters can optionally be set.

### Provision manually

If you want to manually manage your infrastructure provisioning outside of Recipes, you can set `resourceProvisioning` to `'manual'` and provide all necessary parameters and values and values that enable Radius to deploy or connect to the desired infrastructure.

## Environment variables for connections

Other Radius resources, such as [containers]({{< ref "guides/author-apps/containers" >}}), may connect to a Dapr state store resource via [connections]({{< ref "application-graph#connections-and-injected-values" >}}). When a connection to Dapr state store named, for example, `myconnection` is declared, Radius injects values into environment variables that are then used to access the connected Dapr state store resource:

| Environment variable | Example(s) |
|----------------------|------------|
| CONNECTION_MYCONNECTION_COMPONENTNAME | `mystatestore` |
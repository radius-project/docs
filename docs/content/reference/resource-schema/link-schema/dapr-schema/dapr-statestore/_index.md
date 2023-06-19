---
type: docs
title: "Dapr State Store resource"
linkTitle: "State Store"
description: "Learn how to use a Dapr State Store resource in Radius"
weight: 300
slug: "statestore"
---

## Overview

A `Applications.Link/daprStateStores` resource represents a [Dapr state store](https://docs.dapr.io/developing-applications/building-blocks/state-management/) topic.

This resource will automatically create and deploy the Dapr component spec for the state store.

## Resource format

{{< rad file="snippets/dapr-statestore-manual.bicep" embed=true marker="//SAMPLE" >}}

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
| environment | y | The ID of the environment resource this resource belongs to. | `env.id`
| resourceProvisioning | y | Specifies how to build the state store resource. Options are to build automatically via 'recipe' or build manually via 'manual'. Selection determines which set of fields to additionally require. | `recipe`
| resources | n | The IDs of related resources such as storage accounts or databases. | `account::tableService::table.id`
| type | n | The Dapr component type. Used when `resourceProvisioning` is set to `manual`. | `state.couchbase`
| metadata | n | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-state-stores/). Used when `resourceProvisioning` is set to `manual`. | `couchbaseURL: https://*****` |
| version | n | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-state-stores/) for available versions. Used when `resourceProvisioning` is set to `manual`. | `v1` |
| componentName | n | _(read-only)_ The name of the Dapr component that is generated and applied to the underlying system. Used by the Dapr SDKs or APIs to access the Dapr component. | `mystatestore` |

## Using resourceProvisioning: recipe

When `resourceProvisioning` is omitted or set to `recipe`, then a [Recipe]({{< ref "/author-apps/recipes" >}}) will be used to create the underlying resource and configure the Dapr building-block.

{{< rad file="snippets/dapr-statestore-recipe.bicep" embed=true marker="//SAMPLE" >}}

## Using resourceProvisioning: manual 

You can also manually specify the metadata of a Dapr state store. When `resourceProvisioning` is set to `manual`, you should specify `type`, `metadata`, and `version` to create a Dapr component spec. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-state-stores/).

{{< rad file="snippets/dapr-statestore-manual.bicep" embed=true marker="//SAMPLE" >}}

You can also provide the associated backing resources via the `resources` property. This does not affect the configuration of the Dapr building-block but will document the relationships between the resources.

## Injected values

Connections from [Radius services]({{< ref container >}}) to [links]({{< ref links-resources >}}) by default inject the following values into the environment of the service:

| Key | Value |
|-----|-------|
| `CONNECTION_<CONNECTIONNAME>_COMPONENTNAME` | `properties.componentName` |

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

{{< rad file="snippets/dapr-statestore-tablestorage.bicep" embed=true marker="//SAMPLE" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of the resource. | `my-statestore` |
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| mode | y | Specifies how to build the pub/sub resource. Options are to build automatically via 'recipe' or 'resource', or build manually via 'values'. Selection determines which set of fields to additionally require. | `recipe`
| kind | n | The kind of the underlying state store resource. See [Available Dapr components](#available-dapr-components) for more information. | `state.azure.tablestorage`
| resource | n | The ID of the storage resource, if a non-generic `kind` is used. | `account::tables.id`
| type | n | The Dapr component type. Used when kind is `generic`. | `state.couchbase`
| metadata | n | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-state-stores/) | `couchbaseURL: https://*****` |
| version | n | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-state-stores/) for available versions. | `v1` |
| componentName | n | _(read-only)_ The name of the Dapr component that is generated and applied to the underlying system. Used by the Dapr SDKs or APIs to access the Dapr component. | `myapp-mystatestore` |

## Available Dapr components

The following resources can act as a `dapr.io.StateStore` resource:

| kind | Resource |
|------|----------|
| `state.azure.tablestorage` | [Azure Table Storage](https://docs.microsoft.com/en-us/azure/storage/tables/table-storage-overview)
| `state.redis` | Azure Cache for Redis
| `generic` | Generic

### Azure Table Storage

Use `kind` of `state.azure.tablestorage` to create a Dapr component spec for Azure Table Storage. Set `resource` to the Azure Storage Table Services resource.

{{< rad file="snippets/dapr-statestore-tablestorage.bicep" embed=true marker="//SAMPLE" >}}

### Generic

A generic pub/sub lets you manually specify the metadata of a Dapr state store. When `kind` is set to `generic`, you can specify `type`, `metadata`, and `version` to create a Dapr component spec. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-state-stores/).

{{< rad file="snippets/dapr-statestore-generic.bicep" embed=true marker="//SAMPLE" >}}

## Injected values

Connections from [Radius services]({{< ref services >}}) to [links]({{< ref links >}}) by default inject the following values into the environment of the service:

| Key | Value |
|-----|-------|
| `CONNECTION_<CONNECTIONNAME>_COMPONENTNAME` | `properties.componentName` |

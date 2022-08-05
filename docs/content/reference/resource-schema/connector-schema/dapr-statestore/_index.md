---
type: docs
title: "Dapr State Store resource"
linkTitle: "Dapr State Store"
description: "Learn how to use a Dapr State Store resource in Radius"
slug: "statestore"
---

## Overview

A `Applications.Connector/daprStateStores` resource represents a [Dapr state store](https://docs.dapr.io/developing-applications/building-blocks/state-management/) topic.

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
| kind | y | The kind of the underlying state store resource. See [Available Dapr components](#available-dapr-components) for more information. | `state.azure.tablestorage`
| resource | n | The ID of the storage resource, if a non-generic `kind` is used. | `account::tables.id`
| type | n | The Dapr component type. Used when kind is `generic`. | `state.couchbase`
| metadata | n | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-state-stores/) | `couchbaseURL: https://*****` |
| version | n | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-state-stores/) for available versions. | `v1` |

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

---
type: docs
title: "Dapr State Store resource"
linkTitle: "State Store"
description: "Learn how to use a Dapr State Store resource in Radius"
weight: 300
slug: "statestore"
---

## Overview

A `dapr.io/StateStore` resource represents a [Dapr state store](https://docs.dapr.io/developing-applications/building-blocks/state-management/) topic.

This resource will automatically create and deploy the Dapr component spec for the state store.

{{< rad file="snippets/dapr-statestore-tablestorage.bicep" embed=true marker="//SAMPLE" >}}

| Property | Description | Example |
|----------|-------------|---------|
| name | The name of the pub/sub | `my-pubsub` |
| properties | Properties of the pub/sub | See [Properties](#properties) below |

### Properties

| Property | Description | Example |
|----------|-------------|---------|
| kind | The kind of the underlying state store resource. See [Available Dapr components](#available-dapr-components) for more information. | `state.azure.tablestorage`
| resource | The ID of the storage resource, if a non-generic `kind` is used. | `account::tables.id`
| type | The Dapr component type. Used when kind is `generic`. | `state.couchbase`
| metadata | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-state-stores/) | `couchbaseURL: https://*****` |
| version | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-state-stores/) for available versions. | `v1` |

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

### Azure Cache for Redis

Use `kind` of `state.redis` to create a Dapr component spec for Azure Cache for Redis. Set `resource` to the Azure Cache for Redis resource ID.

{{< rad file="snippets/dapr-statestore-redis.bicep" embed=true marker="//SAMPLE" >}}

### Generic

A generic pub/sub lets you manually specify the metadata of a Dapr state store. When `kind` is set to `generic`, you can specify `type`, `metadata`, and `version` to create a Dapr component spec. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-state-stores/).

{{< rad file="snippets/dapr-statestore-generic.bicep" embed=true marker="//SAMPLE" >}}

## Starter

You can get up and running quickly with a Dapr state store by using a [starter]({{< ref starter-templates >}}).

## Container

The `br:radius.azurecr.io/starters/dapr/statestore:latest` Dapr StateStore container starter uses a Redis container and can run on any Radius platform.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter.bicep" embed=true >}}

### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the PubSub Topic | Yes | - |
| stateStoreName | The name of the State Store connector | Yes | - |

## Microsoft Azure

The module `'br:radius.azurecr.io/starters/dapr-statestore-azure-tablestorage:latest'` deploys an Azure Storage Account with Tables configured as a Dapr State Store, and outputs a Dapr StateStore resource.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter-azure.bicep" embed=true >}}

### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the State Store | Yes | - |
| stateStoreName | The name of the State Store connector | Yes | - |
| storageAccountName | The name of the underlying Azure storage account | No | `'storage-${uniqueString(resourceGroup().id, deployment().name)}'` |
| tableName | The name of the underlying Azure storage table | No | `'dapr'` |
| location | The Azure region to deploy the Azure storage account and table | No | `resourceGroup().location` |

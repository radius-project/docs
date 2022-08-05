---
type: docs
title: "Dapr Secret Store resource"
linkTitle: "Dapr Secret Store"
description: "Learn how to use a Dapr Secret Store resource in Radius"
slug: "secretstore"
---

## Overview

A `dapr.io/SecretStore` resource represents a [Dapr secret store](https://docs.dapr.io/developing-applications/building-blocks/secrets/secrets-overview/) topic.

This resource will automatically create and deploy the Dapr component spec for the secret store.

## Resource format

{{< rad file="snippets/dapr-secretstore-generic.bicep" embed=true marker="//SAMPLE" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of the resource. | `my-secretstore` |
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of the underlying secret store resource. See [Available Dapr components](#available-dapr-components) for more information. | `secretstores.azure.keyvault`
| type | n | The Dapr component type. Used when kind is `generic`. | `secretstores.azure.keyvault`
| metadata | n | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-secret-stores/) | `vaultName: 'test'` |
| version | n | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-secret-stores/) for available versions. | `v1` |

## Available Dapr components

The following resources can act as a `dapr.io.SecretStore` resource:

| kind | Resource |
|------|----------|
| `generic` | [See below](#generic)

### Generic

A generic secretstore lets you manually specify the metadata of a Dapr secret store. When `kind` is set to `generic`, you can specify `type`, `metadata`, and `version` to create a Dapr component spec. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-secret-stores/).

{{< rad file="snippets/dapr-secretstore-generic.bicep" embed=true marker="//SAMPLE" >}}

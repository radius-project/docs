---
type: docs
title: "Dapr Secret Store resource"
linkTitle: "Secret Store"
description: "Learn how to use a Dapr Secret Store resource in Radius"
weight: 500
slug: "secretstore"
---

## Overview

A `dapr.io/SecretStore` resource represents a [Dapr secret store](https://docs.dapr.io/developing-applications/building-blocks/secrets/secrets-overview/) topic.

This resource will automatically create and deploy the Dapr component spec for the secret store.

{{< rad file="snippets/dapr-secretstore-generic.bicep" embed=true marker="//SAMPLE" >}}

| Property | Description | Example |
|----------|-------------|---------|
| name | The name of the secret store | `secretstore-generic` |
| properties | Properties of the secret store| See [Properties](#properties) below |

### Properties

| Property | Description | Example |
|----------|-------------|---------|
| kind | The kind of the underlying secret store resource. See [Available Dapr components](#available-dapr-components) for more information. | `secretstores.azure.keyvault`
| type | The Dapr component type. Used when kind is `generic`. | `secretstores.azure.keyvault`
| metadata | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-secret-stores/) | `vaultName: 'test'` |
| version | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-secret-stores/) for available versions. | `v1` |

## Available Dapr components

The following resources can act as a `dapr.io.SecretStore` resource:

| kind | Resource |
|------|----------|
| `generic` | Generic

### Generic

A generic secretstore lets you manually specify the metadata of a Dapr secret store. When `kind` is set to `generic`, you can specify `type`, `metadata`, and `version` to create a Dapr component spec. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-secret-stores/).

{{< rad file="snippets/dapr-secretstore-generic.bicep" embed=true marker="//SAMPLE" >}}

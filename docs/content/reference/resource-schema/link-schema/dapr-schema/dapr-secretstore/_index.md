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
| mode | y |The mode used to build the pub/sub resource. Options are to build automatically via 'recipe' or build manually via 'values'. Selection determines which set of fields to additionally require. | `recipe`
| type | n | The Dapr component type. Used when kind is `generic`. | `secretstores.azure.keyvault`
| metadata | n | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-secret-stores/) | `vaultName: 'test'` |
| version | n | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-secret-stores/) for available versions. | `v1` |
| componentName | n | _(read-only)_ The name of the Dapr component that is generated and applied to the underlying system. Used by the Dapr SDKs or APIs to access the Dapr component. | `myapp-mysecretstore` |

## Available Dapr components

The following resources can act as a `dapr.io.SecretStore` resource:

| kind | Resource |
|------|----------|
| `generic` | [See below](#generic)

### Generic

A generic secretstore lets you manually specify the metadata of a Dapr secret store. When `kind` is set to `generic`, you can specify `type`, `metadata`, and `version` to create a Dapr component spec. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-secret-stores/).

{{< rad file="snippets/dapr-secretstore-generic.bicep" embed=true marker="//SAMPLE" >}}

## Injected values

Connections from [Radius services]({{< ref services >}}) to [links]({{< ref links >}}) by default inject the following values into the environment of the service:

| Key | Value |
|-----|-------|
| `CONNECTION_<CONNECTIONNAME>_COMPONENTNAME` | `properties.componentName` |

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
| name | y | The name of the resource. Names must contain at most 63 characters, contain only lowercase alphanumeric characters, '-', or '.', start with an alphanumeric character, and end with an alphanumeric character. | `my-secretstore` |
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| resourceProvisioning | n | Specifies how the underlying service/resource is provisioned and managed. Options are to provision automatically via 'recipe' or provision manually via 'manual'. Selection determines which set of fields to additionally require. | `manual`
| type | n | The Dapr component type. Used when resourceProvisioning is `manual`. | `secretstores.azure.keyvault`
| metadata | n | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-secret-stores/) | `vaultName: 'test'` |
| version | n | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-secret-stores/) for available versions. | `v1` |
| componentName | n | _(read-only)_ The name of the Dapr component that is generated and applied to the underlying system. Used by the Dapr SDKs or APIs to access the Dapr component. | `mysecretstore` |

## Value backed Link

You can also manually specify the metadata of a Dapr state store. When `resourceProvisioning` is set to `manual`, you can specify `type`, `metadata`, and `version` to create a Dapr component spec. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-secret-stores/).

{{< rad file="snippets/dapr-secretstore-generic.bicep" embed=true marker="//SAMPLE" >}}

## Injected values

Connections from [Radius services]({{< ref container >}}) to [links]({{< ref links-resources >}}) by default inject the following values into the environment of the service:

| Key | Value |
|-----|-------|
| `CONNECTION_<CONNECTIONNAME>_COMPONENTNAME` | `properties.componentName` |

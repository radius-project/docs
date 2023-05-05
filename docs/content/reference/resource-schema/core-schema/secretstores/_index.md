---
type: docs
title: "Secret Store"
linkTitle: "SecretStore"
description: "Learn how to use Secret Store"
weight: 400
---

Sensitive data, such as TLS certificates, passwords, and keys, are referred to as a secret. A Radius secret store enables you to store these secrets or reference the existing secrets in external storage solutions, such as Azure Keyvault or AWS Secrets Manager. For instance, Applications.Core/gateways resource can use this resource to store a TLS certificate and reference it.

## Resource format

{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRETSTORENEW" >}}

{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRETSTOREREF" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your HttpRoute. Used to provide status and visualize the resource. | `'web'`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Property | Description | Example |
|----------|-------------|-------------|
| application | The ID of the application resource this resource belongs to. | `app.id` |

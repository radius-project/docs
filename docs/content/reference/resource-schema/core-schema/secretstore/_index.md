---
type: docs
title: "Radius Secret Store"
linkTitle: "SecretStore"
description: "Learn about Radius Secret Store"
---

Sensitive data, such as TLS certificates, tokens, passwords, and keys that serve as digital authentication credentials are commonly referred to as secrets. A Radius secret store enables you to either store these secrets or reference existing secrets stored in external secret management solutions, such as Azure Keyvault or AWS Secrets Manager. An independent resource with its own lifecycle, a Radius secret store ensures that data is persisted across container restarts or mounts and can interact directly with the Radius Application Model. For instance, Applications.Core/gateways resource can use this resource to store a TLS certificate and reference it.

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
---
type: docs
title: "Radius.Storage/objectStorage@2025-08-01-preview"
linkTitle: "ObjectStorage"
---

{{< schemaExample >}}

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `accountName` | string | The Azure Storage account name. Mapped from the recipe module's `name` output. |
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `containerName` | string | (Optional) The object container (blob container / S3 bucket) name to create inside the storage account. Defaults to `data` if not provided. |
| `endpoint` | string | The object storage endpoint used to connect to the store. Mapped from the recipe module's `primaryBlobEndpoint` output. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `secrets` | [object](#secrets) | (Read-only) Recipe secrets. The reserved `name` sub-property references the managed Radius.Security/secrets resource Radius materializes from the recipe's `outputs.secrets`; the other sub-properties declare secret keys whose values are written only into that managed secret (never onto this resource). Consumers bind a key into a container env var via `secretKeyRef`, using `<resource>.properties.secrets.name` as `secretName`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

### `secrets` {#secrets}

| Property | Type | Description |
|----------|------|-------------|
| `accountKey` | string | The Azure Storage account access key. Mapped from the recipe module's `primaryAccessKey` output; delivered via the managed secret. |
| `connectionString` | string | The storage account connection string. Mapped from the recipe module's `primaryConnectionString` output; delivered via the managed secret. |
| `name` | string | (Reserved) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |

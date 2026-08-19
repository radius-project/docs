---
type: docs
title: "Radius.Storage/objectStorage@2025-08-01-preview"
linkTitle: "ObjectStorage"
---

{{< schemaExample >}}

## Description

The Radius.Storage/objectStorage Resource Type deploys an object storage
container (an S3-style bucket / Azure Blob container / GCS bucket). To deploy
one, add an objectStorage resource to the application definition Bicep file.
Unlike database types, no secret is required from the developer: Azure Storage
generates its own account keys, so the platform-engineer recipe needs no
injected credentials.
```bicep
resource store 'Radius.Storage/objectStorage@2025-08-01-preview' = {
  name: 'store'
  properties: {
    environment: environment
    application: myApplication.id
    containerName: 'data'
  }
}
```

To connect your container to the store, create a connection from the
Container resource to the store as shown below. This verification test is
provisioning-only because the stock demo image has no Azure Blob backend, but
the type still exposes a connection surface for applications that can use it.
```bicep
resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    application: myApplication.id
    environment: environment
    container: {
      image: 'frontend:1.25'
    }
    connections: {
      storage: {
        source: store.id
      }
    }
  }
}
```

The connection automatically injects environment variables into the
container for all properties from the store. The environment variables are
named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`. In this example the
connection name is `storage` so the environment variables will be:

- CONNECTION_STORAGE_CONTAINERNAME
- CONNECTION_STORAGE_ENDPOINT
- CONNECTION_STORAGE_ACCOUNTNAME

The `connectionString` and `accountKey` secrets are NOT injected via the
connection — they are materialized into a managed `Radius.Security/secrets`
resource. Bind them into container env vars with a `secretKeyRef`, using
`store.properties.secrets.name` as the `secretName` and the desired key
(`connectionString` or `accountKey`; see the `secrets` property).

The schema is platform-neutral: the same developer-facing properties can be
backed by Azure Blob Storage, AWS S3, or a Kubernetes object-store recipe by
changing only the platform recipe's module source, parameters, and outputs.

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

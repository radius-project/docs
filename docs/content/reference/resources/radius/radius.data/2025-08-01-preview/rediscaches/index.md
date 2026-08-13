---
type: docs
title: "Reference: radius.data/rediscaches@2025-08-01-preview"
linkTitle: "rediscaches"
description: "Detailed reference documentation for radius.data/rediscaches@2025-08-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

The Radius.Data/redisCaches Resource Type deploys a Redis cache. To deploy a
Redis cache, add a redisCaches resource to the application definition Bicep
file. Unlike database types, no secret is required: Azure Managed Redis
generates its own access keys, so the platform-engineer recipe needs no
injected credentials.
```bicep
resource cache 'Radius.Data/redisCaches@2025-08-01-preview' = {
  name: 'redis'
  properties: {
    environment: environment
    application: myApplication.id
    size: 'S'
  }
}
```

To connect your container to the cache, create a connection from the
Container resource to the cache as shown below.
```bicep
resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    application: myApplication.id
    environment: environment
    containers: {
      frontend: {
        image: 'frontend:1.25'
      }
    }
    connections: {
      redis: {
        source: cache.id
      }
    }
  }
}
```

The connection automatically injects environment variables into the
container for all properties from the cache. The environment variables are
named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`. In this example the
connection name is `redis` so the environment variables will be:

- CONNECTION_REDIS_HOST
- CONNECTION_REDIS_PORT

The `url` secret is NOT injected via the connection — it is materialized into
a managed `Radius.Security/secrets` resource. Bind it into a container env var
with a `secretKeyRef`, using `redis.properties.secrets.name` as the `secretName`
and key `url` (see the `secrets` property).

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | false | false | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | false | false | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | false | false | Map of connection name to connection data. |
| `environment` | string | true | false | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | false | true | (Read Only) The host name used to connect to the cache. Mapped from the recipe module's output. |
| `port` | integer | false | true | (Read Only) The TLS port number used to connect to the cache. Mapped from the recipe module's `port` output (Azure Managed Redis uses 10000). |
| `secrets` | [object](#secrets) | false | false | (Read-only) Recipe secrets. The reserved `name` sub-property references the managed Radius.Security/secrets resource Radius materializes from the recipe's `outputs.secrets`; the other sub-properties declare secret keys whose values are written only into that managed secret (never onto this resource). Consumers bind a key into a container env var via `secretKeyRef`, using `<resource>.properties.secrets.name` as `secretName`. |
| `size` | string | false | false | (Optional) The size of the Redis cache. Defaults to `S` if not provided. The recipe maps the size onto a concrete cloud SKU.<br />Allowed values: `L`, `M`, `S`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `disableDefaultEnvVars` | boolean | false | false | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | true | false | Resource ID of the source resource for this connection. |

### `secrets` {#secrets}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `name` | string | false | true | (Reserved) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |
| `url` | string | false | true | (Read Only) The full TLS connection URL (`rediss://:<access-key>@<host>:<port>`) used to connect to the cache, including the access key. Mapped from the recipe module's `primaryConnectionString` output; delivered via the managed secret. |

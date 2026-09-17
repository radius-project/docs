---
type: docs
title: "Radius.Data/redisCaches@2025-08-01-preview"
linkTitle: "RedisCaches"
---

{{< schemaExample >}}

## Description

The Radius.Data/redisCaches Resource Type deploys a Redis cache. To deploy a
Redis cache, add a redisCaches resource to the application definition Bicep
file. Unlike database types, no credential has to be supplied: the cache
generates its own access key, so the platform-engineer recipe needs no
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

On compatible Kubernetes Container Recipes, the connection injects environment
variables into the container for the cache properties. The variables are
named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`. In this example the
connection name is `redis` so the environment variables will be:

- CONNECTION_REDIS_HOST
- CONNECTION_REDIS_PORT

Recipe-generated secrets are materialized into a managed
`Radius.Security/secrets` resource. With Radius control-plane support from
`radius-project/radius#12709` and Kubernetes Container Recipe support from
`resource-types-contrib#300` or later, the same `redis` connection injects each
key returned in `result.secrets`: `CONNECTION_REDIS_URL`, and
`CONNECTION_REDIS_ACCESSKEY` when the Recipe returns `accessKey`. `host` and
`port` remain ordinary values.

For custom, older, or mixed-version Kubernetes deployments, bind the key
explicitly with `secretKeyRef`, using `cache.properties.secrets.name` as the
`secretName`. Use `url` for a client that parses a connection URL, or
`accessKey` for a client that takes host, port, and password separately:

```bicep
env: {
  REDIS_ADDR: {
    value: '${cache.properties.host}:${cache.properties.port}'
  }
  REDIS_PASSWORD: {
    valueFrom: {
      secretKeyRef: {
        secretName: cache.properties.secrets.name
        key: 'accessKey'
      }
    }
  }
}
```

A recipe that provisions a cache requiring no credential does not map
`accessKey`; bind it only against a recipe that declares it.

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | (Read Only) The host name used to connect to the cache. Mapped from the recipe module's output. |
| `port` | integer | (Read Only) The TLS port number used to connect to the cache. Mapped from the recipe module's `port` output (Azure Managed Redis uses 10000). |
| `secrets` | [object](#secrets) | (Read-only) Recipe secrets. The reserved `name` sub-property references the managed Radius.Security/secrets resource Radius materializes from the Recipe's `result.secrets`; the other sub-properties declare secret keys whose values are written only into that managed secret (never onto this resource). Consumers bind a key into a container env var via `secretKeyRef`, using `<resource>.properties.secrets.name` as `secretName`. |
| `size` | string | (Optional) The size of the Redis cache. Defaults to `S` if not provided. The recipe maps the size onto a concrete cloud SKU.<br />Allowed values: `L`, `M`, `S`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

### `secrets` {#secrets}

| Property | Type | Description |
|----------|------|-------------|
| `accessKey` | string | (Read Only) The access key on its own, for clients that take host, port, and password separately instead of parsing a URL — it is the password such a client authenticates with. Mapped from the recipe module's `primaryAccessKey` output; delivered via the managed secret. Declared by recipes that provision an authenticated cache — a recipe provisioning a cache that needs no credential (such as the in-cluster Kubernetes recipe) does not map this key. |
| `name` | string | (Reserved) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |
| `url` | string | (Read Only) The full TLS connection URL (`rediss://:<access-key>@<host>:<port>`) used to connect to the cache, including the access key. Mapped from the recipe module's `primaryConnectionString` output; delivered via the managed secret. |

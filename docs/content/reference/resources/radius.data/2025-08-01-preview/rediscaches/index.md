---
type: docs
title: "Radius.Data/redisCaches@2025-08-01-preview"
linkTitle: "RedisCaches"
---

{{< schemaExample >}}

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | (Read Only) The host name used to connect to the cache. Mapped from the recipe module's output. |
| `port` | integer | (Read Only) The TLS port number used to connect to the cache. Mapped from the recipe module's `port` output (Azure Managed Redis uses 10000). |
| `secrets` | [object](#secrets) | (Read-only) Recipe secrets. The reserved `name` sub-property references the managed Radius.Security/secrets resource Radius materializes from the recipe's `outputs.secrets`; the other sub-properties declare secret keys whose values are written only into that managed secret (never onto this resource). Consumers bind a key into a container env var via `secretKeyRef`, using `<resource>.properties.secrets.name` as `secretName`. |
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
| `name` | string | (Reserved) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |
| `url` | string | (Read Only) The full TLS connection URL (`rediss://:<access-key>@<host>:<port>`) used to connect to the cache, including the access key. Mapped from the recipe module's `primaryConnectionString` output; delivered via the managed secret. |

---
type: docs
title: "Radius.Data/postgreSqlDatabases@2025-08-01-preview"
linkTitle: "PostgreSqlDatabases"
---

{{< schemaExample >}}

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `database` | string | (Optional) The name of the database. Defaults to `postgres_db` if not provided. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | The host name used to connect to the database. |
| `initSql` | string | (Optional) SQL script mounted into the PostgreSQL container's `/docker-entrypoint-initdb.d/` directory and executed whenever PGDATA is empty. With the default ephemeral storage this runs on every pod restart. If a PersistentVolumeClaim is used, the script runs only on the very first startup and subsequent changes to initSql are ignored on existing volumes. Limited to ~1 MiB. Useful for creating tables, indexes, and inserting seed data. |
| `password` | string | (Required) The administrator password for the PostgreSQL database. Marked `x-radius-sensitive`: Radius encrypts it at rest, redacts it on reads, and exposes it decrypted only to the recipe as `{{context.resource.properties.password}}`. |
| `port` | string | The port number used to connect to the database. |
| `size` | string | (Optional) The size of the PostgreSQL database. Defaults to `S` if not provided.<br />Allowed values: `L`, `M`, `S`. |
| `username` | string | (Required) The administrator username for the PostgreSQL database. Provided directly on the resource and passed to the recipe as `{{context.resource.properties.username}}`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

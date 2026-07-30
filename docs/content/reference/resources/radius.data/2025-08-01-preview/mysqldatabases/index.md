---
type: docs
title: "Radius.Data/mySqlDatabases@2025-08-01-preview"
linkTitle: "MySqlDatabases"
---

{{< schemaExample >}}

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `database` | string | (Optional) The name of the database. Defaults to `mysql_db` if not provided. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | The host name used to connect to the database. Mapped from the recipe module's output. |
| `password` | string | (Required) The administrator password for the MySQL database. Marked `x-radius-sensitive`: Radius encrypts it at rest, redacts it on reads, and exposes it decrypted only to the recipe as `{{context.resource.properties.password}}`. |
| `port` | integer | The port number used to connect to the database. Mapped from the recipe module's output (MySQL flexible server uses 3306). |
| `username` | string | (Required) The administrator username for the MySQL database. Provided directly on the resource and passed to the recipe as `{{context.resource.properties.username}}`. |
| `version` | string | (Optional) The major MySQL server version in the X.Y format. Assumed to be 8.4 if not specified.<br />Allowed values: `5.7`, `8.0`, `8.4`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

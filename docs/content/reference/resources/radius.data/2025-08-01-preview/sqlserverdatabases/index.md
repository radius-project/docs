---
type: docs
title: "Radius.Data/sqlServerDatabases@2025-08-01-preview"
linkTitle: "SqlServerDatabases"
---

{{< schemaExample >}}

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `database` | string | (Required) The SQL database name to create on the server. Defaults to `appdb` in the sample application. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | The SQL Server fully qualified domain name. Mapped from the recipe module's `fullyQualifiedDomainName` output. |
| `password` | string | (Required) The administrator password for the SQL database. Marked `x-radius-sensitive`: Radius encrypts it at rest, redacts it on reads, and exposes it decrypted only to the recipe as `{{context.resource.properties.password}}`. |
| `port` | string | The SQL Server TCP port. Azure SQL Database listens on 1433. |
| `username` | string | (Required) The administrator username for the SQL database. Provided directly on the resource and passed to the recipe as `{{context.resource.properties.username}}`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

---
type: docs
title: "Radius.Data/sqlServerDatabases@2025-08-01-preview"
linkTitle: "SqlServerDatabases"
---

{{< schemaExample >}}

## Description

The Radius.Data/sqlServerDatabases Resource Type deploys a SQL database. Provide the administrator `username` and `password` directly on the resource. The `password` property is marked `x-radius-sensitive`, so Radius encrypts it at rest, redacts it on reads, and exposes it (decrypted) only to the recipe that provisions the database.
```
resource sqlserver 'Radius.Data/sqlServerDatabases@2025-08-01-preview' = {
  name: 'sqlserver'
  properties: {
    environment: environment
    application: myApplication.id
    database: 'appdb'
    username: 'myadmin'
    // From a @secure() password parameter passed in via the CLI
    password: password
  }
}
```

When deploying the application definition, provide the database password value as a parameter. It is recommended to use a password generator such as `openssl` or equivalent. For example, `rad deploy app.bicep -p password=$(openssl rand -hex 16)`.

To connect your container to the database, create a connection from the
Container resource to the database as shown below. This verification test is
provisioning-only because the stock demo image has no SQL Server backend, but
the type still exposes a connection surface for applications that can use it.
```
resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    application: myApplication.id
    environment: environment
    container: {
      image: 'frontend:1.25'
    }
    connections: {
      sqlserver: {
        source: sqlserver.id
      }
    }
  }
}
```

The connection automatically injects environment variables into the
container for all properties from the database. The environment variables are
named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`. In this example the
connection name is `sqlserver` so the environment variables will be:

- CONNECTION_SQLSERVER_DATABASE
- CONNECTION_SQLSERVER_HOST
- CONNECTION_SQLSERVER_PORT

The schema is platform-neutral: the same developer-facing properties can be
backed by Azure SQL Database, AWS RDS for SQL Server, or a Kubernetes SQL
Server recipe by changing only the platform recipe's module source,
parameters, and outputs. Azure maps host from the AVM
`fullyQualifiedDomainName` output; AWS Terraform would map an RDS endpoint;
Kubernetes would map a Service DNS name.

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

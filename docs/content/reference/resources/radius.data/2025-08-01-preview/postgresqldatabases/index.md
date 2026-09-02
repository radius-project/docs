---
type: docs
title: "Radius.Data/postgreSqlDatabases@2025-08-01-preview"
linkTitle: "PostgreSqlDatabases"
---

{{< schemaExample >}}

## Description

The Radius.Data/postgreSqlDatabases Resource Type deploys a PostgreSQL database. Provide the administrator `username` and `password` directly on the resource. The `password` property is marked `x-radius-sensitive`, so Radius encrypts it at rest, redacts it on reads, and exposes it (decrypted) only to the recipe that provisions the database.
```bicep
resource postgresql 'Radius.Data/postgreSqlDatabases@2025-08-01-preview' = {
    name: 'postgresql'
    properties: {
      environment: environment
      application: myApplication.id
      size: 'S'
      database: 'appdb'
      username: 'myadmin'
      // From a @secure() password parameter passed in via the CLI
      password: password
    }
  }
```

When deploying the application definition, provide the database password value as a parameter. It is recommended to use a password generator such as `openssl` or equivalent. For example, `rad deploy app.bicep -p password=$(openssl rand -hex 16)`.

To connect your container to the database, create a connection from the Container resource to the database as shown below. 
```bicep
resource myApplication 'Radius.Core/Applications@2025-08-01-preview' = { ... }

resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    application: myApplication.id
    environment: environment
    container: {
      image: 'frontend:1.25'
      ports: {
        web: {
          containerPort: 8080
        }
      }
    }
    connections: {
      postgresql: {
        source: postgresql.id
      }
    }
  }
}
```

The connection automatically injects environment variables into the container for all properties from the database. The environment variables are named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`. In this example, the connection name is `postgresql` so the environment variables will be:

- CONNECTION_POSTGRESQL_DATABASE
- CONNECTION_POSTGRESQL_HOST
- CONNECTION_POSTGRESQL_PORT

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `database` | string | (Optional) The name of the database. Defaults to `postgres_db` if not provided. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | (Read Only) The host name used to connect to the database. Mapped from the recipe module's output. |
| `initSql` | string | (Optional) SQL script mounted into the PostgreSQL container's `/docker-entrypoint-initdb.d/` directory and executed whenever PGDATA is empty. With the default ephemeral storage this runs on every pod restart. If a PersistentVolumeClaim is used, the script runs only on the very first startup and subsequent changes to initSql are ignored on existing volumes. Limited to ~1 MiB. Useful for creating tables, indexes, and inserting seed data. |
| `password` | string | (Required) The administrator password for the PostgreSQL database. Marked `x-radius-sensitive`: Radius encrypts it at rest, redacts it on reads, and exposes it decrypted only to the recipe as `{{context.resource.properties.password}}`. |
| `port` | integer | (Optional) The TCP port used to connect to the database. Defaults to `5432`, the standard PostgreSQL port that every Recipe in this repository provisions and the port PostgreSQL flexible server is fixed to. A Recipe that provisions the database on a different port reports the real port as an output, which overwrites this value once the deployment finishes. Setting it in an application definition changes only the value reported to connected containers, never the port the server listens on, so leave it unset. |
| `size` | string | (Optional) The size of the PostgreSQL database. Defaults to `S` if not provided.<br />Allowed values: `L`, `M`, `S`. |
| `username` | string | (Required) The administrator username for the PostgreSQL database. Provided directly on the resource and passed to the recipe as `{{context.resource.properties.username}}`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

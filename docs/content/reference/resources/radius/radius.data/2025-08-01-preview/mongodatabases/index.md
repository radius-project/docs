---
type: docs
title: "Reference: radius.data/mongodatabases@2025-08-01-preview"
linkTitle: "mongodatabases"
description: "Detailed reference documentation for radius.data/mongodatabases@2025-08-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

The Radius.Data/mongoDatabases Resource Type deploys a Mongo-compatible
database. To deploy a Mongo database, add a mongoDatabases resource to the
application definition Bicep file. The Azure recipe uses Cosmos DB for
MongoDB and exposes its endpoint and connection string as resource
properties.
```bicep
resource database 'Radius.Data/mongoDatabases@2025-08-01-preview' = {
  name: 'mongo'
  properties: {
    environment: environment
    application: myApplication.id
    database: 'mongo_db'
  }
}
```

To connect your container to the database, create a connection from the
Container resource to the database as shown below.
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
      mongo: {
        source: database.id
      }
    }
  }
}
```

The connection automatically injects environment variables into the
container for all properties from the database. The environment variables
are named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`. In this example
the connection name is `mongo` so the environment variables will be:

- CONNECTION_MONGO_DATABASE
- CONNECTION_MONGO_ENDPOINT

The `connectionString` secret is NOT injected via the connection — it is
materialized into a managed `Radius.Security/secrets` resource. Bind it into
a container env var with a `secretKeyRef`, using `mongo.properties.secrets.name`
as the `secretName` and key `connectionString` (see the `secrets` property).

Portability note: this schema is platform-neutral so the same resource
type works with Azure AVM, AWS Terraform modules, and Kubernetes recipes.
Only the recipePack source plus parameters/outputs mapping change per
platform; the developer-facing database knob and read-only connection
surface stay identical.

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | false | false | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | false | false | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | false | false | Map of connection name to connection data. |
| `database` | string | false | false | (Optional) The Mongo database name. Defaults to `mongo_db` if not provided. |
| `endpoint` | string | false | true | The endpoint used to connect to the database. Mapped from the recipe module's output. |
| `environment` | string | true | false | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `secrets` | [object](#secrets) | false | false | (Read-only) Recipe secrets. The reserved `name` sub-property references the managed Radius.Security/secrets resource Radius materializes from the recipe's `outputs.secrets`; the other sub-properties declare secret keys whose values are written only into that managed secret (never onto this resource). Consumers bind a key into a container env var via `secretKeyRef`, using `<resource>.properties.secrets.name` as `secretName`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `disableDefaultEnvVars` | boolean | false | false | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | true | false | Resource ID of the source resource for this connection. |

### `secrets` {#secrets}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `connectionString` | string | false | true | The connection string used to connect to the database. Mapped from the recipe module's output; delivered via the managed secret. |
| `name` | string | false | true | (Reserved) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |

---
type: docs
title: "Radius.Data/mongoDatabases@2025-08-01-preview"
linkTitle: "MongoDatabases"
---

{{< schemaExample >}}

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

On compatible Kubernetes Container Recipes, the connection injects environment
variables into the container for the database properties. The variables
are named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`. In this example
the connection name is `mongo` so the environment variables will be:

- CONNECTION_MONGO_DATABASE
- CONNECTION_MONGO_ENDPOINT
- CONNECTION_MONGO_CONNECTIONSTRING (secret-backed)

With Radius control-plane support from `radius-project/radius#12709` and
Kubernetes Container Recipe support from `resource-types-contrib#300` or
later, the same connection injects `connectionString` through a Kubernetes
secret reference. For custom, older, or mixed-version Kubernetes deployments,
use `mongo.properties.secrets.name` as the `secretName` and `connectionString`
as the key in an explicitly authored `secretKeyRef`.

Portability note: this schema is platform-neutral so the same resource
type works with Azure AVM, AWS Terraform modules, and Kubernetes recipes.
Only the recipePack source plus parameters/outputs mapping change per
platform; the developer-facing database knob and read-only connection
surface stay identical.

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `database` | string | (Optional) The Mongo database name. Defaults to `mongo_db` if not provided. |
| `endpoint` | string | The endpoint used to connect to the database. Mapped from the recipe module's output. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `secrets` | [object](#secrets) | (Read-only) Recipe secrets. The reserved `name` sub-property references the managed Radius.Security/secrets resource Radius materializes from the Recipe's `result.secrets`; the other sub-properties declare secret keys whose values are written only into that managed secret (never onto this resource). Consumers bind a key into a container env var via `secretKeyRef`, using `<resource>.properties.secrets.name` as `secretName`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

### `secrets` {#secrets}

| Property | Type | Description |
|----------|------|-------------|
| `connectionString` | string | The connection string used to connect to the database. Mapped from the recipe module's output; delivered via the managed secret. |
| `name` | string | (Reserved) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |

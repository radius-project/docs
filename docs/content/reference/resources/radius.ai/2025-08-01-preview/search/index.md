---
type: docs
title: "Radius.AI/search@2025-08-01-preview"
linkTitle: "Search"
---

{{< schemaExample >}}

## Description

The Radius.AI/search Resource Type deploys a search service. To
deploy a search service, add a search resource to the application
definition Bicep file. The platform-engineer recipe provisions the concrete
backend and maps its endpoint and API key outputs back onto this resource.
```bicep
resource search 'Radius.AI/search@2025-08-01-preview' = {
  name: 'search'
  properties: {
    environment: environment
    application: myApplication.id
  }
}
```

To connect your container to the service, create a connection from the
Container resource to the search service as shown below.
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
      search: {
        source: search.id
      }
    }
  }
}
```

The connection automatically injects environment variables into the
container for all properties from the search service. The environment
variables are named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`. In this
example the connection name is `search` so the environment variables will be:

- CONNECTION_SEARCH_ENDPOINT

The `apiKey` secret is NOT injected via the connection — it is materialized
into a managed `Radius.Security/secrets` resource. Bind it into a container
env var with a `secretKeyRef`, using `search.properties.secrets.name` as the
`secretName` and key `apiKey` (see the `secrets` property).

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `endpoint` | string | The endpoint used to connect to the search service. Mapped from the recipe module's output. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `secrets` | [object](#secrets) | (Read-only) Recipe secrets. The reserved `name` sub-property references the managed Radius.Security/secrets resource Radius materializes from the recipe's `outputs.secrets`; the other sub-properties declare secret keys whose values are written only into that managed secret (never onto this resource). Consumers bind a key into a container env var via `secretKeyRef`, using `<resource>.properties.secrets.name` as `secretName`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

### `secrets` {#secrets}

| Property | Type | Description |
|----------|------|-------------|
| `apiKey` | string | The admin API key used to connect to the search service. Mapped from the recipe module's output; delivered via the managed secret. |
| `name` | string | (Reserved) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |

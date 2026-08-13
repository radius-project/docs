---
type: docs
title: "Reference: radius.ai/models@2025-08-01-preview"
linkTitle: "models"
description: "Detailed reference documentation for radius.ai/models@2025-08-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

The Radius.AI/models Resource Type deploys an LLM inference model endpoint.
To deploy a model, add a models resource to the application definition Bicep
file. The platform-engineer recipe binds this developer-facing contract to a
managed cloud model service without exposing any module details to the app.
```bicep
resource model 'Radius.AI/models@2025-08-01-preview' = {
  name: 'model'
  properties: {
    environment: environment
    application: myApplication.id
    model: 'gpt-5-mini'
  }
}
```

To connect your container to the model, create a connection from the
Container resource to the model as shown below.
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
      llm: {
        source: model.id
      }
    }
  }
}
```

The connection automatically injects environment variables into the
container for all properties from the model. The environment variables are
named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`. In this example the
connection name is `llm` so the environment variables will be:

- CONNECTION_LLM_MODEL
- CONNECTION_LLM_ENDPOINT

The `apiKey` secret is NOT injected via the connection — it is materialized
into a managed `Radius.Security/secrets` resource. Bind it into a container
env var with a `secretKeyRef`, using `model.properties.secrets.name` as the
`secretName` and key `apiKey` (see the `secrets` property).

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | false | false | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | false | false | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | false | false | Map of connection name to connection data. |
| `endpoint` | string | false | true | (Read Only) The base URL used to call the model inference endpoint. Mapped from the recipe module's output. |
| `environment` | string | true | false | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `model` | string | false | false | (Optional) The model deployment to provision. Defaults to `gpt-5-mini` if not provided. |
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
| `apiKey` | string | false | true | (Read Only) The API key used to call the model inference endpoint. Mapped from the recipe module's `primaryKey` output; delivered via the managed secret. |
| `name` | string | false | true | (Reserved) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |

---
type: docs
title: "Radius.Messaging/kafka@2025-08-01-preview"
linkTitle: "Kafka"
---

{{< schemaExample >}}

## Description

The Radius.Messaging/kafka Resource Type deploys a Kafka-compatible
messaging namespace. On Azure, the verification recipe provisions Azure
Event Hubs with its Kafka surface enabled by the Standard tier and creates
an Event Hub named by the developer-authored `topic` property.
```bicep
resource kafka 'Radius.Messaging/kafka@2025-08-01-preview' = {
  name: 'kafka'
  properties: {
    environment: environment
    application: myApplication.id
    topic: 'events'
  }
}
```

To connect a container to the cluster, create a connection from the
Container resource to the Kafka cluster as shown below.
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
      kafka: {
        source: kafka.id
      }
    }
  }
}
```

On compatible Kubernetes Container Recipes, the connection injects environment
variables into the container for the Kafka properties. The variables are
named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`. In this example the
connection name is `kafka` so the environment variables will be:

- CONNECTION_KAFKA_HOST
- CONNECTION_KAFKA_CONNECTIONSTRING (secret-backed)

With Radius control-plane support from `radius-project/radius#12709` and
Kubernetes Container Recipe support from `resource-types-contrib#300` or
later, the same connection injects `connectionString` through a Kubernetes
secret reference. For custom, older, or mixed-version Kubernetes deployments,
use `kafka.properties.secrets.name` as the `secretName` and `connectionString`
as the key in an explicitly authored `secretKeyRef`.

Portability note: the schema is platform-neutral so the same type works
with Azure AVM (Bicep), AWS Terraform registry modules, and Kubernetes
recipes. Only the recipePack `source` plus `parameters`/`outputs` mapping
change per platform; the developer-facing properties (knobs and readOnly
connection surface) stay identical. For example, Azure maps `host` from the
Event Hubs namespace name while AWS MSK can map it from Terraform
`bootstrap_brokers`, and a Kubernetes Strimzi/Kafka recipe can map it from
the broker bootstrap Service DNS.

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | The host name used to connect to the Kafka-compatible endpoint. For Azure Event Hubs this is the namespace name; the bootstrap server is `<host>.servicebus.windows.net:9093`. |
| `secrets` | [object](#secrets) | (Read-only) Recipe secrets. The reserved `name` sub-property references the managed Radius.Security/secrets resource Radius materializes from the Recipe's `result.secrets`; the other sub-properties declare secret keys whose values are written only into that managed secret (never onto this resource). Consumers bind a key into a container env var via `secretKeyRef`, using `<resource>.properties.secrets.name` as `secretName`. |
| `topic` | string | (Optional) The Kafka topic/Event Hub name to create. Defaults to `events`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

### `secrets` {#secrets}

| Property | Type | Description |
|----------|------|-------------|
| `connectionString` | string | The connection string used to connect to the Kafka-compatible endpoint. Mapped from the recipe module's `primaryConnectionString` output; delivered via the managed secret. |
| `name` | string | (Reserved) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |

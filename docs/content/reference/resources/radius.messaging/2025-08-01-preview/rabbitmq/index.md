---
type: docs
title: "Radius.Messaging/rabbitMQ@2025-08-01-preview"
linkTitle: "RabbitMQ"
---

{{< schemaExample >}}

## Description

The Radius.Messaging/rabbitMQ Resource Type deploys a queue-compatible
messaging resource. In the Azure verification recipe, the platform engineer
maps this type to Azure Service Bus using the Service Bus AMQP endpoint. This
provisions the resource and maps its connection outputs; it does not prove
RabbitMQ broker API compatibility.
```
resource queue 'Radius.Messaging/rabbitMQ@2025-08-01-preview' = {
  name: 'rabbitmq'
  properties: {
    environment: environment
    application: myApplication.id
    queue: 'jobs'
  }
}
```

To connect your workload to the queue, create a connection from the workload
resource to the queue resource. The connection automatically injects
environment variables named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`.
For a connection named `rabbitmq`, the variables are:

- CONNECTION_RABBITMQ_HOST

The `connectionString` secret is NOT injected via the connection — it is
materialized into a managed `Radius.Security/secrets` resource. Bind it into
a container env var with a `secretKeyRef`, using `rabbitmq.properties.secrets.name`
as the `secretName` and key `connectionString` (see the `secrets` property).

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | The host or namespace name used to connect to the queue. Mapped from the recipe module's output. |
| `queue` | string | (Optional) The queue name to create. Defaults to `jobs` if not provided. |
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
| `connectionString` | string | The primary connection string used to connect to the queue. Mapped from the recipe module's output; delivered via the managed secret. |
| `name` | string | (Reserved) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |

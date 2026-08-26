---
type: docs
title: "Radius.Messaging/rabbitMQ@2025-08-01-preview"
linkTitle: "RabbitMQ"
---

{{< schemaExample >}}

## Description

The Radius.Messaging/rabbitMQ Resource Type deploys a RabbitMQ message broker
that speaks AMQP 0-9-1. It allows developers to create and connect to a queue
as part of their Radius applications.

You can provision the broker password by creating a `Radius.Security/secrets`
resource and passing its resource ID on the optional `password` property. If
omitted, the Kubernetes Recipe generates a random password and returns it
through the resource's managed secrets. In both cases, the password is mounted
into the broker via `secretKeyRef`.
```bicep
@secure()
param password string

resource rabbitmqSecret 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'rabbitmq-credentials'
  properties: {
    environment: environment
    application: myApplication.id
    data: {
      password: {
        value: password
      }
    }
  }
}

resource queue 'Radius.Messaging/rabbitMQ@2025-08-01-preview' = {
  name: 'rabbitmq'
  properties: {
    environment: environment
    application: myApplication.id
    queue: 'jobs'
    username: 'radius'
    password: rabbitmqSecret.id
  }
}
```

To connect your workload to the queue, create a connection from the workload
resource to the queue resource. The connection automatically injects
environment variables named `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`.
For a connection named `rabbitmq`, the variables are:

- CONNECTION_RABBITMQ_HOST
- CONNECTION_RABBITMQ_PORT
- CONNECTION_RABBITMQ_USERNAME

When `password` is supplied, bind the same `Radius.Security/secrets` resource
into the workload. When it is omitted, bind the Recipe-generated managed
secret using `queue.properties.secrets.name` as the `secretName`. In both cases,
use key `password`.

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | (Read Only) The host name used to connect to the broker. Mapped from the recipe's Service DNS name. |
| `password` | string | (Optional) The resource ID of the `Radius.Security/secrets` resource that holds the broker password under the data key `password`. Set to `<secretResource>.id`. If omitted, the Kubernetes Recipe generates a random password and returns it through the managed `secrets.password` output. |
| `port` | integer | (Read Only) The port used to connect to the broker over AMQP 0-9-1 (5672). Mapped from the recipe's output. |
| `queue` | string | (Optional) The name of the queue to pre-provision on the broker. The Recipe creates this durable queue on the default virtual host when the broker starts, so it exists before your workload connects. Defaults to `jobs` if not provided. |
| `secrets` | [object](#secrets) | (Read Only) Recipe-generated secrets. The reserved `name` sub-property references the managed Radius.Security/secrets resource Radius materializes from the Recipe's `outputs.secrets`. Consumers bind a key into a container env var via `secretKeyRef`. |
| `username` | string | (Optional) The username the broker is provisioned with and that clients authenticate as. Defaults to `radius` if not provided. Avoid `guest`, which RabbitMQ restricts to loopback connections. The username is not sensitive and is exposed as a read-only connection value. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

### `secrets` {#secrets}

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | (Read Only) Name of the managed Radius.Security/secrets resource. Use as `secretName` in a container `secretKeyRef`. |
| `password` | string | (Read Only) The Recipe-generated fallback password, delivered through the managed secret when the `password` input is omitted. |

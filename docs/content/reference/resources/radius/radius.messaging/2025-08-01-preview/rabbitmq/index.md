---
type: docs
title: "Reference: radius.messaging/rabbitmq@2025-08-01-preview"
linkTitle: "rabbitmq"
description: "Detailed reference documentation for radius.messaging/rabbitmq@2025-08-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

The Radius.Messaging/rabbitMQ Resource Type deploys a RabbitMQ message broker
that speaks AMQP 0-9-1. It allows developers to create and connect to a queue
as part of their Radius applications.

Provision the broker password by creating a `Radius.Security/secrets` resource
(with the value passed to `rad deploy` as a `@secure()` parameter) and pass its
resource ID on the `password` property. The Recipe references the
materialized Kubernetes Secret by name and mounts the password into the broker
via `secretKeyRef`, so the plaintext password is never written into the pod spec
or onto this resource.
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

The password is NOT emitted by this resource. Read it from the same
`Radius.Security/secrets` resource you created above by binding it into a
container env var with a `secretKeyRef`, using `rabbitmqSecret.name` as the
`secretName` and key `password`.

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | false | false | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | false | false | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | false | false | Map of connection name to connection data. |
| `environment` | string | true | false | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `host` | string | false | true | (Read Only) The host name used to connect to the broker. Mapped from the recipe's Service DNS name. |
| `password` | string | true | false | (Required) The resource ID of the `Radius.Security/secrets` resource that holds the broker password under the data key `password`. Set to `<secretResource>.id`. The Kubernetes Recipe references the materialized Kubernetes Secret by name and mounts the password into the broker via `secretKeyRef`, so the plaintext password is never written into the pod spec or onto this resource. |
| `port` | integer | false | true | (Read Only) The port used to connect to the broker over AMQP 0-9-1 (5672). Mapped from the recipe's output. |
| `queue` | string | false | false | (Optional) The name of the queue to pre-provision on the broker. The Recipe creates this durable queue on the default virtual host when the broker starts, so it exists before your workload connects. Defaults to `jobs` if not provided. |
| `username` | string | false | false | (Optional) The username the broker is provisioned with and that clients authenticate as. Defaults to `radius` if not provided. Avoid `guest`, which RabbitMQ restricts to loopback connections. The username is not sensitive and is exposed as a read-only connection value. |

## Object Properties

### `connections` {#connections}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `disableDefaultEnvVars` | boolean | false | false | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | true | false | Resource ID of the source resource for this connection. |

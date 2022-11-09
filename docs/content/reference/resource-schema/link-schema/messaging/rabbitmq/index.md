---
type: docs
title: "RabbitMQ message broker link"
linkTitle: "RabbitMQ"
description: "Learn how to use a RabbitMQ link in your application"
---

The `rabbitmq.com/MessageQueue` link offers a [RabbitMQ message broker](https://www.rabbitmq.com/).

## Resource format

{{< tabs Values >}}

{{< codetab >}}
{{< rad file="snippets/rabbitmq-values.bicep" embed=true marker="//SAMPLE" >}}
{{< /codetab >}}

{{< /tabs >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. | `mongo`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| application | n | The ID of the application resource this resource belongs to. | `app.id`
| environment | y | The ID of the environment resource this resource belongs to. | `env.id`
| mode | y | Specifies how to build the pub/sub resource. Options are to build automatically via 'recipe' or build manually via 'values'. Selection determines which set of fields to additionally require. | `recipe`
| queue | y | The name of the queue. | `'orders'` |
| [secrets](#secrets)  | y | Configuration used to manually specify a RabbitMQ container or other service providing a RabbitMQ Queue. | See [secrets](#secrets) below.

#### Secrets

Secrets are used when defining a RabbitMQ link with a container or external service.

| Property | Description | Example |
|----------|-------------|---------|
| connectionString | The connection string to the Rabbit MQ Message Queue. Write only | `'amqp://${username}:${password}@${rmqContainer.properties.hostname}:${rmqContainer.properties.port}'`

## Methods

| Property | Description | Example |
|----------|-------------|---------|
| `connectionString()` | Returns the RabbitMQ connection string used to connect to the resource. | `amqp://guest:***@rabbitmq.svc.local.cluster:5672` |

## Connections

[Services]({{< ref services >}}) can define [connections]({{< ref appmodel-concept >}}) to links using the `connections` property. This allows the service to access properties of the link and contributes to visualization and health experiences.

### Environment variables

Connections to the RabbitMQ link result in the following environment variables being set on your service:

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-QUEUE` | The queue name. |
| `CONNECTION_<CONNECTION-NAME>-CONNECTIONSTRING` | The connection string of the RabbitMQ. |

---
type: docs
title: "RabbitMQ message broker connector"
linkTitle: "RabbitMQ"
description: "Learn how to use a RabbitMQ connector in your application"
---

The `rabbitmq.com/MessageQueue` connector offers a [RabbitMQ message broker](https://www.rabbitmq.com/).

## Supported resources

- [RabbitMQ container](https://hub.docker.com/_/rabbitmq/)

## Resource format

{{< rad file="snippets/rabbitmq.bicep" embed=true marker="//SAMPLE" >}}

### Properties

| Property | Description | Example(s) |
|----------|-------------|---------|
| queue | The name of the queue. | `'orders'` |
| secrets  | Configuration used to manually specify a RabbitMQ container or other service providing a RabbitMQ Queue. | See [secrets](#secrets) below.

#### Secrets

Secrets are used when defining a RabbitMQ connector with a container or external service.

| Property | Description | Example |
|----------|-------------|---------|
| connectionString | The connection string to the Rabbit MQ Message Queue. Recommended to use parameters and variables to craft. | `'amqp://${username}:${password}@${rmqContainer.properties.host}:${rmqContainer.properties.port}'`

## Provided data

| Property | Description | Example |
|----------|-------------|---------|
| `queue` | The message queue to which you are connecting. | `'orders'`

### Functions

| Property | Description | Example |
|----------|-------------|---------|
| `connectionString()` | Returns the RabbitMQ connection string used to connect to the resource. | `amqp://guest:***@rabbitmq.svc.local.cluster:5672` |

## Starter

You can get up and running quickly with a RabbitMQ Message Queue by using a [starter]({{< ref starter-templates >}}).

## Container

The module `'br:radius.azurecr.io/starters/rabbitmq:latest'` deploys RabbitMQ container and outputs a `rabbitmq.com.MessageQueue` resource.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter.bicep" embed=true >}}

### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the RabbitMQ Broker | Yes | - |
| queueName | The name of the RabbitMQ queue to create | Yes | - |
| username | The username for your RabbitMQ Broker | No | `'guest'` |
| password | The password for your RabbitMQ Broker | No | `newGuid()` |

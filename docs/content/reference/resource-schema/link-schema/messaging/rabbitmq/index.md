---
type: docs
title: "RabbitMQ message broker link"
linkTitle: "RabbitMQ"
description: "Learn how to use a RabbitMQ link in your application"
categories: "Schema"
---

## Overview

The `rabbitmq.com/MessageQueue` link offers a [RabbitMQ message broker](https://www.rabbitmq.com/).

## Resource format

{{< tabs Recipe Manual >}}

{{< codetab >}}

{{< rad file="snippets/rabbitmq-recipe.bicep" embed=true marker="//SAMPLE" >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/rabbitmq-manual.bicep" embed=true marker="//SAMPLE" >}}

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
| [resourceProvisioning](#resource-provisioning) | n | Specifies how the underlying service/resource is provisioned and managed. Options are to provision automatically via 'recipe' or provision manually via 'manual'. Selection determines which set of fields to additionally require. Defaults to 'recipe'. | `manual`
| [recipe](#recipe) | n | Configuration for the Recipe which will deploy the backing infrastructure. | [See below](#recipe)
| queue | y | The name of the queue. | `'orders'` |
| [secrets](#secrets)  | y | Configuration used to manually specify a RabbitMQ container or other service providing a RabbitMQ Queue. | See [secrets](#secrets) below.

#### Recipe

| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| name | n | Specifies the name of the Recipe that should be deployed. If not set, the name defaults to `default`. | `name: 'azure-prod'`
| parameters | n | An object that contains a list of parameters to set on the Recipe. | `{ port: '10040' }`


#### Secrets

Secrets are used when defining a RabbitMQ link with a container or external service.

| Property | Description | Example |
|----------|-------------|---------|
| connectionString | The connection string to the Rabbit MQ Message Queue. Write only | `'amqp://${username}:${password}@${rmqContainer.properties.hostname}:${rmqContainer.properties.port}'`

### Methods

| Property | Description | Example |
|----------|-------------|---------|
| `connectionString()` | Returns the RabbitMQ connection string used to connect to the resource. | `amqp://guest:***@rabbitmq.svc.local.cluster:5672` |

## Resource provisioning

### Provision with a Recipe

[Recipes]({{< ref recipes-overview >}}) automate infrastructure provisioning using approved templates.
When no Recipe configuration is set Radius will use the Recipe registered as the **default** in the environment for the given resource. Otherwise, a Recipe name and parameters can optionally be set.

### Provision manually

If you want to manually manage your infrastructure provisioning outside of Recipes, you can set `resourceProvisioning` to `'manual'` and provide all necessary parameters and values in order for Radius to be able to deploy/connect to the desired infrastructure.
---
type: docs
title: "RabbitMQ message broker"
linkTitle: "RabbitMQ"
description: "Learn how to use a RabbitMQ resource in your application"
categories: "Schema"
---

## Overview

The `rabbitmq.com/MessageQueue` resource offers a [RabbitMQ message broker](https://www.rabbitmq.com/).

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
| host | n | The hostname of the RabbitMQ instance. | `rabbitmq.hello.com`
| port | n | The port of the RabbitMQ instance. Defaults to 5672. | `5672`
| vHost | n | The RabbitMQ virtual host (vHost) the client will connect to. Defaults to no vHost. | `vHost`
| tls | n | Specifies whether to use SSL when connecting to the RabbitMQ instance. | `tls`
| username | n | Username to use when connecting to the target rabbitMQ. | `'myusername'`
| [recipe](#recipe) | n | Configuration for the Recipe which will deploy the backing infrastructure. | [See below](#recipe)
| [resources](#resources)  | n | An array of IDs of the underlying resources. | [See below](#resources)
| queue | y | The name of the queue. | `'orders'` |
| [secrets](#secrets)  | y | Configuration used to manually specify a RabbitMQ container or other service providing a RabbitMQ Queue. | See [secrets](#secrets) below.

#### Recipe

| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| name | n | Specifies the name of the Recipe that should be deployed. If not set, the name defaults to `default`. | `name: 'azure-prod'`
| parameters | n | An object that contains a list of parameters to set on the Recipe. | `{ port: '10040' }`

#### Resources

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| id | n |  Resource ID of the supporting resource. |`queue.id`

#### Secrets

Secrets are used when defining a RabbitMQ resource with a container or external service.

| Property | Description | Example |
|----------|-------------|---------|
| uri | The URI to the Rabbit MQ Message Queue. Write only | `'amqp://${username}:${password}@${rmqContainer.properties.hostname}:${rmqContainer.properties.port}'`
| password | The password used to connect to this RabbitMQ. Write only. | `'mypassword'`

### Methods

| Property | Description | Example |
|----------|-------------|---------|
| `uri()` | Returns the RabbitMQ uri used to connect to the resource. | `amqp://guest:***@rabbitmq.svc.local.cluster:5672` |

## Resource provisioning

### Provision with a Recipe

[Recipes]({{< ref howto-author-recipes >}}) automate infrastructure provisioning using approved templates.
When no Recipe configuration is set Radius will use the Recipe registered as the **default** in the environment for the given resource. Otherwise, a Recipe name and parameters can optionally be set.

### Provision manually

If you want to manually manage your infrastructure provisioning outside of Recipes, you can set `resourceProvisioning` to `'manual'` and provide all necessary parameters and values and values that enable Radius to deploy or connect to the desired infrastructure.

## Environment variables for connections

Other Radius resources, such as [containers]({{< ref "guides/author-apps/containers" >}}), may connect to a RabbitMQ resource via [connections]({{< ref "application-graph#connections-and-injected-values" >}}). When a connection to RabbitMQ named, for example, `myconnection` is declared, Radius injects values into environment variables that are then used to access the connected RabbitMQ resource:

| Environment variable | Example(s) |
|----------------------|------------|
| CONNECTION_MYCONNECTION_QUEUE | `'orders'` |
| CONNECTION_MYCONNECTION_HOST | `'rabbitmq.svc.local.cluster'` |
| CONNECTION_MYCONNECTION_PORT | `'5672'` |
| CONNECTION_MYCONNECTION_VHOST | `'qa1'` | <!-- [Title](https://www.rabbitmq.com/vhosts.html) -->
| CONNECTION_MYCONNECTION_USERNAME | `'guest'` |
| CONNECTION_MYCONNECTION_TLS | `'true'` |
| CONNECTION_MYCONNECTION_URI | `'amqp://${username}:${password}@${rmqContainer.properties.hostname}:${rmqContainer.properties.port}'` |
| CONNECTION_MYCONNECTION_PASSWORD | `'password'` |
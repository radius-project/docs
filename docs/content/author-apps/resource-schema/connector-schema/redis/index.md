---
type: docs
title: "Redis cache connector"
linkTitle: "Redis cache"
description: "Learn how to use a Redis connector in your application"
---

The `redislabs.com/Redis` connector is a [portable connector]({{< ref connectors-model >}}) which can be deployed to any platform Radius supports.

## Supported resources

- [Redis container](https://hub.docker.com/_/redis/)
- [Azure Cache for Redis](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview)

## Resource format

The following top-level information is available in the resource:

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. Used to provide status and visualize the resource. | `cache`

### Provided data

| Property | Description | Example(s) |
|----------|-------------|------------|
| `host`  | The Redis host name. | `redis.hello.com`
| `port` | The Redis port. | `4242`
| `username` | The username for connecting to the redis cache. |
| `password()` | The password for connecting to the redis cache. Can be used for password and can be empty. | `d2Y2ba...`

## Connections

[Services]({{< ref container-schema >}}) can define [connections]({{< ref connections-model >}}) to connectors using the `connections` property. This allows the service to access properties of the connector and contributes to to visualization and health experiences.

### Environment variables

Connections to the Redis connector result in the following environment variables being set on your service:

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-HOST` | The host name of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-PORT` | The port of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-USERNAME` | The username of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-PASSWORD` | The password of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-CONNECTION_STRING` | The connection string of the Redis cache. |

## Starter

You can get up and running quickly with a Redis cache by using a starter:

{{< rad file="snippets/starter.bicep" embed=true >}}

### Container

The module `'br:radius.azurecr.io/starters/redis:latest'` deploys Redis container and outputs a `redislabs.com.RedisCache` resource.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter.bicep" embed=true >}}

{{% alert title="Known issue: dependsOn" color="warning" %}}
Any service that consumes the `redisConnector` resource will need to manually add a `dependsOn` reference to the `redis` module. This requirement will be removed in an upcoming release. See the [webapp tutorial]({{< ref webapp-add-database >}}) for an example.
{{% /alert %}}

#### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the RabbitMQ Broker | Yes | - |
| cacheName | The name for your Redis Cache connector | Yes | - |

### Azure Cache for Redis

The module `'br:radius.azurecr.io/starters/redis-azure:latest'` deploys an Azure Redis Cache and outputs a `redislabs.com.RedisCache` resource.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter-azure.bicep" embed=true >}}

#### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the RabbitMQ Broker | Yes | - |
| cacheName | The name for your Redis Cache container | Yes | - |
| redisCacheSku | The SKU of the Redis Cache | No | `'Basic'` |
| redisCacheFamily | The family of the Azure Redis Cache | No | `'C'` |
| redisCacheCapacity | The capacity of the Azure Redis Cache | No | `1` |
| location | The Azure region to deploy the Azure Redis Cache | No | `resourceGroup().location` |

---
type: docs
title: "Redis cache connector"
linkTitle: "Redis"
description: "Learn how to use a Redis connector in your application"
---

The `redislabs.com/Redis` connector is a [portable connector]({{< ref connectors >}}) which can be deployed to any [Radius platform]({{< ref platforms >}}).

## Supported resources

- [Redis container](https://hub.docker.com/_/redis/)
- [Azure Cache for Redis](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview)

## Resource format

The following top-level information is available in the resource:

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. Used to provide status and visualize the resource. | `cache`

## Provided data

| Property | Description | Example(s) |
|----------|-------------|------------|
| `host`  | The Redis host name. | `redis.hello.com`
| `port` | The Redis port. | `4242`
| `username` | The username for connecting to the redis cache. |
| `password()` | The password for connecting to the redis cache. Can be used for password and can be empty. | `d2Y2ba...`

## Starter

You can get up and running quickly with a Redis cache by using a [starter]({{< ref starter-templates >}}):

{{< rad file="snippets/starter.bicep" embed=true >}}

## Container

The module `'br:radius.azurecr.io/starters/redis:latest'` deploys Redis container and outputs a `redislabs.com.RedisCache` resource.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter.bicep" embed=true >}}

### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the RabbitMQ Broker | Yes | - |
| cacheName | The name for your Redis Cache connector | Yes | - |

## Microsoft Azure

The module `'br:radius.azurecr.io/starters/redis-azure:latest'` deploys an Azure Redis Cache and outputs a `redislabs.com.RedisCache` resource.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter-azure.bicep" embed=true >}}

### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the RabbitMQ Broker | Yes | - |
| cacheName | The name for your Redis Cache container | Yes | - |
| redisCacheSku | The SKU of the Redis Cache | No | `'Basic'` |
| redisCacheFamily | The family of the Azure Redis Cache | No | `'C'` |
| redisCacheCapacity | The capacity of the Azure Redis Cache | No | `1` |
| location | The Azure region to deploy the Azure Redis Cache | No | `resourceGroup().location` |

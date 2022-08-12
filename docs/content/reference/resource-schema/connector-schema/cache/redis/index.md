---
type: docs
title: "Redis cache connector"
linkTitle: "Redis"
description: "Learn how to use a Redis connector in your application"
---

The `redislabs.com/Redis` connector is a [portable connector]({{< ref connectors >}}) which can be deployed to any platform Radius supports.

## Resource format

{{< tabs Resource Values >}}

{{< codetab >}}
{{< rad file="snippets/redis-resource.bicep" embed=true marker="//REDIS" >}}
{{< /codetab >}}

{{< codetab >}}
{{< rad file="snippets/redis-values.bicep" embed=true marker="//REDIS" >}}
{{< /codetab >}}

{{< /tabs >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. | `cache`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| application | n | The ID of the application resource this resource belongs to. | `app.id`
| environment | y | The ID of the environment resource this resource belongs to. | `env.id`
| resource  | n | The ID of the underlying resource for the connector. Used when building the connector from a resource. | `redisCache.id`
| host | n | The Redis host name. | `redis.hello.com`
| port | n | The Redis port. | `4242`
| [secrets](#secrets) | n | Secrets used when building the connector from values. | [See below](#secrets)

### Secrets

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| connectionString | n | The connection string for the Redis cache. Write only. | `https://mycache.redis.cache.windows.net,password=*****,....`
| password | n | The password for the Redis cache. Write only. | `mypassword`

## Methods

The following methods are available on the Redis connector:

| Method | Description |
|--------|-------------|
| connectionString() | Get the connection string for the Redis cache. |
| password() | Get the password for the Redis cache. |

NOTE: Currently, the `connectionString()` method is not supported for Redis connectors created using the `resource` property. As a workaround, the `connectionString` secret can be manually set and accessed using this method.

## Supported resources

The following resources are supported when building the connector from a resource using the `resource` property:

- [Azure Cache for Redis](https://docs.microsoft.com/azure/azure-cache-for-redis/cache-overview)

## Connections

[Services]({{< ref services >}}) can define [connections]({{< ref appmodel-concept >}}) to connectors using the `connections` property. This allows the service to access properties of the connector and contributes to to visualization and health experiences.

### Environment variables

Connections to the Redis connector result in the following environment variables being set on your service:

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-HOST` | The host name of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-PORT` | The port of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-USERNAME` | The username of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-PASSWORD` | The password of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-CONNECTION_STRING` | The connection string of the Redis cache. |

---
type: docs
title: "Redis cache link"
linkTitle: "Redis"
description: "Learn how to use a Redis link in your application"
---

The `redislabs.com/Redis` link is a [portable link]({{< ref links >}}) which can be deployed to any platform Radius supports.

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
| resource  | n | The ID of the underlying resource for the link. Used when building the link from a resource. | `redisCache.id`
| host | n | The Redis host name. | `redis.hello.com`
| mode | Y | Specifies how to build the Link resource. Options are to build automatically via 'recipe' or build manually via 'values'. Selection determines which set of fields to additionally require. | `recipe`
| [secrets](#secrets) | n | Secrets used when building the link from values. | [See below](#secrets)

### Secrets

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| connectionString | n | The connection string for the Redis cache. Write only. | `https://mycache.redis.cache.windows.net,password=*****,....`
| password | n | The password for the Redis cache. Write only. | `mypassword`

## Methods

The following methods are available on the Redis link:

| Method | Description |
|--------|-------------|
| connectionString() | Get the connection string for the Redis cache. |
| password() | Get the password for the Redis cache. |

## Supported resources

The following resources are supported when building the link from a resource using the `resource` property:

- [Azure Cache for Redis](https://docs.microsoft.com/azure/azure-cache-for-redis/cache-overview)

## Connections

[Services]({{< ref container >}}) can define [connections]({{< ref appmodel-concept >}}) to links using the `connections` property. This allows the service to access properties of the link and contributes to to visualization and health experiences.

### Environment variables

Connections to the Redis link result in the following environment variables being set on your service:

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-HOST` | The host name of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-PORT` | The port of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-USERNAME` | The username of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-PASSWORD` | The password of the Redis cache. |
| `CONNECTION_<CONNECTION-NAME>-CONNECTION_STRING` | The connection string of the Redis cache. |

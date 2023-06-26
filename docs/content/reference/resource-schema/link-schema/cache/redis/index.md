---
type: docs
title: "Redis cache link"
linkTitle: "Redis"
description: "Learn how to use a Redis link in your application"
---

The `redislabs.com/Redis` link is a [portable link]({{< ref links-resources >}}) which can be deployed to any platform Radius supports.

## Resource format

{{< rad file="snippets/redis-values.bicep" embed=true marker="//REDIS" >}}

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
| host | n | The Redis host name. | `redis.hello.com`
| port | n | The Redis port value. | `6379`
| resourceProvisioning | n | Specifies how to build the Link resource. Options are to build automatically via 'recipe' or build manually via 'manually'. Selection determines which set of fields to additionally require. | `manual`
| [recipe](#recipe)  | n | The recipe to deploy. | `redisCache.id`
| [resources](#resources)  | n | An array of IDs of the underlying resources for the link. | [See below](#resources)
| [secrets](#secrets) | n | Secrets used when building the link from values. | [See below](#secrets)
| tls | n | Specifies whether to enable SSL connections to the Redis cache. This value with be computed based on the port value specified. TLS will be set to true and used if the port value is set to 6380. Otherwise, the computed value will be false. If SSL is required on a different port, the computed value for TLS can be manually overriden by setting TLS to true in the resource definition | `true`

### Recipe

| Property  | Required | Description | Example |
|------|:--------:|-------------|---------|
| \<recipe-name\> | y | The name of the Recipe. Must be unique within the resource-type. | `myrecipe`
| parameters | n | A list of parameters to set on the Recipe for every Recipe usage and deployment. Can be overridden by the resource calling the Recipe. | `capacity: 1`


### Resources

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| id | y | The resource ID of the underlying resources for the link. | `redisCache.id`

### Secrets

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| connectionString | n | The connection string for the Redis cache. Write only. | `https://mycache.redis.cache.windows.net,password=*****,....`
| password | n | The password for the Redis cache. Write only. | `mypassword`
| url | n | The connection URL for the Redis cache. Write only. | `redis://localhost:6380/0?ssl=true` |

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

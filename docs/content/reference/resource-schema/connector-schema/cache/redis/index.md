---
type: docs
title: "Redis cache connector"
linkTitle: "Redis"
description: "Learn how to use a Redis connector in your application"
---

The `redislabs.com/Redis` connector is a [portable connector]({{< ref connectors >}}) which can be deployed to any platform Radius supports.

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

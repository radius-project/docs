---
type: docs
title: "Redis cache link"
linkTitle: "Redis"
description: "Learn how to use a Redis link in your application"
categories: "Schema"
---

## Overview

The `redislabs.com/Redis` link is a [portable link]({{< ref portable-resources >}}) which can be deployed to any platform Radius supports.

## Resource format

{{< tabs Recipe Manual >}}

{{< codetab >}}

{{< rad file="snippets/redis-recipe.bicep" embed=true marker="//REDIS" >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/redis-manual.bicep" embed=true marker="//REDIS" >}}

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
| host | n | The Redis host name. | `redis.hello.com`
| port | n | The Redis port value. | `6379`
| [resourceProvisioning](#resource-provisioning) | n | Specifies how the underlying service/resource is provisioned and managed. Options are to provision automatically via 'recipe' or provision manually via 'manual'. Selection determines which set of fields to additionally require. Defaults to 'recipe'. | `manual`
| [recipe](#recipe) | n | Configuration for the Recipe which will deploy the backing infrastructure. | [See below](#recipe)
| [resources](#resources)  | n | An array of IDs of the underlying resources for the link. | [See below](#resources)
| username | n | The username for Redis cache. | `myusername`
| [secrets](#secrets) | n | Secrets used when building the link from values. | [See below](#secrets)
| tls | n | Indicates if the Redis cache is configured with SSL connections. If the `port` value is set to 6380 this defaults to `true`. Otherwise it is defaulted to false. If your Redis cache offers SSL connections on ports other than 6380, explicitly set this value to `true` to override the default behavior. | `true`

#### Recipe

| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| \<recipe-name\> | y | The name of the Recipe. Must be unique within the resource-type. | `myrecipe`
| parameters | n | A list of parameters to set on the Recipe for every Recipe usage and deployment. Can be overridden by the resource calling the Recipe. | `capacity: 1`

#### Resources

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| id | n | Resource ID of the supporting resource. |`redisCache.id`

#### Secrets

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| connectionString | n | The connection string for the Redis cache. Write only. | `contoso5.redis.cache.windows.net,ssl=true,password=...`
| password | n | The password for the Redis cache. Write only. | `mypassword`
| url | n | The connection URL for the Redis cache. Set automatically based on the values provided for `host`, `port`, `username`, and `password`. Can be explicitly set to override default behavior. Write only. | `redis://username:password@localhost:6380/0?ssl=true` |

### Methods

The following methods are available on the Redis link:

| Method | Description |
|--------|-------------|
| connectionString() | Get the connection string for the Redis cache. |
| password() | Get the password for the Redis cache. |

## Resource provisioning

### Provision with a Recipe

[Recipes]({{< ref howto-author-recipes >}}) automate infrastructure provisioning using approved templates.
When no Recipe configuration is set, Radius will use the currently registered Recipe as the **default** in the environment for the given resource. Otherwise, a Recipe name and parameters can optionally be set to override this default.

### Provision manually

If you want to manually manage your infrastructure provisioning without the use of Recipes, you can set `resourceProvisioning` to `'manual'` and provide all necessary parameters and values that enable Radius to deploy or connect to the desired infrastructure.

## Environment variables for connections

Other Radius resources, such as [containers]({{< ref "/author-apps/containers" >}}), may connect to a Redis resource via [connections]({{< ref "application-graph#connections-and-injected-values" >}}). When a connection to Redis named, for example, `myconnection` is declared, Radius injects values into environment variables that are then used to access the connected Redis resource:

| Environment variable | Example(s) |
|----------------------|------------|
| CONNECTION_MYCONNECTION_HOST | `mycache.redis.cache.windows.net` |
| CONNECTION_MYCONNECTION_PORT | `6379` |
| CONNECTION_MYCONNECTION_TLS | `true` |
| CONNECTION_MYCONNECTION_USERNAME | `admin` |
| CONNECTION_MYCONNECTION_CONNECTIONSTRING | `contoso5.redis.cache.windows.net,ssl=true,password=...` |
| CONNECTION_MYCONNECTION_PASSWORD | `mypassword` |
| CONNECTION_MYCONNECTION_URL | `rediss://username:password@localhost:6380/0` |

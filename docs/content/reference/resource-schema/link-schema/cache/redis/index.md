---
type: docs
title: "Redis cache link"
linkTitle: "Redis"
description: "Learn how to use a Redis link in your application"
categories: "Reference"
---

## Overview

The `redislabs.com/Redis` link is a [portable link]({{< ref links-resources >}}) which can be deployed to any platform Radius supports.

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

#### Recipe

| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| \<recipe-name\> | y | The name of the Recipe. Must be unique within the resource-type. | `myrecipe`
| parameters | n | A list of parameters to set on the Recipe for every Recipe usage and deployment. Can be overridden by the resource calling the Recipe. | `capacity: 1`

#### Resources

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| id | n | List of the resource IDs that support the resource |`redisCache.id`

#### Secrets

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| connectionString | n | The connection string for the Redis cache. Write only. | `https://mycache.redis.cache.windows.net,password=*****,....`
| password | n | The password for the Redis cache. Write only. | `mypassword`

### Methods

The following methods are available on the Redis link:

| Method | Description |
|--------|-------------|
| connectionString() | Get the connection string for the Redis cache. |
| password() | Get the password for the Redis cache. |

## Resource provisioning

### Provision with a Recipe

[Recipes]({{< ref recipes-overview >}}) automate infrastructure provisioning using approved templates.
When no Recipe configuration is set Radius will use the Recipe registered as the **default** in the environment for the given resource. Otherwise, a Recipe name and parameters can optionally be set.

### Provision manually

If you want to manually manage your infrastructure provisioning outside of Recipes, you can set `resourceProvisioning` to `'manual'` and provide all necessary parameters and values in order for Radius to be able to deploy/connect to the desired infrastructure.
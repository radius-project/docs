---
type: docs
title: "Recipe context object schema"
linkTitle: "Recipe context object schema"
description: "Learn how to use the Recipe context object in your Recipe templates"
categories: "Schema"
---

## Overview

In the following tables, "resource" refers to the resource "calling" the Recipe. For example, if you were to create a Recipe for an `Applications.Link/redisCaches` resource, the "resource" would be the instance of the redisCaches that is calling the Recipe.

## Resource format

{{< tabs Bicep Terraform >}}

{{< codetab >}}

{{< rad file="snippets/recipe.bicep" embed=true >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/recipe.tf" embed=true >}}

{{< /codetab >}}

{{< /tabs >}}

| Key | Type | Description |
|-----|------|-------------|
| [`resource`](#resource) | object | Represents the resource metadata of the deploying recipe resource.
| [`application`](#application) | object | Represents environment resource metadata.
| [`environment`](#environment) | object | Represents environment resource metadata.
| [`azure`](#runtime) | object | Represents Azure provider scope. metadata.
| [`aws`](#runtime) | object | Represents AWS provider scope metadata.

### resource

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The resource name of the application | `myredis`
| `id` | string | The ID of the resource | `/planes/radius/resourceGroups/myrg/Applications.Link/redisCaches/myredis`
| `type` | string | The type of the resource calling this recipe | `Applications.Link/redisCaches`

### application

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The resource name of the application | `myapp`
| `id` | string | The resource ID of the application | `/planes/radius/resourceGroups/myrg/Applications.Core/applications/myapp`

### environment

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The resource name of the environment | `myenv`
| `id` | string | The resource ID of the environment | `/planes/radius/resourceGroups/myrg/Applications.Core/environments/myenv`

### runtime

| Key | Type | Description |
|-----|------|-------------|
| [`kubernetes`](#kubernetes) | object | An object with details of the underlying Kubernetes cluster, if configured on the environment

#### kubernetes

| Key | Type | Description |
|-----|------|-------------|
| `namespace` | string | Set to the application's namespace when the resource is application-scoped, and set to the environment's namespace when the resource is environment scoped.
| `environmentNamespace` | string | Set to the environment's namespace.

### azure

| Key | Type | Description |
|-----|------|-------------|
| [`resourceGroup`](#resourceGroup) | object | An object with details of the Azure Resource Group provider information, if configured on the environment
| [`subscription`](#subscription) | object | An object with details of the Azure Subscription provider information, if configured on the environment

#### resourceGroup

| Key | Type | Description |
|-----|------|-------------|
| `name` | string | The resource group name.
| `id` | string | Represents fully qualified resource group name.

#### subscription

| Key | Type | Description |
|-----|------|-------------|
| `subscriptionId` | string | The ID of the subscription.
| `id` | string | Represents fully qualified subscription ID.

### aws

| Key | Type | Description |
|-----|------|-------------|
| [`region`] | string | Represents the region of the AWS account.
| [`account`] | string | Represents the account id of the AWS account.

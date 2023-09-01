---
type: docs
title: "Reference: Recipe context object schema"
linkTitle: "Recipe context"
description: "Learn how to use the Recipe context object in your Recipe templates"
categories: "Reference"
weight: 800
---

The `context` object is automatically injected to Bicep templates when a Recipe is run. It contains information about the runtime, environment, application, and resource from which the Recipe was run. This enables you to author templates that can be used as Recipes. For more information visit the [Recipe authoring how-to guide]({{< ref howto-author-recipes >}}).

## Usage

{{< tabs Bicep >}}

{{< codetab >}}

{{< rad file="snippets/recipe.bicep" embed=true >}}

{{< /codetab >}}

{{< /tabs >}}

| Key | Type | Description |
|-----|------|-------------|
| [`resource`](#resource) | object | Represents the resource metadata of the deploying recipe resource.
| [`application`](#application) | object | Represents application metadata.
| [`environment`](#environment) | object | Represents environment metadata.
| [`runtime`](#runtime)	| object | An object containing information on the underlying runtime. 
| [`azure`](#azure) | object | Represents Azure provider scope metadata.
| [`aws`](#aws) | object | Represents AWS provider scope metadata.

### resource

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The name of the resource calling this Recipe | `myredis`
| `id` | string | The ID of the resource calling this Recipe | `/planes/radius/resourceGroups/myrg/Applications.Link/redisCaches/myredis`
| `type` | string | The type of the resource calling this recipe | `Applications.Link/redisCaches`

### application

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The name of the application | `myapp`
| `id` | string | The resource ID of the application | `/planes/radius/resourceGroups/myrg/Applications.Core/applications/myapp`

### environment

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The name of the environment | `myenv`
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
| `id` | string | Represents fully qualified resource group id.

#### subscription

| Key | Type | Description |
|-----|------|-------------|
| `subscriptionId` | string | The GUID of the subscription.
| `id` | string | Represents fully qualified subscription id.

### aws

| Key | Type | Description |
|-----|------|-------------|
| [`region`] | string | Represents the region where AWS resources are deployed.
| [`account`] | string | Represents the account id of the AWS account.

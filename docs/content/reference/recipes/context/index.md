---
type: docs
title: "Recipe context object"
linkTitle: "Recipe context"
description: "Learn how to use the context object in your recipes"
weight: 100
---

Radius automatically injects the `context` object into each recipe at deploy time. It carries metadata about the resource being deployed and the application, environment, and runtime it belongs to, along with the Azure and AWS provider scopes configured on the Environment. The context is a normalized recipe contract, not a copy of the Environment resource schema. For example, Radius maps `Radius.Core/environments.properties.providers.kubernetes.namespace` to `context.runtime.kubernetes.namespace`. You declare `context` as a parameter in a Bicep recipe (`param context object`) or as an input variable in a Terraform recipe (`variable "context"`), then reference its values to generate names, resolve namespaces, and configure the infrastructure your recipe deploys. For more information, visit the [recipe authoring how-to guide]({{< ref "/extensibility/recipes" >}}).

## Usage

{{< tabs Terraform Bicep >}}

{{< codetab >}}

{{< rad file="snippets/recipe.tf" embed=true lang="terraform" >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/recipe.bicep" embed=true >}}

{{< /codetab >}}

{{< /tabs >}}

## Properties

| Key | Type | Description |
|-----|------|-------------|
| [`resource`](#resource) | object | Metadata about the resource, defined in the application definition, being deployed including its name, ID, type, and properties. |
| [`application`](#application) | object | Metadata about the application the resource belongs to. Populated only when the resource is application-scoped. |
| [`environment`](#environment) | object | Metadata about the environment the resource is deployed into. |
| [`runtime`](#runtime) | object | Details about the target runtime that hosts the deployed resources, such as the Kubernetes cluster. |
| [`azure`](#azure) | object | The Azure provider scope (subscription and resource group) for the deployment. Present only when an Azure provider is configured on the environment. |
| [`aws`](#aws) | object | The AWS provider scope (account and region) for the deployment. Present only when an AWS provider is configured on the environment. |

### resource

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The name of the resource being deployed | `postgresql` |
| `id` | string | The ID of the resource being deployed | `/planes/radius/local/resourceGroups/default/providers/Radius.Data/postgreSqlDatabases/postgresql` |
| `type` | string | The type of the resource being deployed | `Radius.Data/postgreSqlDatabases` |
| `properties` | object | The properties of the resource being deployed | `{ "size": "S", "database": "appdb" }` |
| [`connections`](#connections) | object | A map of the resource's connections to other resources, keyed by connection name. Each entry exposes the connected resource's metadata and properties. | |

#### connections

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The name of the connected resource. | `database` |
| `id` | string | The ID of the connected resource. | `/planes/radius/local/resourceGroups/default/providers/Radius.Data/postgreSqlDatabases/database` |
| `type` | string | The type of the connected resource. | `Radius.Data/postgreSqlDatabases` |
| `properties` | object | The properties of the connected resource. | `{ "host": "localhost", "port": 5432 }` |

### application

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The name of the application | `todolist` |
| `id` | string | The resource ID of the application | `/planes/radius/local/resourceGroups/default/providers/Radius.Core/applications/todolist` |

### environment

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The name of the environment | `default` |
| `id` | string | The resource ID of the environment | `/planes/radius/local/resourceGroups/default/providers/Radius.Core/environments/default` |

### runtime

| Key | Type | Description |
|-----|------|-------------|
| [`kubernetes`](#kubernetes) | object | An object with details of the underlying Kubernetes cluster, if configured on the environment |

#### kubernetes

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `namespace` | string | The Kubernetes namespace the recipe should deploy its resources into. Set from the environment's `providers.kubernetes.namespace`. | `default` |

### azure

| Key | Type | Description |
|-----|------|-------------|
| [`resourceGroup`](#resourceGroup) | object | An object with details of the Azure resource group, if configured on the environment |
| [`subscription`](#subscription) | object | An object with details of the Azure subscription, if configured on the environment |

#### resourceGroup

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The resource group name where resources are deployed. | `myrg` |
| `id` | string | The fully qualified Azure resource group ID. | `/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myrg` |

#### subscription

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `subscriptionId` | string | The GUID of the subscription where resources are deployed. | `00000000-0000-0000-0000-000000000000` |
| `id` | string | The fully qualified Azure subscription ID. | `/subscriptions/00000000-0000-0000-0000-000000000000` |

### aws

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `region` | string | The AWS region where resources are deployed. | `us-west-2` |
| `account` | string | The AWS account ID. | `123456789012` |

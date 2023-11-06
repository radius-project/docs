---
type: docs
title: "Overview: Radius Recipes"
linkTitle: "Overview"
description: "Learn how to automate infrastructure deployment for your resources with Radius Recipes"
weight: 100
categories: "Overview"
tags: ["recipes"]
---

Recipes enable a **separation of concerns** between It operators and developers by **automating infrastructure deployment**. Developers select the resource they want in their app (_Mongo Database, Redis Cache, Dapr State Store, etc._), and operators codify in their environment how these resources should be deployed and configured (_lightweight containers, Azure resources, AWS resources, etc._). When a developer deploys their application and its resources, Recipes automatically deploy the backing infrastructure and bind it to the developer's resources.

<img src="recipes.png" alt="Diagram showing developers adding Redis to their app and operators adding a Recipe that Redis should deploy an Azure Cache for Redis" width=700px >

## Capabilities

### Support for multiple IaC languages

| Language | Recipe Support | Notes |
|----------| ---------------|-------|
| [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/) | ✅ | Supports Azure, AWS, and Kubernetes
| [Terraform](https://developer.hashicorp.com/terraform/docs) | ✅ | Supports Azure, AWS, and Kubernetes providers<br />Other providers not yet configurable

### Select the Recipe that meets your needs

Recipes can be used in any environment, from dev to prod. You can run a default recipe registered in your environment or select the specific Recipe you want to run. To run a default recipe, simply add the resource you want to your app and omit the Recipe name:

{{< rad file="snippets/recipe-link-example.bicep" embed=true marker="//DEFAULT" >}} 

If you want to use a specific Recipe, you can specify the Recipe name in the `recipe` parameter:

{{< rad file="snippets/recipe-link-example.bicep" embed=true marker="//BASIC" >}}

Use [**rad recipe list**]({{< ref rad_recipe_list >}}) to view the Recipes available to you in your environment.

### Use lightweight "local-dev" Recipes

Radius Environments make it easy to get up and running with Recipes instantly. When you run [`rad init`]({{< ref rad_init >}}) you get a set of containerized local-dev Recipes pre-registered in your environment. These Recipes are designed to help you get started quickly with Recipes using lightweight containers. You can use these Recipes to test your app locally, or deploy them to a dev environment.

### Customize with parameters

Recipes can be customized with parameters, allowing developers to fine-tune infrastructure to meet their specific needs:

{{< rad file="snippets/recipe-link-example.bicep" embed=true marker="//PARAMETERS" >}}

You can use [**rad recipe show**]({{< ref rad_recipe_show >}}) to view the parameters available to you in a Recipe.

### Author custom Recipes

It's easy to author and register your own Recipes which define how to deploy and configure infrastructure that meets your organization's needs. See the [custom Recipes guide]({{< ref howto-author-recipes >}}) for more information.

## Supported resources

Recipes currently support the following resources. Support for additional resources is actively being worked on.

| Supported resources | 
|---------------------|
| [`Applications.Datastores/redisCaches`]({{< ref redis >}}) | 
| [`Applications.Datastores/mongoDatabases`]({{< ref mongodb >}}) |
| [`Applications.Datastores/sqlDatabases`]({{< ref microsoft-sql >}}) | 
| [`Applications.Messaging/rabbitmqQueues`]({{< ref rabbitmq >}}) |
| [`Applications.Dapr/stateStores`]({{< ref dapr-statestore >}}) |
| [`Applications.Dapr/pubSubBrokers`]({{< ref dapr-pubsub >}}) |
| [`Applications.Dapr/secretStores`]({{< ref dapr-secretstore >}}) |
| [`Applications.Core/extenders`]({{< ref extender >}}) |

## Infrastructure linking

When you use a Recipe to deploy infrastructure (_e.g. Azure, AWS resources_), that infrastructure can be linked and tracked as part of the Recipe-enabled resource. This means you can inspect what infrastructure supports the resource. Use [`rad resource show -o json`]({{< ref rad_resource_show >}}) to view this information.

## Infrastructure lifecycle

The lifecycle of Recipe infrastructure is tied to the resource calling the Recipe. When a Recipe-supported resource is deployed it triggers the Recipe, which in turn deploys the underlying infrastructure. When the Recipe-supported resource is deleted the underlying infrastructure is deleted as well.

## Further Reading

- [Author custom recipes]({{< ref howto-author-recipes >}})
- [`rad recipe` CLI reference]({{< ref rad_recipe >}})

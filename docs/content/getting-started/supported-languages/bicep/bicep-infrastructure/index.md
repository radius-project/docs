---
type: docs
title: "Model your application infrastructure in Bicep"
linkTitle: "Infrastructure"
description: "Learn how to model your infrastructure in the Bicep language"
weight: 300
---

Application "infrastructure" is the underlying resources that your service interacts with and is hosted on. Examples include servers, databases, caches, message queues, and secret stores. In a Radius application you can model all of your non-compute infrastructure in the Bicep language by declaring and deploying new resources, or by referencing existing resources that have already been deployed. An application's infrastructure resources are distinct from its compute resources, which are managed as services.

## Model and deploy with Bicep

The following example shows an Azure CosmosDB account and MongoDB database that will be deployed with Bicep. This is useful if you want to leverage Bicep and Azure to manage the lifecycle of your resource:

{{< rad file="snippets/new.bicep" embed=true >}}

You can now use the `cosmos::db` resource in your Radius application.

## Available resources

- [Microsoft Azure resources]({{< ref azure-resources >}})
- [Kubernetes resources]({{< ref kubernetes-resources >}})

## Reference an existing resource

Alternately, you can [reference an existing resource](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/resource-declaration?tabs=azure-powershell#reference-existing-resources) that is deployed and managed by another process.

{{% alert title="Incremental adoption" color="info" %}}
The `existing` keyword lets you add Radius to existing resources and infrastructure. This can be useful if you want to reuse existing infrastructure that you've already deployed through another process.
{{% /alert %}}

Here's an example of a CosmosDB account and MongoDB resource:

{{< rad file="snippets/existing.bicep" embed=true >}}

You can now use `cosmos::db` in your Radius application, just like if you freshly deployed the resources.

## Reference a resource in a different Azure resource group or subscription

By default, Bicep resources are scoped to the resource group to which to are targeting for your deployment. If you want to refer to resources, either new or existing, in a different resource group or subscription, you can use the `scope` property and a module to specify the target resource group and subscription scope.

For more information refer to the Bicep documentation on [scopes](https://docs.microsoft.com/azure/azure-resource-manager/bicep/deploy-to-resource-group?tabs=azure-cli#scope-to-different-resource-group).

## Next step

Now that you have modeled your infrastructure in Bicep, you can add your Radius application and services:

{{< button page="bicep-application" text="Model your application and services" >}}

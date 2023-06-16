---
type: docs
title: "Microsoft Azure resources"
linkTitle: "Microsoft Azure"
description: "Deploy and connect to Azure resources in your application"
weight: 800
categories: "Concept"
tags: ["Azure"]
---

Radius applications are able to connect to and leverage every Azure resource with Bicep. Simply model your Azure resources in Bicep and add a connection from your Radius resources.

## Configure an Azure Provider

The Azure provider allows you to deploy and connect to Azure resources from a self-hosted Radius environment. 

### Prerequisites

- [Azure subscription](https://azure.com)
- [az CLI](https://aka.ms/azcli)

### Add a cloud provider when initializing an environment

1. Initialize a new [environment]({{< ref environments >}}) with `rad init`
1. Select the Kubernetes cluster to install Radius into. Enter an environment name and base Kubernetes namespace to deploy the apps into.
1. Select "yes" to add a cloud provider and select Azure as the cloud provider
1. Specify your Azure subscription and resource group
1. Create an [Azure service principal](https://docs.microsoft.com/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac) with the [proper permissions](https://aka.ms/azadsp-more). Enter the appID, password and the tenant of the service principal
1. Deploy your app and any included Azure resources with `rad deploy`

### Add a cloud provider to an existing environment

1. Create an [Azure service principal](https://learn.microsoft.com/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac) with the [proper permissions](https://aka.ms/azadsp-more). 

   ```bash
   az ad sp create-for-rbac --role Owner --scope /subscriptions/<subscriptionid>/resourceGroups/<resourcegroupname> 
   ```
   Make sure to update the command with your subscription id and resource group name
   
1. Register the service principal in your control plane
   ```bash
   rad credential register azure --client-id <appId> --client-secret <password> --tenant-id <tenant id>
   ```
   
   Replace it with your service principal appId, password and tenant id

1. Update your environment with your Azure subscription and resource group. This is where Azure resources will be deployed.

   ```bash
   rad env update <myenv> --azure-subscription-id <subscriptionid> --azure-resource-group <resourcegroupname> 
   ```
1. Deploy your app and any included Azure resources with `rad deploy`

## Resource library

Visit [the Microsoft docs](https://docs.microsoft.com/azure/templates/) to reference every Azure resource and how to represent it in Bicep.

{{< button text="Azure resource library" link="https://docs.microsoft.com/azure/templates/" newtab="true" >}}

## Example

{{< tabs Bicep >}}

{{% codetab %}}
In the following example, a [Container]({{< ref container >}}) is connecting to an Azure Cache for Redis resource. The Container is assigned the `Redis Cache Contributor` role:

{{< rad file="snippets/azure-connection.bicep" embed=true >}}
{{% /codetab %}}

{{< /tabs >}}

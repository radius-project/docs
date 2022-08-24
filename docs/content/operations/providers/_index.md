---
type: docs
title: "Cloud providers"
linkTitle: "Cloud providers"
description: "Deploy across clouds and platforms with Radius cloud providers"
weight: 150
---

Radius cloud providers allow you to deploy and connect to cloud resources across various cloud platforms. For example, you can use the Radius Azure provider to run your application's services in your Kubernetes cluster, while deploying Azure resources to a specified Azure subcription and resource group.

<img src="providers-overview.png" alt="Diagram of cloud resources getting forwarded to cloud platforms upon deployment" width="800px" >

## Supported cloud providers

| Provider | Description |
|----------|-------------|
| [Microsoft Azure](#azure-provider) | Deploy and connect to Azure resources |

## Configure a cloud provider

When initializing a new Radius environment you can optionally configure a cloud provider for your environment

### Azure provider

The Azure provider allows you to deploy and connect to Azure resources from a self-hosted Radius environment. 

#### Prerequisites

- [Azure subscription](https://azure.com)
- [az CLI](https://aka.ms/azcli)

#### Add a cloud provider when initializing an environment

1. Initialize a new [environment]({{< ref managing-envs >}}) with `rad env init kubernetes -i`
1. Enter "y" to add an Azure cloud provider
1. Specify your Azure subscription and resource group
1. Create an [Azure service principal](https://docs.microsoft.com/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac) with the [proper permissions](https://aka.ms/azadsp-more). Enter the appID, password and the tenant of the service principal
1. Deploy your app and any included Azure resources with `rad deploy`

#### Add a cloud provider to an existing environment

1. Reinstall the control plane with the cloud provider via `rad install kubernetes --reinstall -i`
   - If using a Codespace or k3s, append `--public-endpoint-override "https://localhost:8081"` to the command
   - If using Kind, append `--public-endpoint-override "http://localhost:8080"` to the command
2. Enter "y" to add an Azure cloud provider
3. Specify your Azure subscription and resource group
4. Create an [Azure service principal](https://docs.microsoft.com/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac) with the [proper permissions](https://aka.ms/azadsp-more). Enter the appID, password and the tenant of the service principal 
5. Deploy your app and any included Azure resources with `rad deploy`

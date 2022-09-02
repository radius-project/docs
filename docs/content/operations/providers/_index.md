---
type: docs
title: "Cloud providers"
linkTitle: "Cloud providers"
description: "Deploy across clouds and platforms with Radius cloud providers"
weight: 40
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

1. Initialize a new [environment]({{< ref environments >}}) with `rad env init kubernetes -i`
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

#### Add a cloud provider to an AKS cluster using AAD pod identity

[Azure Active Directory (Azure AD) pod-managed identities](https://docs.microsoft.com/azure/aks/use-azure-ad-pod-identity) use Kubernetes primitives to associate managed identities for Azure resources and identities in Azure AD with pods. Administrators create identities and bindings as Kubernetes primitives that allow pods to access Azure resources that rely on Azure AD as an identity provider.

1. Enable the preview az aks addon:
   ```bash
   az extension add --name aks-preview && az extension update --name aks-preview
   ```
1. Deploy an AKS cluster with [pod identity](https://docs.microsoft.com/azure/aks/use-azure-ad-pod-identity) enabled, or enable it on your existing cluster
   ```bash
   az aks create -g MY_RESOURCE_GROUP -n MY_CLUSTER --enable-pod-identity --enable-pod-identity-with-kubenet
   ```
   or
   ```bash
   az aks update -g MY_RESOURCE_GROUP -n MY_CLUSTER --enable-pod-identity --enable-pod-identity-with-kubenet
   ```
1. Deploy a User Assigned Managed identity, and give it a Contributor (or custom) role assignment to your desired Azure resource group
   ```bash
   az identity create --resource-group MY_RESOURCE_GROUP --name IDENTITY_NAME
   export IDENTITY_CLIENT_ID="$(az identity show -g MY_RESOURCE_GROUP -n IDENTITY_NAME --query clientId -otsv)"
   export IDENTITY_RESOURCE_ID="$(az identity show -g MY_RESOURCE_GROUP -n IDENTITY_NAME --query id -otsv)"
   ```
   ```bash
   GROUP_RESOURCE_ID=$(az group show -n MY_RESOURCE_GROUP -o tsv --query "id")
   az role assignment create --role "Contributor" --assignee "$IDENTITY_CLIENT_ID" --scope $GROUP_RESOURCE_ID
   ```
1. Create a pod identity named "radius" with the User Assigned Managed identity:
   ```bash
   az aks pod-identity add --resource-group MY_RESOURCE_GROUP --cluster-name MY_CLUSTER --namespace radius-system  --name radius --identity-resource-id ${IDENTITY_RESOURCE_ID}
   ```
1. Install the Radius Helm chart with the azure provider values set:
   ```bash
   helm upgrade radius radius/radius --install --create-namespace --namespace radius-system --version 0.12.0 --wait --timeout 15m0s --set rp.provider.azure.podidentity=radius --set rp.provider.azure.subscriptionId=MY_SUBSCIRPTION_ID --set rp.provider.azure.resourceGroup=MY_RESOURCE_GROUP
   ```

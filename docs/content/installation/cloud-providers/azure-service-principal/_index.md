---
type: docs
title: "How to configure Azure credentials using a service principal"
linkTitle: "Azure Service Principal"
description: "Learn how to configure Azure credentials using a service principal in the Radius control plane"
weight: 300
aliases:
  - /guides/installation/cloud-providers/azure/service-principal/
---

Radius authenticates to Azure with a service principal to deploy and connect to Azure resources. This guide creates a service principal and registers it as an Azure credential in the Radius control plane.

## Step 1: Create a service principal

Radius authenticates to Azure with a service principal. Create one and note the `appId`, `password`, and `tenant`:

```bash
az ad sp create-for-rbac
```

```
{
  "appId": "****",
  "displayName": "****",
  "password": "****",
  "tenant": "****"
}
```

Grant the service principal access to the resource group using the Azure role that allows creating the resources you plan to deploy.

## Step 2a: Interactively via `rad initialize`

If Radius has not been installed already, [`rad initialize --full`]({{< ref rad_initialize >}}) can be used to interactively install Radius and configure an Azure service principal at the same time.

<!-- TODO: Remove the `--preview` flag from `rad initialize --full` below once it is no longer required. -->
```bash
rad initialize --full --preview
```

Follow the prompts:

1. When prompted with **"Add cloud providers for cloud resources?"**, select **Yes**.
1. Select **Azure**, then **Service Principal**.
1. Enter the **`appId`**, **`password`**, and **`tenant`** recorded in [Step 1](#step-1-create-a-service-principal).
1. Enter the **Azure subscription ID** and **resource group** to use for the `default` Environment. The resource group must already exist.

## Step 2b: Manual configuration

Create the Azure credential in the Radius control plane with [`rad credential register azure sp`]({{< ref rad_credential_register_azure_sp >}}):

```bash
rad credential register azure sp \
  --client-id myClientId \
  --client-secret myClientSecret \
  --tenant-id myTenantId
```

Radius will use the provided service principal for all interactions with Azure.

## Step 3: Update existing Environments

If you have existing Environments, you must also update your Environments with your Azure subscription ID and resource group. The resource group must already exist:

<!-- TODO: Remove the `--preview` flag from `rad environment` below once it is no longer required. -->
```bash
rad environment update myEnvironment \
  --azure-subscription-id myAzureSubscriptionId \
  --azure-resource-group myAzureResourceGroup \
  --preview
```

This command updates the configuration of an environment for properties that are able to be changed. For more information visit [`rad environment update`]({{< ref rad_environment_update >}}).

## Next steps

Once AWS or Azure credentials are configured, set up access to the Radius Dashboard.

{{< button text="Next step: How to configure access to the Radius dashboard" page="installation/dashboard" >}}

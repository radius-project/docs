---
type: docs
title: "How-To: Configure the Azure cloud provider with Workload identity"
linkTitle: "Azure provider with Workload identity"
description: "Learn how to configure the Azure provider with Workload identity for your Radius Environment"
weight: 200
categories: "How-To"
tags: ["Azure"]
---

The Azure provider allows you to deploy and connect to Azure resources from a self-hosted Radius Environment. It can be configured:

- [Interactively via `rad init`](#interactive-configuration)
- [Manually via `rad env update` and `rad credential register`](#manual-configuration)

## Prerequisites

- [Azure subscription](https://azure.com)
- [az CLI](https://aka.ms/azcli)
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Setup a supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
- [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) installed in your cluster, including the [Mutating Admission Webhook](https://azure.github.io/azure-workload-identity/docs/installation/mutating-admission-webhook.html)
-	Create an app registration at Microsoft Entra ID 
-	Configure the federated credential for Radius components to deploy Azure resources following the script [here](insertscript) or manually configure the federated credential following the steps [here](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azp#kubernetes) 
   | Cluster Issuer URL | Service account name | Namespace | name |
   |---------------------|----------------------|-----------|------|
   |  |  |  |  |


## Interactive configuration

1. Initialize a new environment with [`rad init --full`]({{< ref rad_init >}}):

   ```bash
   rad init --full
   ```

1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Add an Azure provider** 
      1. Pick the subscription and resource group to deploy your Azure resources to.
      2. Select the workload identity option
      3. Enter the `appId` of the Entra ID Application
   - **Environment name** - The name of the environment to create

   You should see the following output:

      ```
      Initializing Radius...

      ✅ Install Radius {{< param version >}}
         - Kubernetes cluster: k3d-k3s-default
         - Kubernetes namespace: radius-system
         - Azure workload identity: ****
      ✅ Create new environment default
         - Kubernetes namespace: default
         - Azure: subscription ***** and resource group ***
      ✅ Scaffold application samples
      ✅ Update local configuration

      Initialization complete! Have a RAD time 😎
      ```

## Manual configuration

1. Use [`rad env update`]({{< ref rad_env_update >}}) to update your Radius Environment with your Azure subscription ID and Azure resource group:

    ```bash
    rad env update myEnvironment --azure-subscription-id myAzureSubscriptionId --azure-resource-group  myAzureResourceGroup
    ```

1. Use [`rad credential register azure`]({{< ref rad_credential_register_azure >}}) to add the Workload identity to the Radius Environment:

    ```bash
    rad credential register azure wi --client-id myClientId  --tenant-id myTenantId
    ```

    Radius will use the provided client-id for all interactions with Azure, including Bicep and Recipe deployments.

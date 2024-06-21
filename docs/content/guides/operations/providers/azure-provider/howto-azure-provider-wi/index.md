---
type: docs
title: "How-To: Configure the Azure cloud provider with Azure workload identity"
linkTitle: "Azure provider with Workload identity"
description: "Learn how to configure the Azure provider with Azure workload identity for your Radius Environment"
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
  - You will need the cluster's OIDC Issuer URL. [AKS Example](https://azure.github.io/azure-workload-identity/docs/installation/managed-clusters.html#azure-kubernetes-service-aks)
- [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) installed in your cluster, including the [Mutating Admission Webhook](https://azure.github.io/azure-workload-identity/docs/installation/mutating-admission-webhook.html)

## Setup the Azure Workload Identity for Radius

To authorize Radius to connect to Azure using Azure workload identity, you should set up an Entra ID Application with access to your resource group and 3 federated credentials (one for each of the Radius services). The 3 federated credentials should be created with the Kubernetes ServiceAccounts for each of the Radius services (applications-rp, bicep-de, and ucp) in the `radius-system` namespace and the OIDC Issuer for your Kubernetes cluster.

Below is an example script that will create an Entra ID Application and set up the federated credentials necessary for Radius to authenticate with Azure using Azure workload identity.

{{< rad file="snippets/install-radius-azwi.sh" embed=true lang=bash >}}

Now that the setup is complete, you can now install Radius with Azure workload identity enabled.

## Interactive configuration

1. Initialize a new environment with [`rad init --full`]({{< ref rad_init >}}):

   ```bash
   rad init --full
   ```

1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Add an Azure provider** 
      1. Pick the subscription and resource group to deploy your Azure resources to.
      2. Select the "Workload Identity" option
      3. Enter the `appId` and the `tenantID` of the Entra ID Application
   - **Environment name** - The name of the environment to create

   You should see the following output:

      ```
      Initializing Radius...

      ✅ Install Radius {{< param version >}}
         - Kubernetes cluster: k3d-k3s-default
         - Kubernetes namespace: radius-system
         - Azure credential: WorkloadIdentity                                                       
         - Client ID: **********
      ✅ Create new environment default
         - Kubernetes namespace: default
         - Azure: subscription ***** and resource group ***
      ✅ Scaffold application samples
      ✅ Update local configuration

      Initialization complete! Have a RAD time 😎
      ```

## Manual configuration

1. Use [`rad install kubernetes`]({{< ref rad_install_kubernetes >}}) to install Radius with Azure workload identity enabled:

    ```bash
    rad install kubernetes --set global.azureWorkloadIdentity.enabled=true
    ```

1. Create your resource group and environment:

    ```bash
    rad group create default
    rad env create default
    ```

1. Use [`rad env update`]({{< ref rad_env_update >}}) to update your Radius Environment with your Azure subscription ID and Azure resource group:

    ```bash
    rad env update myEnvironment --azure-subscription-id myAzureSubscriptionId --azure-resource-group  myAzureResourceGroup
    ```

1. Use [`rad credential register azure wi`]({{< ref rad_credential_register_azure_wi >}}) to add the Azure workload identity credentials:

    ```bash
    rad credential register azure wi --client-id myClientId --tenant-id myTenantId
    ```

    Radius will use the provided client-id for all interactions with Azure, including Bicep and Recipe deployments.

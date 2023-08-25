---
type: docs
title: "How-To: Configure Azure provider"
linkTitle: "Configure Azure provider"
description: "Learn how to configure the Azure provider for your Radius environment"
weight: 200
categories: "How-To"
tags: ["Azure"]
---

The Azure provider allows you to deploy and connect to Azure resources from a self-hosted Radius environment. 

## Prerequisites

- [Azure subscription](https://azure.com)
- [az CLI](https://aka.ms/azcli)

## Configure an Azure provider when initializing an environment interactively

1. Initialize a new environment with [`rad init --full`]({{< ref rad_init >}}):
   ```bash
   rad init --full
   ```

1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Add an Azure provider** - Pick the subscription and resource group to deploy your Azure resources to
      Run `az ad sp create-for-rbac` to create a Service Principal without a role assignment and obtain your `appId`, `displayName`, `password`, and `tenant` information.
      ```
         {
         "appId": "****",
         "displayName": "****",
         "password": "****",
         "tenant": "****"
         }
         ```
         Enter the `appId`, `password`, and `tenant` information when prompted.
   - **Environment name** - The name of the environment to create

   You should see the following output:

      ```
      Initializing Radius...                     

      ✅ Install Radius {{< param version >}}               
         - Kubernetes cluster: k3d-k3s-default   
         - Kubernetes namespace: radius-system 
         - Azure service principal: ****  
      ✅ Create new environment default          
         - Kubernetes namespace: default 
         - Azure: subscription ***** and resource group ***        
      ✅ Scaffold application samples            
      ✅ Update local configuration              

      Initialization complete! Have a RAD time 😎
      ```
   
## Configure an Azure provider manually

1. Use [`rad env update`]({{< ref rad_env_update >}}) to update your Radius Environment with your Azure subscription ID and Azure resource group:

    ```bash
    rad env update myEnvironment --azure-subscription-id myAzureSubscriptionId --azure-resource-group  myAzureResourceGroup
    ```

2. Run `az ad sp create-for-rbac` to create a Service Principal without a role assignment and obtain your `appId`, `displayName`, `password`, and `tenant` information.

   ```
   {
   "appId": "****",
   "displayName": "****",
   "password": "****",
   "tenant": "****"
   }
   ```


3. Use [`rad credential register azure`]({{< ref rad_credential_register_azure >}}) to add the Azure service principal to your Radius installation:
    ```bash
    rad credential register azure --client-id myClientId  --client-secret myClientSecret  --tenant-id myTenantId
    ```
    Radius will use the provided service principal for all interactions with Azure, including Bicep and Recipe deployments.

---
type: docs
title: "How-To: Deploy an Application to Azure Container Instances"
linkTitle: "Deploy to ACI"
description: "Learn how to configure and deploy an application to Azure Container Instances"
weight: 500
slug: 'azure-container-instances'
categories: "How-To"
tags: ["Azure","containers"]
---

This how-to guide will provide an overview of how to:

- Configure and deploy a Radius [Environment]({{< ref "/guides/deploy-apps/environments/overview" >}}) that uses [Azure Container Instances (ACI)](https://learn.microsoft.com/en-us/azure/container-instances/) as the compute provider.
- Define and deploy the demo application to the Environment using Radius to provision the necessary resources to run the application containers in ACI.

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- Radius installed and initiated on a [supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
- Azure provider configured and registered with your Radius control plane, either through [Service Principal](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-sp/) or [Workload Identity](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-wi/)
- A [user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp) that has been [assigned](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal-managed-identity) to the `Contributor` and `Azure Container Instances Contributor` roles on the subscription or resource group where the ACI will be deployed

## Step 1: Define the Environment with ACI compute

Create a new file named `app.bicep` and add the following Environment definition. This Environment uses the `aci` compute provider and a user-assigned managed identity to provision the necessary resources for ACI and also registers a default Recipe for provisioning an Azure Redis Cache.

{{< rad file="snippets/app.bicep" embed=true marker="//ENVIRONMENT">}}

> Note: be sure to replace the `resourceGroup` and `scope` values with your resource group ID and the `managedIdentity` value with your managed identity ID.

## Step 2: Deploy the Environment

1. Run the following command to deploy the Environment:
   ```bash
   rad deploy ./app.bicep --resource-group aciGroup
   ```

   You should see the following terminal output:

   ```
   Deployment In Progress...

   Deployment Complete

   Resources:
   aci-demo Applications.Core/environments
   ```

## Step 3: Define the Application and its resources

Add the application definition, along with Redis cache and gateway resources to the `app.bicep` file.

{{< rad file="snippets/app.bicep" embed=true marker="//APPLICATION" >}}

Add the application Container resource to the `app.bicep` file.

{{< rad file="snippets/app.bicep" embed=true marker="//CONTAINER" >}}

> Notice that for ACI containers, you define a Gateway resource that provides L7 traffic for the container. Radius will provision the Gateway in Azure on your behalf and configure the container to use the Gateway as its ingress. The Gateway will be provisioned with a public IP address and a DNS name that you can use to access the application.

## Step 4: Deploy the Application

Run the following command to deploy the application:

```bash
rad deploy ./app.bicep
```

You should see the following terminal output:

```
Deployment In Progress... 

Completed            database        Applications.Datastores/redisCaches
Completed            gateway         Applications.Core/gateways
Completed            demo-app        Applications.Core/applications
..                   frontend        Applications.Core/containers

Deployment Complete

Resources:
    demo-app        Applications.Core/applications
    frontend        Applications.Core/containers
    gateway         Applications.Core/gateways
    database        Applications.Datastores/redisCaches

Public Endpoints:
    gateway         Applications.Core/gateways http://gateway.demo-app.4.149.194.115.nip.io
```

## Step 5: View the deployed resources

Navigate to your resource group in the [Azure portal](https://portal.azure.com/) and you should see the relevant Azure resources that were provisioned by Radius for your application, including the container instance, container group profile, Ngroup, load balancer, virtual network, and network security groups that are required for the application to run on ACI.

{{< image src="azure-portal.png" alt="Screenshot of the Azure portal showing the resource group with all the ACI resources" width=800px >}}

## Step 6: Browse the Application

Open a web browser and navigate to the public IP address of the Gateway resource. You should see the demo application landing page running on your Azure Container Instance, along with some information about the application and its resources.

{{< image src="demo-app-landing.png" alt="Screenshot of the demo app landing page" width=700px >}}

Navigate to the Todo List tab and test out the application. Using the Todo page will update the saved state in your Azure Redis cache.

{{< image src="demo-app.png" alt="Screenshot of the todo list in the demo app" width=700px >}}

## Cleanup

1. Run the following command to delete your app and its container and Redis cache resources:

   ```bash
   rad app delete demo-app --yes
   ```
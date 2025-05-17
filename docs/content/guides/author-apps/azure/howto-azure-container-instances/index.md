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
- Define and deploy the demo application to the Environment using Radius, which provisions the necessary resources to run the application containers in ACI.

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- Radius [installed]({{< ref "/guides/operations/kubernetes/kubernetes-install" >}}) on a [supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-kubernetes-clusters" >}})
- An Azure provider configured and registered with your Radius control plane, either through [Service Principal](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-sp/) or [Workload Identity](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-wi/) that have been assigned to the `Contributor` and `Azure Container Instances Contributor` roles on the subscription or resource group where the ACI containers will be deployed
- A [managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/) is [required]({{< ref "/reference/resource-schema/core-schema/environment-schema#identity" >}}) for ACI deployments, if you choose to utilize a [user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp) then you need to ensure it is assigned to the `Contributor` and `Azure Container Instances Contributor` roles on the subscription or resource group where the ACI containers will be deployed

## Step 1: Create a Radius Resource Group and Workspace

Since the Radius control plane is hosted on your Kubernetes cluster, you'll need to create a new Radius Resource Group and Workspace so that you may target your application deployments to an ACI Environment. These will then be associated with the ACI Environment that you will configure and create in subsequent steps. 

1. Create a new Radius Resource Group called `aciGroup`:
   ```bash
   rad group create aciGroup
   ```

1. Then, create a new Radius Workspace called `aci-workspace`:
   ```bash
   rad workspace create kubernetes aci-workspace
   ```

## Step 2: Define the Environment with ACI compute

Create a new file named `app.bicep` and add the following Environment definition. This Environment uses the `aci` compute provider and a user-assigned managed identity to provision the necessary resources for ACI and also registers a default Recipe for provisioning an Azure Redis Cache.

{{< rad file="snippets/app.bicep" embed=true marker="//ENVIRONMENT">}}

> Note: be sure to replace the `resourceGroup` and `scope` values with your resource group ID and the `managedIdentity` value with your managed identity resource ID.

## Step 3: Deploy the Environment

1. Run the following command to deploy the Environment and associate it with the `aci-workspace` you created in the previous step:
   ```bash
   rad deploy ./app.bicep --workspace aci-workspace
   ```

   You should see the following terminal output:

   ```
   Deployment In Progress...

   Deployment Complete

   Resources:
   aci-demo Applications.Core/environments
   ```

<br>

Navigate to your resource group in the [Azure portal](https://portal.azure.com/) and you should see the relevant Azure resources that were provisioned by Radius for your ACI Environment, including the virtual network, internal load balancer, and network security group:

{{< image src="azure-portal-env.png" alt="Screenshot of the Azure portal showing the resource group with the virtual network, internal load balancer, and network security group resources created by Radius" width=700px >}}

## Step 4: Define the Application and its resources

Add the application definition, along with Redis cache and gateway resources to the `app.bicep` file.

{{< rad file="snippets/app.bicep" embed=true marker="//APPLICATION" >}}

Add the application Container resource to the `app.bicep` file.

{{< rad file="snippets/app.bicep" embed=true marker="//CONTAINER" >}}

> Notice that for ACI containers, you define a Gateway resource that provides L7 traffic for the container. Radius will provision an Azure Application Gateway on your behalf and configure the container to use the Gateway as its ingress. The Gateway will be provisioned with a public IP address and a DNS name that you can use to access the application.

## Step 5: Deploy the Application

Run the following command to deploy the application:

```bash
rad deploy ./app.bicep --workspace aci-workspace
```

> Note that you are deploying the application specifically targeting the `aci-workspace` you had created in a previous step, which ensures that your application gets deployed to the ACI Environment. The same application can also be targeted to deploy into a Kubernetes Environment instead.

Once the deployment succeeds, you should see the following terminal output:

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

## Step 6: View the deployed resources

Now you can check the Radius application graph in your terminal to view resources that were provisioned for your application:

```bash
rad app graph -a demo-app
```

You should see the following output:

```
Displaying application: demo-app

Name: frontend (Applications.Core/containers)
Connections:
  gateway (Applications.Core/gateways) -> frontend
  frontend -> database (Applications.Datastores/redisCaches)
Resources:
  frontend (Microsoft.ContainerInstance/containerGroupProfiles)
  frontend (Microsoft.ContainerInstance/nGroups)
  frontend (Microsoft.Network/loadBalancers/applications)
  frontend (Microsoft.Network/virtualNetworks/subnets)

Name: gateway (Applications.Core/gateways)
Connections:
  gateway -> frontend (Applications.Core/containers)
Resources:
  gateway (Microsoft.Network/applicationGateways)
  gateway-nsg (Microsoft.Network/networkSecurityGroups)
  gateway (Microsoft.Network/publicIPAddresses)
  gateway (Microsoft.Network/virtualNetworks/subnets)

Name: database (Applications.Datastores/redisCaches)
Connections:
  frontend (Applications.Core/containers) -> database
Resources:
  cache-vxkt2iou25nht (Microsoft.Cache/redis)
```

Navigate to your resource group in the [Azure portal](https://portal.azure.com/) and you should see the relevant Azure resources that were provisioned by Radius for your application, including the container instance, container group profile, Ngroup, load balancer, virtual network, and network security groups that are required for the application to run on ACI:

{{< image src="azure-portal-app.png" alt="Screenshot of the Azure portal showing the resource group with all the ACI resources" width=700px >}}
<br>

## Step 7: Browse the Application

In your Azure portal, click on the Gateway public IP address resource and you should see the public IP address of the Gateway resource. This is the public DNS name that you can use to access your application. Copy the public DNS name.

{{< image src="azure-portal-gateway.png" alt="Screenshot of the Azure portal showing the public IP address of the Gateway resource" width=700px >}}<br>

Open a web browser and in the address bar paste in the public DNS name of the Gateway resource that you just copied with a `:3000` appended to that address, as the application container is exposed to users on port 3000. You should see the demo application landing page showing that your application is running on your Azure Container Instance, along with some information about its containers and resources.

{{< image src="demo-app-landing.png" alt="Screenshot of the demo app landing page" width=700px >}}

Navigate to the Todo List tab and test out the application. Using the Todo page will update the saved state in your Azure Redis cache.

{{< image src="demo-app.png" alt="Screenshot of the todo list in the demo app" width=700px >}}

## Cleanup

1. Run the following command to delete your app and its container and Redis cache resources:

   ```bash
   rad app delete demo-app --yes
   ```

1. Run the following command to delete your environment:

   ```bash
   rad env delete aci-env --yes
   ```

1. Run the following command to delete your workspace:

   ```bash
   rad workspace delete aci-workspace --yes
   ```

1. Finally, navigate to your Azure portal and delete the related resources that were created for the ACI Environment, namely the virtual network, internal load balancer, and network security group. You can also delete the resource group if you no longer need it.

   {{< image src="azure-portal-env.png" alt="Screenshot of the Azure portal showing the resource group with the virtual network, internal load balancer, and network security group resources created by Radius" width=700px >}}

## Further reading
- [Azure resources overview]({{< ref "/guides/author-apps/azure/overview" >}})
- [Radius Environment schema]({{< ref "/reference/resource-schema/core-schema/environment-schema" >}})
- [Radius Application schema]({{< ref "/reference/resource-schema/core-schema/application-schema" >}})
- [Radius Container schema]({{< ref "/reference/resource-schema/core-schema/container-schema" >}})
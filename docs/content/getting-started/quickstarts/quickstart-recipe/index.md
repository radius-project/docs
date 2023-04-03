---
type: docs
title: "Quickstart: Deploy Recipes in your Radius Application"
linkTitle: "Recipes"
description: "Learn how to use Radius Recipes within your application"
weight: 500
slug: "recipes"
---

This quickstart will teach you:

* How to use community “dev” Recipes in your Radius Environment
* How to deploy your own Recipes in your Radius Environment for multiple cloud providers.
* How to author your own Recipes

## Prerequisites

- Install the [rad CLI]({{< ref getting-started >}})
- [Supported Kubernetes clusters]({{< ref kubernetes >}})

## Overview

[Recipes]({{< ref recipes >}}) enable a separation of concerns between infrastructure teams and developers by automating infrastructure deployment.

### How?

Recipes are a collection of infrastructure resources that can be deployed as part of a Radius application. Currently Recipes can be written in [Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) and can be stored in [Azure Container Registries](https://azure.microsoft.com/en-us/products/container-registry/).

## Application overview

<img src="recipe-quickstart-diagram.png" alt="Screenshot of the todoapp with Kubernetes, Azure and AWS Redis Cache options" style="width:100%" >

### **todoapp** explained:

The following application you'll be deploying is made up of the following IaC application model:

-  The **frontend** [container]({{< ref container >}}) resource which contains:

   - application: The application to which this container belongs. The ID of the application defined above is used.
   - container image: The container image to run. This is where your website's front end code lives.
   - container ports: The ports to expose on the container, along with the [HttpRoute]({{< ref httproute >}}) that will be used to access the container.
   - connections: The connections to make to other resources. In this case, the frontend container will connect to the backing database.

- The **db** [Link resource]({{< ref link-schema >}}) provides an abstraction for an infrastructure resource through its API, allowing the backing resource type to be swapped out without changing the way the consuming resource is defined.

## Step 1: Initialize a Radius environment 
Navigate to the directory where you want to create your application and run the following command:

1. Use the `rad init --dev` command to initialize a new environment with [community `dev` Recipes]({{< ref "recipes#use-community-dev-recipes" >}}) linked to your environment:

   ```bash
   rad init --dev
   ```

   Follow the prompts to install the [control plane services]({{< ref architecture >}}), create an [environment resource]({{< ref environments >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:
   * **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `local`.

{{% alert title="📄 Cloud Providers" color="primary" %}}
To learn more about how to configure cloud providers such as AWS and Azure please visit our [cloud provider page]({{<ref providers >}}).
{{% /alert %}}


### Community `dev` Recipes

The Radius community provides Recipes for running commonly used application dependencies, including Redis. 

 ```bash
   rad recipe list 
   ```

   ```
   NAME              TYPE                              TEMPLATE
   redis-aws         Applications.Link/redisCaches     radius.azurecr.io/recipes/rediscaches/aws:1.0
   redis-kubernetes  Applications.Link/redisCaches     radius.azurecr.io/recipes/rediscaches/kubernetes:1.0
   redis-azure       Applications.Link/redisCaches     radius.azurecr.io/recipes/rediscaches/azure:1.0
   ```

| Recipe | Description |
|---------|-------------|
|`redis-aws`|`redis-aws` provisions a new MemoryDB in the same VPC as your EKS cluster. Deploying to the same VPC is the recommended way to access a MemoryDB cluster from your EKS cluster. It also optionally accepts `subnetIds` as a parameter, which can be supplied to use a different set of Subnet Ids.|
|`redis-kubernetes`| provisions a new redis container |
|`redis-azure`| provisions a new Azure cache for Redis |

 ## Step 2: Deploy your application

1. Create a Bicep file `app.bicep` with the following content:

{{< rad file="snippets/app.bicep" embed=true >}}


{{< tabs Kubernetes Azure AWS >}}
{{% codetab %}}

Update the recipe name to `redis-kubernetes` to use the redis container

1. Use the `rad run ` command to initialize a new environment:

   ```bash
   rad run app.bicep
   ```

You've now deployed your application to your Kubernetes cluster. You can access your application by opening http://localhost:3000 in a browser.

{{% /codetab %}}

{{% codetab %}}
{{% /codetab %}}

{{% codetab %}}
Update the recipe name to `redis-aws` to use the redis container

1. Deploy your application to your environment:

   ```bash
   rad deploy ./app.bicep --parameters eksClusterName=YOUR_EKS_CLUSTER_NAME
   ```

   Make sure to replace `YOUR_EKS_CLUSTER_NAME` with your EKS cluster name.

   This will deploy the application into your environment and launch the container resource for the frontend website. This operation may take some time, since it is deploying a MemoryDB resource to AWS. You should see the following resources deployed at the end of `rad deploy`:

   ```
   Deployment In Progress...

   Completed            memorydb-module Microsoft.Resources/deployments
   Completed            webapp          Applications.Core/applications
   Completed            demo-memorydb-subnet-group AWS.MemoryDB/SubnetGroup
   Completed            demo-memorydb-cluster AWS.MemoryDB/Cluster
   Completed            <YOUR_EKS_CLUSTER_NAME> AWS.EKS/Cluster     
   Completed            demo-memorydb-cluster AWS.MemoryDB/Cluster
   Completed            db              Applications.Link/redisCaches
   Completed            frontend        Applications.Core/containers

   Deployment Complete

   Resources:
      <YOUR_EKS_CLUSTER_NAME> AWS.EKS/Cluster     
      demo-memorydb-cluster AWS.MemoryDB/Cluster
      demo-memorydb-subnet-group AWS.MemoryDB/SubnetGroup
      db              Applications.Link/redisCaches
      webapp          Applications.Core/applications
      frontend        Applications.Core/containers
   ```  
{{% /codetab %}}
{{< /tabs >}}


## Next steps
- To learn how to create your own custom Recipe visit our [administrator guide]({{< ref custom-recipes.md >}})

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
- A supported [Kubernetes cluster]({{< ref kubernetes >}})

## Overview

[Recipes]({{< ref recipes >}}) enable a separation of concerns between infrastructure teams and developers by automating infrastructure deployment. Developers define _what_ they need (_Redis, Mongo, etc._), and operators define _how_ it will be deployed (_Azure/AWS/Kubernetes infrastructure_).

## Application overview

This application is a simple to-do list which stores and visualized to-do items. It consists of a frontend [container]({{< ref container >}}) and a backend [Redis Link]({{< ref links >}}):

<img src="recipe-quickstart-diagram.png" alt="Screenshot of the todoapp with Kubernetes, Azure and AWS Redis Cache options" style="width:100%" >

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


### `dev` Recipes

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

 ## Step 2: Deploy your application with a Kubernetes recipe

1. Create a Bicep file `app.bicep` with the following content:

{{< rad file="snippets/app.bicep" embed=true >}}

Update the recipe name to `redis-kubernetes` to use the redis container

1. Use the `rad run` command to initialize a new environment:

   ```bash
   rad run app.bicep
   ```

You've now deployed your application to your Kubernetes cluster. You can access your application by opening http://localhost:3000 in a browser.


## Step 3: Use Azure / AWS recipes in your application
> *This step needs an Azure subscription or an AWS account to deploy the application which would incur some costs. Add the required cloud provider (AWS/Azure) to your environment in order to deploy an Azure or AWS recipe*

{{< tabs Azure AWS >}}
{{% codetab %}}

{{% /codetab %}}

{{% codetab %}}

Update the recipe name to `redis-aws` to use the redis container

> *You can run this only on an EKS cluster. Make sure that the each of the Subnets in your EKS cluster Subnet Group are within the [list of supported MemoryDB availability zones](https://docs.aws.amazon.com/memorydb/latest/devguide/subnetgroups.html)*

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

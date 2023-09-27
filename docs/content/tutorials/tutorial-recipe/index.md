---
type: docs
title: "How-To: Deploy Recipes in your Radius Application"
linkTitle: "Recipes"
description: "Learn how to use Radius Recipes within your application"
weight: 500
slug: "recipes"
categories: "How-To"
tags : ["recipes"]
---

This how-to guide will teach you:

* How to use “dev” Recipes in your Radius Environment to quickly run with containerized infrastructure.
* How to deploy your own Recipes in your Radius Environment to leverage cloud resources.

## Prerequisites

- Install the [rad CLI]({{< ref getting-started >}})
- Setup a supported [Kubernetes cluster]({{< ref "guides/operations/kubernetes" >}})

## Overview

[Recipes]({{< ref "guides/recipes/overview">}}) enable a separation of concerns between infrastructure teams and developers by automating infrastructure deployment. Developers define _what_ they need (_Redis, Mongo, etc._), and operators define _how_ it will be deployed (_Azure/AWS/Kubernetes infrastructure_).

{{< button text="Learn more about Recipes here" page="/guides/recipes/overview" newtab="true" >}}

## Application overview

This application is a simple to-do list which stores and visualizes to-do items. It consists of a frontend [container]({{< ref "guides/author-apps/containers" >}}) and a backend [Redis Cache]({{< ref redis >}}).

<img src="recipe-tutorial-diagram.png" alt="Screenshot of the todoapp with Kubernetes, Azure and AWS Redis Cache options" style="width:500px" >

{{< alert title="💡 Portable resources" color="info" >}}
Developers don't need to specify what cloud resources they're using in their application. Instead, they choose the portable Redis API which can be provided by any cloud provider (or a Docker container). When deployed, a Recipe will select what infrastructure to deploy and run.
{{< /alert >}}

## Step 1: Initialize a Radius environment

1. Begin in a new directory for your application:

   ```bash
   mkdir recipes
   cd recipes
   ```
2. Initialize a new dev environment:

   ```bash
   rad init
   ```

   **Select 'Yes' when prompted to create an application.**

3. Use [`rad recipe list`]({{< ref rad_recipe_list >}}) to view the Recipes in your environment:

   ```bash
   rad recipe list 
   ```

   You should see a table of available Recipes (_with more to be added soon_):
   
   ```
   NAME          TYPE                              TEMPLATE
   default       Applications.Datastores/redisCaches     radius.azurecr.io/recipes/dev/rediscaches:v0.21
   ```

   {{< alert title="💡 Dev Recipes" color="info" >}}
   Dev environments are preloaded with [`dev` Recipes]({{< ref "guides/recipes/overview#use-community-dev-recipes" >}}), a set of Recipes that allow you to quickly get up and running with lightweight containerized infrastructure. In This how-to guide, the dev Redis Recipe deploys a lightweight Redis container into your Kubernetes cluster.

   When a Recipe is named "default" it will be used by default when deploying resources when a Recipe is not specified.
   {{< /alert >}}

## Step 2: Define your application

Update `app.bicep` with the following set of resources:

> app.bicep was created automatically when you ran `rad init`

{{< rad file="snippets/app.bicep" embed=true >}}

Note that no Recipe name is specified with 'db', so it will be using the default Recipe in your environment.

## Step 3: Deploy your application

1. Run [`rad deploy`]({{< ref rad_deploy >}}) to deploy your application:

   ```bash
   rad deploy ./app.bicep
   ```

   You should see the following output:
   ```
   Building app.bicep...
   Deploying template './app.bicep' for application 'recipes' and environment 'default' from workspace 'default'...

   Deployment In Progress...

   Completed            db              Applications.Datastores/redisCaches
   Completed            webapp          Applications.Core/applications
   Completed            frontend        Applications.Core/containers

   Deployment Complete

   Resources:
      webapp          Applications.Core/applications
      frontend        Applications.Core/containers
      db              Applications.Datastores/redisCaches
   ```

   Your application is now deployed and running in your Kubernetes cluster.

2. List your Kubernetes Pods to see the infrastructure container deployed by the Recipe:

   ```bash
   kubectl get pods -n default-webapp
   ```

   You will see your 'frontend' container, along with the Redis cache that was automatically created by the default dev Recipe:

   ```
   NAME                                   READY   STATUS    RESTARTS   AGE
   frontend-6d447f5994-pnmzv              1/1     Running   0          13m
   redis-ymbjcqyjzwkpg-66fdbf8bb6-brb6q   2/2     Running   0          13m
   ```

3. Port-forward the container to your machine with `rad resource expose`:

   ```bash
   rad resource expose containers frontend --port 3000
   ```

4. Visit [`http://localhost:3000`](http://localhost:3000) in your browser.

   You can now see both the environment variables of your container as well as interact with the `Todo App` and add/remove items in it as wanted:

   <img src="todoapp.png" width="700px" alt="screenshot of the todo application">
 
## Step 4: Use Azure/AWS recipes in your application

This step requires an Azure subscription or an AWS account to deploy cloud resources, which will incur costs. You will need to add the [Azure/AWS cloud provider]({{< ref providers >}}) to your environment in order to deploy Azure resources and leverage Azure Recipes.

{{< button text="Add a cloud provider" page="providers#configure-a-cloud-provider" newtab="true" >}}

{{< tabs Azure AWS>}}

{{% codetab %}}

1. Delete your existing Redis cache, which we will redeploy with an Azure resource:

   ```bash
   rad resource delete rediscaches db
   ```

2. Register the Recipe to your Radius Environment:

   ```bash
   rad recipe register azure --environment default --template-kind bicep --template-path radius.azurecr.io/recipes/azure/rediscaches:{{< param tag_version >}} --resource-type Applications.Datastores/redisCaches 
   ```

3. Update your db resource to use the `azure` Recipe, instead of the default Recipe:

   {{< rad file="snippets/app-azure.bicep" marker="//DB" embed=true >}}

4. Redeploy your application to your environment:

   ```bash
   rad deploy ./app.bicep 
   ```

   This operation may take some time, as the 'azure' Recipe is deploying an Azure Cache for Redis resource into your Azure subscription. Once complete, you should see:

   ```
   Building ./app.bicep...
   Deploying template './app.bicep' for application 'recipes' and environment 'default' from workspace 'default'...

   Deployment In Progress... 

   Completed            webapp          Applications.Core/applications
   Completed            db              Applications.Datastores/redisCaches
   Completed            frontend        Applications.Core/containers

   Deployment Complete

   Resources:
      webapp          Applications.Core/applications
      frontend        Applications.Core/containers
      db              Applications.Datastores/redisCaches
   ```
{{% /codetab %}}

{{< /tabs >}}


5. Use the az CLI to see your newly deployed Azure Cache for Redis:

   ```bash
   az redis list --subscription "My Subscription" --query "[].name" 
   ```

   You should see the name of your Redis cache, which is prefixed `cache`:

   ```
   [
     "cache-goqoxgqkw2ogw"
   ]
   ```
{{% /codetab %}}

{{% codetab %}}

> *You can run this only on an EKS cluster. Make sure that the each of the Subnets in your EKS cluster Subnet Group are within the [list of supported MemoryDB availability zones](https://docs.aws.amazon.com/memorydb/latest/devguide/subnetgroups.html)*

1. Delete your existing Redis cache, which we will redeploy with an AWS resource:

   ```bash
   rad resource delete rediscaches db
   ```

1. Register the Recipe to your Radius Environment:

   ```bash
   rad recipe register aws --environment default --template-kind bicep --template-path radius.azurecr.io/recipes/rediscaches/aws:1.0 --link-type Applications.Link/redisCaches --parameters eksClusterName=YOUR_EKS_CLUSTER_NAME
   ```
   > *Note: Passing the `eksClusterName` during the registration of the Recipe is a temporary additional step as Radius builds up AWS support.*

1. Update your db resource to use the `aws` Recipe, instead of the default Recipe:

   {{< rad file="snippets/app-aws.bicep" marker="//DB" embed=true >}}

   Update the recipe name to `aws` to use the Amazon MemoryDB for Redis.

1. Deploy your application to your environment:

   ```bash
   rad deploy ./app.bicep 
   ```

   This operation may take some time, as the ‘aws’ Recipe is deploying an AWS MemoryDB for Redis resource in your AWS account. Once complete, you should see:

   ```
   Building ./app.bicep...
   Deploying template './app.bicep' for application 'recipes' and environment 'default' from workspace 'default'...

   Deployment In Progress... 

   Completed            webapp          Applications.Core/applications
   Completed            db              Applications.Link/redisCaches
   Completed            frontend        Applications.Core/containers

   Deployment Complete

   Resources:
      webapp          Applications.Core/applications
      frontend        Applications.Core/containers
      db              Applications.Link/redisCaches
   ```

{{% /codetab %}}

{{< /tabs >}}

## Step 5: Cleanup your environment

1. You can use the rad CLI to [delete your environment]({{< ref rad_env_delete.md >}}) and all the       Radius resources running on your cluster:
   
   ```bash
   rad env delete default --yes
   ```
1. Delete the Azure Redis cache via the Azure CLI or the Azure portal, and the AWS Memory DB for Redis via the AWS CLI or the AWS console.

## Next steps

- To learn how to create your own custom Recipe visit our [administrator guide]({{< ref howto-author-recipes.md >}})

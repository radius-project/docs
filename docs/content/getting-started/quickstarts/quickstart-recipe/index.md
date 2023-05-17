---
type: docs
title: "Quickstart: Deploy Recipes in your Radius Application"
linkTitle: "Recipes"
description: "Learn how to use Radius Recipes within your application"
weight: 500
slug: "recipes"
categories: "Quickstart"
---

This quickstart will teach you:

* How to use “dev” Recipes in your Radius Environment
* How to deploy your own Recipes in your Radius Environment for multiple cloud providers.
* How to author your own Recipes

## Prerequisites

- Install the [rad CLI]({{< ref getting-started >}})
- A supported [Kubernetes cluster]({{< ref kubernetes >}})

## Overview

[Recipes]({{< ref recipes >}}) enable a separation of concerns between infrastructure teams and developers by automating infrastructure deployment. Developers define _what_ they need (_Redis, Mongo, etc._), and operators define _how_ it will be deployed (_Azure/AWS/Kubernetes infrastructure_).

{{< button text="Learn more about Recipes here" page="recipes" newtab="true" >}}

## Application overview

This application is a simple to-do list which stores and visualized to-do items. It consists of a frontend [container]({{< ref container >}}) and a backend [Redis Link]({{< ref links >}}):

<img src="recipe-quickstart-diagram.png" alt="Screenshot of the todoapp with Kubernetes, Azure and AWS Redis Cache options" style="width:1000px" >

## Step 1: Initialize a Radius environment

1. Begin in a new directory for your application:
   ```bash
   mkdir recipes
   cd recipes
   ```
2. Initialize a new dev environment, which is pre-loaded with lightweight dev Recipes:
   ```bash
   rad init --dev
   ```

   [`dev` Recipes]({{< ref "recipes#use-community-dev-recipes" >}}) allow you to quickly get up and running with infrastructure for your [Links]({{< ref links >}})._
   3. Use [`rad recipe list`]({{< ref rad_recipe_list >}}) to view the Recipes in your dev environment:

   ```bash
   rad recipe list 
   ```

   You should see a table of available Recipes (_with more to be added soon_):
   ```bash
   NAME              TYPE                              TEMPLATE
   kubernetes  Applications.Link/redisCaches     radius.azurecr.io/recipes/rediscaches/kubernetes:1.0
   ```

## Step 2: Deploy your application

1. Create a Bicep file `app.bicep` with the following content:

{{< rad file="snippets/app.bicep" embed=true >}}

2. Use the `rad deploy` command to deploy your application:

   ```bash
   rad deploy ./app.bicep
   ```

   You should see the following logs:
   ```
   Building app.bicep...
   Deploying template 'app.bicep' into environment 'default' from workspace 'default'...

   Deployment In Progress...

   Completed            db              Applications.Link/redisCaches
   Completed            webapp          Applications.Core/applications
   Completed            frontend        Applications.Core/containers

   Deployment Complete

   Resources:
      webapp          Applications.Core/applications
      frontend        Applications.Core/containers
      db              Applications.Link/redisCaches
   ```


You've now deployed your application to your Kubernetes cluster!

3.To confirm that the infrastructure deployed by the Recipe is correctly deployed in a Kubernetes pod you can leverage `kubectl`.

   You should be able to see the following output by running:

   ```bash
   kubectl get pods -n default-webapp
   ```

4. Port-forward the container to your machine with `rad resource expose`:

   ```bash
   rad resource expose containers frontend -a webapp --port 3000
   ```

5. Visit `localhost:3000` in your browser.

   You will now be able to see both the metadata of your container application as well as interact with the `Todo App` and add/remove items in it as wanted.

## Step 3: Use Azure / AWS recipes in your application

> *This step needs an Azure subscription or an AWS account to deploy the application which would incur some costs. Add the required cloud provider (AWS/Azure) to your environment in order to deploy an Azure or AWS recipe*

{{< button text="Learn more about configuring Cloud providers" page="providers#configure-a-cloud-provider" newtab="true" >}}

{{< tabs Azure AWS >}}
{{% codetab %}}

1. Register the Recipe to your Radius Environment:

   ```bash
   rad recipe register azure -e default  --template-path radius.azurecr.io/recipes/rediscaches/azure:1.0 --link-type Applications.Link/redisCaches
   ```

   Update the Recipe name given to the resource to `azure` to use the Redis cache on Azure .

2. Deploy your application to your environment:

   ```bash
   rad deploy ./app.bicep 
   ```

   This will deploy the application into your environment and launch the container resource for the frontend website. This operation may take some time, since it is deploying a Redis Cache resource to Azure. You should see the following resources deployed at the end of `rad deploy`:

   ```
   Building ./app.bicep...
   Deploying template './app.bicep' for application 'samples' and environment 'default' from workspace 'default'...

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

{{% codetab %}}

> *You can run this only on an EKS cluster. Make sure that the each of the Subnets in your EKS cluster Subnet Group are within the [list of supported MemoryDB availability zones](https://docs.aws.amazon.com/memorydb/latest/devguide/subnetgroups.html)*

1. Register the Recipe to your Radius Environment:

   ```bash
   rad recipe register aws -e default  --template-path radius.azurecr.io/recipes/rediscaches/aws:1.0 --link-type Applications.Link/redisCaches
   ```

   Update the recipe name to `redis-aws` to use the Amazon MemoryDB for Redis and pass the eksClusterName as parameter to the recipe.

   ```bicep
   resource db 'Applications.Link/redisCaches@2022-03-15-privatepreview' = {
      name: 'db'
      location: location
      properties: {
         environment: environment
         mode: 'recipe'
         recipe: {
            name: 'redis-aws'
            parameters: {
               eksClusterName: eksClusterName
            }
         }
      }
   }
   ```

2. Deploy your application to your environment:

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

1. Port-forward the container to your machine with [`rad resource expose`]({{< ref rad_resource_expose>}})

    ```bash
    rad resource expose containers frontend -a webapp --port 3000
    ```
1. Visit [localhost:3000](http://localhost:3000) in your browser. You should see a page like

   <img src="todoapp.png" width="1000" alt="screenshot of the todo application">

   You can play around with the application's features:

   - Add a todo item
   - Mark a todo item as complete
   - Delete a todo item

## Step 4: Cleanup your environment

1. If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) to delete all Radius resources running on your cluster.
2. Azure/AWS resources are not deleted when deleting a Radius environment, so to prevent additional charges, make sure to delete all resources created in this quickstart. For Azure, this includes the Azure Redis cache and for AWS, this includes the SubnetGroup and MemoryDB.

## Next steps

- To learn how to create your own custom Recipe visit our [administrator guide]({{< ref custom-recipes.md >}})

---
type: docs
title: "Quickstart: Deploy Recipes in your Radius Application"
linkTitle: "Deploy Recipes in your Radius Application"
description: "Learn how to use community 'dev' Recipes and your custom made Recipes in a Radius Environment"
weight: 500
slug: "recipes"
---

This quickstart will teach you:

* How to use community “dev” Recipes in your Radius Environment
* How to author your own Recipes
* How to deploy your own Recipes in your Radius Environment for multiple cloud providers.


## Prerequisites

{{< tabs Kubernetes Azure AWS>}}

{{% codetab %}}
- [rad CLI]({{< ref getting-started >}})
- [Supported Kubernetes cluster]({{< ref kubernetes >}})
{{% /codetab %}}


{{% codetab %}}
- Make sure you have an [Azure account](https://azure.microsoft.com/en-us/free/search) and [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed on your machine.
- [rad CLI]({{< ref getting-started >}})

{{% /codetab %}}

{{% codetab %}}
- [rad CLI]({{< ref getting-started >}})
- Make sure you have an [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account) and an [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)
    - [Create an IAM AWS access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) and copy the AWS Access Key ID and the AWS Secret Access Key to a secure location for use later. If you have already created an Access Key pair, you can use that instead.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   - Configure your CLI with [`aws configure`](https://docs.aws.amazon.com/cli/latest/reference/configure/index.html), specifying your configuration values
- [eksctl CLI](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
{{% /codetab %}}
<!-- - **Test for AWS Container Registry or other public equivalent outside of Azure** (this is required for custom recipes) -->

{{< /tabs >}}


## Overview

[Recipes]() enable a separation of concerns between infrastructure teams and developers by automating infrastructure deployment.

Recipes are a collection of infrastructure resources that can be deployed as part of a Radius application. Currently Recipes can be written in [Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) and can be stored in [Azure Container Registries](https://azure.microsoft.com/en-us/products/container-registry/).

{{% alert title="📄 Deep Dive" color="primary" %}}
To learn more about Recipes as a developer concept visit the [Recipe developer guide]({{< ref recipes >}}).
{{% /alert %}}

## Application overview

<img src="recipe-quickstart-diagram.png" alt="Screenshot of the todoapp with Kubernetes, Azure and AWS Redis Cache options" style="width:100%" >

The **todoapp** contains

## Step 1 : Create a cluster 
{{< tabs Kubernetes Azure AWS >}}
{{% codetab %}}
Follow [Supported Kubernetes cluster]({{< ref kubernetes >}}) to create a Kubernetes cluster
{{% /codetab %}}

{{% codetab %}}

{{% /codetab %}}

{{% codetab %}}
Create an EKS cluster by using the `eksctl` CLI. This command will create a cluster in the `us-west-2` region, as well as a VPC and the Subnets, Security Groups, and IAM Roles required for the cluster.

```bash
eksctl create cluster --name my-cluster --region=us-west-2 --zones=us-west-2a,us-west-2b,us-west-2c
```

> Note: If you are using an existing cluster, you can skip this step. However, make sure that the each of the Subnets in your EKS cluster Subnet Group are within the [list of supported MemoryDB availability zones](https://docs.aws.amazon.com/memorydb/latest/devguide/subnetgroups.html). If your using your own custom subnets, supply them as part of the deployment file in Step 5.

{{% /codetab %}}

{{< /tabs >}}

## Step 2: Initialize Radius environmnet with Cloud providers
{{< tabs Kubernetes Azure AWS >}}
{{% codetab %}}
Navigate to the directory where you want to create your application and run the following command:

1. Use the `rad init` command to initialize a new environment:

   ```bash
   rad init
   ```

   Follow the prompts to install the [control plane services]({{< ref architecture >}}), create an [environment resource]({{< ref environments >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:
   * **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `azure`.
{{% /codetab %}}
{{% codetab %}}
Navigate to the directory where you want to create your application and run the following command:

1. Use the `rad init` command to initialize a new environment:

   ```bash
   rad init
   ```

   Follow the prompts to install the [control plane services]({{< ref architecture >}}), create an [environment resource]({{< ref environments >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:

   * **Azure provider** - An [Azure cloud provider]({{<ref providers>}}) allows you to deploy and manage Azure resources as part of your application. Enter 'y' and follow the instructions. Provide a valid Azure service principal with the proper permissions.
   * **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `azure`.
{{% /codetab %}}

{{% codetab %}}
Use the `rad init` command to initialize a new environment into your current kubectl context:

   ```bash
   rad init
   ```

   Follow the prompts to install the [control plane services]({{< ref architecture >}}), create an [environment resource]({{< ref environments >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:

   - **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `myawsenv`.
   - **Namespace** - When an application is deployed, this is the namespace where your containers and other Kubernetes resources will be run. By default, this will be in the `default` namespace.
   {{% alert title="💡 About namespaces" color="success" %}} When you initialize a Radius Kubernetes environment, Radius installs the control plane resources within    the `radius-system` namespace in your cluster, separate from your applications. The namespace specified in this step will be used for your application deployments.
   {{% /alert %}}
   -  **Add AWS Cloud provider** - An [AWS cloud provider]({{<ref providers>}}) allows you to deploy and manage AWS resources as part of your application. Select 'yes' to add cloud provider and select the cloud provider 'AWS'. Provide a valid AWS region and the values obtained for IAM Access Key ID and IAM Secret Access Keys.
   -  **Setup application in the current directory** - Select 'yes' if you want to have an app.bicep created 
{{% /codetab %}}
{{< /tabs >}}

## Step 3: Use `dev` recipes

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

`redis-aws` provisions a new MemoryDB in the same VPC as your EKS cluster. Deploying to the same VPC is the recommended way to access a MemoryDB cluster from your EKS cluster. It also optionally accepts `subnetIds` as a parameter, which can be supplied to use a different set of Subnet Ids.

`redis-kubernetes` provisions a new redis container 

 `redis-azure` provisions a new Azure cache for Redis 

 ## Step 4: Consume recipes in your application

1. Create a Bicep file `app.bicep` with the following content:

   {{< rad file="snippets/app.bicep" embed=true >}}

The code you just added references a container `demo` which is a container that runs the `radius.azurecr.io/tutorial/webapp` image, this image is published by the Radius team to a public registry, so you do not need to create it. It then creates a connection between `demo` and a database `db` which deploys a Recipe called `redis-kubernetes` which can be found inside your Radius environment thanks to community `dev` Recipes which are linked during a Radius environment initialization.

{{% alert title="📄 Deep Dive" color="primary" %}}

To learn more about app models in Radius visit the [application model concept page]({{< ref appmodel-concept >}}).

{{% /alert %}}

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

## Step 3: Custom Recipe deployment

Today, Recipes only support the Bicep IaC language. Your custom Recipe template will begin with a new Bicep file, which will contain all of the resources you want to automatically deploy for each resource that runs the Recipe.

{{% alert title="Deep Dive" color="primary" %}}
To learn more about Recipes as a concept from the infra team perspective visit the [administrator guide]({{< ref custom-recipes.md >}})
{{% /alert %}}

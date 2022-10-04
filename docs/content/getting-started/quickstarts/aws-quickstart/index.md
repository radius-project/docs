---
type: docs
title: "Quickstart: Deploy AWS resources"
linkTitle: "Deploy AWS resources"
description: "Learn about how to setup an AWS cloud provider and deploy an AWS MemoryDB for Redis with Radius"
weight: 500
slug: "aws"
---

This quickstart will teach you:
* How to create a Radius environment with an AWS cloud provider 
* How to model an AWS resource in bicep
* How to deploy and view the status of an AWS resource

## Prerequisites

- Make sure you have an [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/0) and an [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html')
    - [Create an IAM AWS access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) and copy the AWS Access Key ID and the AWS Secret Access Key to a secure location for use later. You could also use a pre-existing Access Key if you have already created one.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- A kubecontext pointing to a valid [EKS cluster]({{< ref kubernetes >}})


## Step 1: Create a Radius environment with the AWS cloud provider

Create the environment that you will be deploying your AWS resources to.

1. You can view the current context for kubectl by running:

   ```bash
   kubectl config current-context
   ```
   {{% alert color="success" %}} Make sure that your kubecontext is set to a running EKS cluster.
   {{% /alert %}}

1. Use the [`rad env init kubernetes` command]({{< ref rad_env_init_Kubernetes >}}) to initialize a new environment into your current kubectl context:

   ```bash
   rad env init kubernetes -i
   ```

   Follow the prompts to install the [control plane services]({{< ref architecture >}}), create an [environment resource]({{< ref environments >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:

   - **Namespace** - When an application is deployed, this is the namespace where your containers and other Kubernetes resources will be run. By default, this will be in the `default` namespace.
   {{% alert title="💡 About namespaces" color="success" %}} When you initialize a Radius Kubernetes environment, Radius installs the control plane resources within    the `radius-system` namespace in your cluster, separate from your applications. The namespace specified in this step will be used for your application deployments.
   {{% /alert %}}
   -  **Add AWS provider** - Enter 'y' and follow the instructions. Provide a valid AWS region and the values obtained for IAM Access Key ID and IAM Secret Access Keys.
   - **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `myawsenv`.

## Step 3: Create a bicep file with MemoryDB for Redis

This bicep file holds all of the information necessary to deploy a MemoryDB cluster to the same VPC as your EKS cluster. Deploying to the same VPC is the recommended way to access a MemoryDB cluster from your EKS cluster.

### aws-memorydb.bicep
{{< rad file="snippets/aws-memorydb.bicep" embed=true >}}

{{% alert color="success" %}} Make sure to set `eksClusterName` to the name of your EKS cluster.
{{% /alert %}}

## Step 4: Create a bicep file that uses MemoryDB

This bicep file deploys a publicly-accessible webapp which uses the MemoryDB we created in step 3 as a datastore.

### app.bicep
{{< rad file="snippets/app.bicep" embed=true >}}


## Step 5: Deploy the application

1. Deploy to your Radius environment via the rad CLI:

   ```sh
   rad deploy ./app.bicep
   ```

   This will deploy the application into your environment and launch the container resource for the frontend website. You should see the following resources deployed at the end of `rad deploy`:

   ```
   Deployment In Progress:

   Completed            http-route      Applications.Core/httpRoutes
   Completed            webapp          Applications.Core/applications
   Completed            memorydb-module Microsoft.Resources/deployments
   Completed            public          Applications.Core/gateways
   Completed            frontend        Applications.Core/containers
   Completed            db              Applications.Connector/redisCaches

   Deployment Complete 

   Resources:
      your-eks-cluster-name AWS.EKS/Cluster     
      demo-memorydb-cluster AWS.MemoryDB/Cluster
      demo-memorydb-subnet-group AWS.MemoryDB/SubnetGroup
      db              Applications.Connector/redisCaches
      webapp          Applications.Core/applications
      frontend        Applications.Core/containers
      public          Applications.Core/gateways
      http-route      Applications.Core/httpRoutes

   Public Endpoints:
      public          Applications.Core/gateways <PUBLIC_ENDPOINT>
   ```

1. Get the public endpoint address for the gateway:

   A public endpoint will also be available to your application from the [Gateway]({{< ref gateway >}}) resource. You can also use [`rad app status`]({{< ref rad_application_status >}}) to get the endpoint:
   ```bash
   rad app status -a webapp
   ```

1. To test your application, navigate to the public endpoint.

   You can play around with the application's features:

   - Add a todo item
   - Mark a todo item as complete
   - Delete a todo item

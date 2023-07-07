---
type: docs
title: "Quickstart: Deploy AWS resources"
linkTitle: "Deploy AWS resources"
description: "Learn about how to setup an AWS cloud provider and deploy an AWS MemoryDB for Redis with Radius"
weight: 500
categories: "Quickstart"
tags: ["AWS"]
---

This quickstart will teach you:
* How to create a Radius environment with an AWS cloud provider
* How to model an AWS resource in bicep
* How to use an AWS resource as part of your Radius application

## Prerequisites

- Make sure you have an [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account) and an [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)
    - [Create an IAM AWS access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) and copy the AWS Access Key ID and the AWS Secret Access Key to a secure location for use later. If you have already created an Access Key pair, you can use that instead.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   - Configure your CLI with [`aws configure`](https://docs.aws.amazon.com/cli/latest/reference/configure/index.html), specifying your configuration values
- [eksctl CLI](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

## Step 1: Create an EKS cluster

Create an EKS cluster by using the `eksctl` CLI. This command will create a cluster in the `us-west-2` region, as well as a VPC and the Subnets, Security Groups, and IAM Roles required for the cluster.

```bash
eksctl create cluster --name my-cluster --region=us-west-2 --zones=us-west-2a,us-west-2b,us-west-2c
```

> Note: If you are using an existing cluster, you can skip this step. However, make sure that the each of the Subnets in your EKS cluster Subnet Group are within the [list of supported MemoryDB availability zones](https://docs.aws.amazon.com/memorydb/latest/devguide/subnetgroups.html). If your cluster includes Subnets outside of a supported MemoryDB availability zone, or if using your own custom subnets, supply them as part of the deployment file in Step 5.

## Step 2: Create a Radius environment with the AWS cloud provider

Create a [Radius environment]({{< ref "operations/environments/overview" >}}) where you will deploy your application.

1. You can view the current context for kubectl by running:

   ```bash
   kubectl config current-context
   ```
   {{% alert color="success" %}} Make sure that your kubecontext is set to a running EKS cluster.
   {{% /alert %}}

1. Use the `rad init` command to initialize a new environment into your current kubectl context:

   ```bash
   rad init
   ```

   Follow the prompts to install Radius, create an [environment resource]({{< ref "operations/environments/overview" >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:

   - **Namespace** - When an application is deployed, this is the namespace where your containers and other Kubernetes resources will be run. By default, this will be in the `default` namespace.
   {{% alert title="💡 About namespaces" color="success" %}} When you initialize a Radius Kubernetes environment, Radius installs the control plane resources within    the `radius-system` namespace in your cluster, separate from your applications. The namespace specified in this step will be used for your application deployments.
   {{% /alert %}}
   -  **Add AWS provider** - An [AWS cloud provider]({{<ref providers>}}) allows you to deploy and manage AWS resources as part of your application. Enter 'y' and follow the instructions. Provide a valid AWS region and the values obtained for IAM Access Key ID and IAM Secret Access Keys.
   - **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `myawsenv`.

## Step 3: Create a bicep file with MemoryDB for Redis

This Bicep file defines a MemoryDB cluster, configuring it in the same VPC as your EKS cluster. Deploying to the same VPC is the recommended way to access a MemoryDB cluster from your EKS cluster. It also optionally accepts `subnetIds` as a parameter, which can be supplied to use a different set of Subnet Ids.

{{< tabs "New MemoryDB Resource" "Existing MemoryDB Resource" >}}

{{% codetab %}}
### aws-memorydb.bicep

{{< rad file="snippets/aws-memorydb.bicep" embed=true >}}

{{% /codetab %}}

{{% codetab %}}

Alternatively, if you have an existing MemoryDB resource that you would want to use instead:

### aws-memorydb-existing.bicep

{{< rad file="snippets/aws-memorydb-existing.bicep" embed=true >}}

{{% /codetab %}}

{{< /tabs >}}

## Step 4: Create an app.bicep that uses the MemoryDB

This Bicep file defines a webapp [container]({{< ref container >}}), which connects to the MemoryDB we created in Step 3 and uses it as a datastore.

{{< tabs "New MemoryDB Resource" "Existing MemoryDB Resource" >}}

{{% codetab %}}
### app.bicep

{{< rad file="snippets/app.bicep" embed=true >}}

{{% /codetab %}}

{{% codetab %}}

### app.bicep

{{< rad file="snippets/app-existing.bicep" embed=true >}}

{{% /codetab %}}

{{< /tabs >}}


## Step 5: Deploy the application

1. Deploy your application to your environment:

   {{< tabs "New MemoryDB Resource" "New Memory DB Resource with custom Subnets" "Existing MemoryDB Resource" >}}

   {{% codetab %}}

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

   {{% codetab %}}

   You can specify the Subnet IDs to use for the MemoryDB cluster by replacing the Subnet IDs in `aws-memorydb.bicep`:

   ### aws-memorydb.bicep

   ```bicep
   param subnetGroupName string = 'demo-memorydb-subnet-group'
   resource subnetGroup 'AWS.MemoryDB/SubnetGroup@default' = {
      alias: subnetGroupName
      properties: {
         SubnetGroupName: subnetGroupName
         // Update this line to include your subnets:
         SubnetIds: ['subnet-0a1b2c3d4e5f6g7h8', 'subnet-0a1b2c3d4e5f6g7h9']
      }
   }
   ```

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

   {{% codetab %}}

   ```bash
   rad deploy ./app.bicep
   ```

   This will deploy the application into your environment and launch the container resource for the frontend website. You should see the following resources deployed at the end of `rad deploy`:

   ```
   Deployment In Progress...

   Completed            memorydb-module Microsoft.Resources/deployments
   Completed            webapp          Applications.Core/applications
   Completed            demo-memorydb-cluster AWS.MemoryDB/Cluster
   Completed            db              Applications.Link/redisCaches
   Completed            frontend        Applications.Core/containers

   Deployment Complete

   Resources:
      demo-memorydb-cluster AWS.MemoryDB/Cluster
      db              Applications.Link/redisCaches
      webapp          Applications.Core/applications
      frontend        Applications.Core/containers
   ```

   {{% /codetab %}}

   {{< /tabs >}}

1. Port-forward the container to your machine with [`rad resource expose`]({{< ref rad_resource_expose >}}):

    ```bash
    rad resource expose containers frontend -a webapp --port 3000
    ```
1. Visit [localhost:3000](http://localhost:3000) in your browser. You should see a page like:

   <img src="todoapp-withdb.png" width="400" alt="screenshot of the todo application with an AWS MemoryDB database">

   If your page matches, then it means that the container is able to communicate with the AWS MemoryDB database.

   You can play around with the application's features:

   - Add a todo item
   - Mark a todo item as complete
   - Delete a todo item

## Cleanup

{{% alert title="Delete environment" color="warning" %}}
If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) to delete all Radius resources running on the EKS Cluster.
{{% /alert %}}

{{% alert title="Cleanup AWS Resources" color="warning" %}}
AWS resources are not deleted when deleting a Radius environment, so to prevent additional charges, make sure to delete all resources created in this quickstart. This includes the SubnetGroup and MemoryDB created in Step 3. You can delete these resources in the AWS Console or via the AWS CLI.
{{% /alert %}}

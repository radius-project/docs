---
type: docs
title: "Quickstart: Deploy AWS resources via Radius"
linkTitle: "Deploy AWS resources"
description: "Learn about how to setup an AWS cloud provider and deploy an AWS MemoryDB for Redis via Radius"
weight: 500
slug: "aws"
---

This quickstart will teach you
1. How to create a Radius environment with an AWS cloud provider 
1. How to model an AWS resource in bicep
1. How to deploy and view the status of the AWS resource

## Prerequisites

- Make sure you have an [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/0) and an [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html')
    - [Create an IAM AWS access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) and copy the AWS Access Key ID and the AWS Secret Access Key to a secure location for use later. You could also use a pre-existing Access Key if you have already created one.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Next, make sure you have a [supported Kubernetes cluster]({{< ref kubernetes >}}) deployed and setup with a kubectl context


## Step 1: Create a Radius environment with the AWS cloud provider

Create the environment that you will be deploying your AWS resources to.

1. You can view the current context for kubectl by running:

   ```bash
   kubectl config current-context
   ```
   {{% alert color="success" %}} Visit the [Kubernetes platform docs]({{< ref kubernetes >}}) for a list of supported clusters and specific cluster requirements.
   {{% /alert %}}

1. Use the [`rad env init kubernetes` command]({{< ref rad_env_init_Kubernetes >}}) to initialize a new environment into your current kubectl context:

   ```bash
   rad env init kubernetes -i
   ```

   Follow the prompts to install the [control plane services]({{< ref architecture >}}), create an [environment resource]({{< ref environments >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:

   - **Namespace** - When an application is deployed, this is the namespace where your containers and other Kubernetes resources will be run. By default, this will be in the `default` namespace.
   {{% alert title="💡 About namespaces" color="success" %}} When you initialize a Radius Kubernetes environment, Radius installs the control plane resources within    the `radius-system` namespace in your cluster, separate from your applications. The namespace specified in this step will be used for your application deployments.
   {{% /alert %}}
   -  **Add Azure provider** - Enter 'n'
   -  **Add AWS provider** - Enter 'y'and follow the instructions. Provide a valid AWS region and the values obtained for IAM Access Key ID and IAM Secret Access Keys.
   - **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `myawsenv`.

## Step 3: Create a bicep file with MemoryDB for Redis

{{< rad file="snippets/aws-memorydb.bicep" embed=true marker="//SAMPLE" >}}

Note that the resource `name` and the `clusterName` are required to match.

## Step 4: Deploy the Bicep file

Deploy the Bicep file created in step 3 by running [`rad deploy`]({{< ref rad_deploy >}}):

```bash
rad deploy .snippets/aws-memorydb.bicep
```

## Step 5: Verify that the MemoryDB for Redis cluster has been created.

Use the AWS CLI to verify that the cluster is deployed:

``` bash
aws memorydb describe-clusters
```
Alternatively, you could also use the [AWS Management Console](https://aws.amazon.com/console/) to verify the deployment of the cluster.

## Step 6: Cleanup

Delete the MemoryDB for Redis cluster that we deployed by running the command:
```bash
aws memorydb delete-cluster --cluster-name <your-cluster-name>
```
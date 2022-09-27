---
type: docs
title: "Quickstart: Deploy MemoryDB for Redis cluster to AWS"
linkTitle: "Deploy AWS MemoryDB for Redis"
description: "Learn about using Radius to deploy MemoryDB for Redis cluster to AWS" 
weight: 500
---

This quickstart will walk you through the process of using Radius to deploy a MemoryDB for Redis cluster to AWS.

## Prerequisites

- AWS account
- AWS CLI
- Kubernetes cluster (AKS, EKS, GKE, etc.)

## Step 1: Create AWS Access Key

First, [create an AWS access key](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/) and copy the AWS Access Key ID and the AWS Secret Access Key to a secure location for use later. You could also use a pre-existing Access Key if you have already created one.


## Step 2: Create an environment configured with the AWS cloud provider

Next, you will create the environment that you will be deploying your applications into.

1. Download your kubectl context:

   {{< tabs AKS >}}

   {{% codetab %}}
   Replace subscriptionName, resourceGroupName, and clusterName with your values:
   ```bash
   az aks get-credentials --subscription subscriptionName --resource-group resourceGroupName --name aksName
   ```
   {{% /codetab %}}

   {{< /tabs >}}

2. Install the Radius runtime and create a new environment:

    ```bash
   rad env init kubernetes -i
   ```

    Select the option to configure the AWS cloud provider, providing a valid AWS region and the values obtained in Step 1 for IAM Access Key ID and IAM Secret Access Keys.


## Step 3: Create a bicep file with MemoryDB for Redis

{{< rad file="snippets/aws-memorydb.bicep" embed=true marker="//SAMPLE" >}}

Here note that the bicep name and the clusterName specified in the bicep file should match.

## Step4: Deploy the bicep file

Deploy the bicep file created in step 3 by the running the command below.

```
rad deploy .snippets/aws-memorydb.bicep
```

## Step 5: Verify that the MemoryDB for Redis cluster has been created.

Use the AWS CLI command below to verify that the cluster is deployed.

```
aws memorydb describe-clusters
```

Alternatively, you could also use the [AWS Management Console](https://aws.amazon.com/console/) to verify the deployment of the cluster.

Done!

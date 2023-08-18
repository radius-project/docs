---
type: docs
title: "How-To: Setup Cloud providers"
linkTitle: "How-To: Setup providers"
description: "Deploy across clouds and platforms with Radius cloud providers"
weight: 200
categories: "How-To"
tags: ["AWS","Azure"]
---

When initializing a new Radius environment you can optionally configure a cloud provider for your environment

{{< tabs "Azure Provider" "AWS Provider" >}}

{{% codetab %}}

### Azure Provider

The Azure provider allows you to deploy and connect to Azure resources from a self-hosted Radius environment. 

#### Prerequisites

- [Azure subscription](https://azure.com)
- [az CLI](https://aka.ms/azcli)

#### Add a cloud provider when initializing an environment

1. Initialize a new [environment]({{< ref "deploy-apps/environments/overview" >}}) with `rad init`
1. Select the Kubernetes cluster to install Radius into. Enter an environment name and base Kubernetes namespace to deploy the apps into.
1. Select "yes" to add a cloud provider and select Azure as the cloud provider
1. Specify your Azure subscription and resource group
1. Create an [Azure service principal](https://docs.microsoft.com/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac) with the [proper permissions](https://aka.ms/azadsp-more). Enter the appID, password and the tenant of the service principal
1. Deploy your app and any included Azure resources with `rad deploy`

#### Add a cloud provider to an existing environment

1. Create an [Azure service principal](https://learn.microsoft.com/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac) with the [proper permissions](https://aka.ms/azadsp-more). 

   ```bash
   az ad sp create-for-rbac --role Owner --scope /subscriptions/<subscriptionid>/resourceGroups/<resourcegroupname> 
   ```
   Make sure to update the command with your subscription id and resource group name
   
1. Register the service principal in your control plane
   ```bash
   rad credential register azure --client-id <appId> --client-secret <password> --tenant-id <tenant id>
   ```
   
   Replace it with your service principal appId, password and tenant id

1. Update your environment with your Azure subscription and resource group. This is where Azure resources will be deployed.

   ```bash
   rad env update <myenv> --azure-subscription-id <subscriptionid> --azure-resource-group <resourcegroupname> 
   ```
1. Deploy your app and any included Azure resources with `rad deploy`


{{% /codetab %}}

{{% codetab %}}

### AWS Provider

The AWS provider allows you to deploy and connect to AWS resources from a Radius environment on an EKS cluster. 

#### Prerequisites
- [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account) and an [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

#### Add a cloud provider when initializing an environment

1. Initialize a new [environment]({{< ref "deploy-apps/environments/overview" >}}) with `rad init`
1. Select the Kubernetes cluster to install Radius into. Enter an environment name and base Kubernetes namespace to deploy the apps into.
1. Select "yes" to add a cloud provider and select AWS as the cloud provider

{{% /codetab %}}

{{< /tabs >}}
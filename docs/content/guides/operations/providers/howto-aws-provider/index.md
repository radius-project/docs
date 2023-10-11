---
type: docs
title: "How-To: Configure the AWS cloud provider"
linkTitle: "Configure AWS provider"
description: "Learn how to configure the AWS provider for your Radius Environment"
weight: 300
categories: "How-To"
tags: ["AWS"]
---

The AWS provider allows you to deploy and connect to AWS resources from a Radius Environment on an EKS cluster. It can be configured:
- [Interactively via `rad init`](#interactive-configuration)
- [Manually via `rad env update` and `rad credential register`](#manual-configuration)

## Prerequisites

- [EKS cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
- [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account) and an [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

## Interactive configuration

1. Initialize a new environment with [`rad init --full`]({{< ref rad_init >}}):
   ```bash
   rad init --full
   ```

1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Add an AWS provider** - Enter your IAM credentials and pick a region to deploy your AWS resources to
   - **Environment name** - The name of the environment to create

   You should see the following output:

      ```
      Initializing Radius...                     

      ✅ Install Radius {{< param version >}}               
         - Kubernetes cluster: k3d-k3s-default   
         - Kubernetes namespace: radius-system 
         - AWS IAM access key ID: ****  
      ✅ Create new environment default          
         - Kubernetes namespace: default 
         - AWS: account ***** and region: us-west-2        
      ✅ Scaffold application samples            
      ✅ Update local configuration              

      Initialization complete! Have a RAD time 😎
      ```

## Manual configuration

1. Update your Radius Environment with your AWS region and AWS account ID:
    ```bash
    rad env update myEnvironment --aws-region myAwsRegion --aws-account-id myAwsAccountId
    ```
    This command updates the configuration of an environment for properties that are able to be changed. For more information visit [`rad env update`]({{< ref rad_env_update >}})

2. Add your AWS cloud provider credentials:
    ```bash
    rad credential register aws --access-key-id myAccessKeyId --secret-access-key mySecretAccessKey
    ```
    For more information on the command arguments visit [`rad credential register aws`]({{< ref rad_credential_register_aws >}})
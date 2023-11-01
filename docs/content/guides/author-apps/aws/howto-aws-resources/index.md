---
type: docs
title: "How-To: Deploy AWS resources"
linkTitle: "Deploy AWS resources"
description: "Learn about how to add AWS resources to your application and deploy them with Radius"
categories: "How-To"
tags: ["AWS"]
weight: 200
---

This how-to guide will show you:

- How to model an AWS DynamoDB table in Bicep
- How to deploy an AWS resource in Radius

## Prerequisites

- Make sure you have an [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account) and an [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)
    - [Create an IAM AWS access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) and copy the AWS Access Key ID and the AWS Secret Access Key to a secure location for use later. If you have already created an Access Key pair, you can use that instead.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - Configure your CLI with [`aws configure`](https://docs.aws.amazon.com/cli/latest/reference/configure/index.html), specifying your configuration values
- [eksctl CLI](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/) 
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius Bicep VSCode extension]({{< ref "installation#step-2-install-the-radius-bicep-extension" >}})

## Step 1: Create an EKS Cluster

Create an EKS cluster by using the `eksctl` CLI. 

```bash
eksctl create cluster --name <my-cluster> --region=<my-region> 
```

## Step 2: Create a Radius Environment with the AWS cloud provider

Create a [Radius Environment]({{< ref "/guides/deploy-apps/environments/overview" >}}) where you will deploy your application.

Run [`rad init --full`]({{< ref rad_init >}}) to initialize a new environment into your current kubectl context:

```bash
rad init --full
```

Follow the prompts to install the [control plane services]({{< ref architecture-concept >}}), create an [environment resource]({{< ref "/guides/deploy-apps/environments" >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:

- **Namespace** - When an application is deployed, this is the namespace where your containers and other Kubernetes resources will be run. By default, this will be in the `default` namespace.
{{% alert title="💡 About namespaces" color="success" %}} When you initialize a Radius Kubernetes environment, Radius installs the control plane resources within    the `radius-system` namespace in your cluster, separate from your applications. The namespace specified in this step will be used for your application deployments.
{{% /alert %}}
- **Add AWS provider** - An [AWS cloud provider]({{< ref "/guides/operations/providers/howto-aws-provider" >}}) allows you to deploy and manage AWS resources as part of your application. Enter 'y' and follow the instructions. Provide a valid AWS region and the values obtained for IAM Access Key ID and IAM Secret Access Keys.
- **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `myawsenv`.

## Step 3: Create a Bicep file to model AWS DynamoDB table

Create a new file called `dynamodb.bicep` and add the following bicep code to model a DynamoDB table

{{< rad file="snippets/dynamodb.bicep" embed=true >}}

Radius uses the [AWS Cloud Control API](https://docs.aws.amazon.com/cloudcontrolapi/latest/userguide/what-is-cloudcontrolapi.html) to interact with AWS resources. This means that you can model your AWS resources in Bicep and Radius will be able to deploy and manage them. You can find the list of supported AWS resources in the [AWS resource library]({{< ref "guides/author-apps/aws/overview#resource-library" >}}).

## Step 5: Deploy the db to your environment

1. Deploy the db to your environment using the below command:

   ```bash
   rad deploy ./dynamodb.bicep
   ```
    This will deploy the AWS Dynamo DB table to your environment. 

    ```
    Building dynamodb.bicep...
    Deploying template 'dynamodb.bicep' into environment 'aws' from workspace 'default'...

    Deployment In Progress...

    .                    demotable       AWS.DynamoDB/GlobalTable

    Deployment Complete

    Resources:
        demotable       AWS.DynamoDB/GlobalTable
    ```

2. Verify that the AWS DynamoDB table has been created via AWS Console / CLI

## Step 6: Cleanup

1. When you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) to delete all Radius resources running on the EKS Cluster.

2. Cleanup AWS Resources - AWS resources are not deleted when deleting a Radius Environment, so make sure to delete all resources created in this reference app to prevent additional charges. You can delete these resources in the AWS Console or via the AWS CLI. 

   ```bash
   aws dynamodb delete-table --table-name demotable
   ```

## Further Reading

For further reference to examples of a sample Radius application that uses AWS resources, refer to the following tutorials:

1. [Deploy Recipes in your Radius Application]({{< ref "/tutorials/tutorial-recipe" >}})
2. [eShop on containers]({{< ref "/tutorials/eshop" >}})

## Troubleshooting

If you hit errors while deploying the application, please follow the steps below to troubleshoot:

1. Check if the AWS credentials are valid. Login to the AWS console and check if the IAM access key and secret access key are valid and not expired.

2. Look at the control plane logs to see if there are any errors. You can use the following command to view the logs:

     ```bash
     rad debug-logs
     ```
    Inspect the UCP logs to see if there are any errors  

If you have issues with the sample application, where the container doesn't connect with the S3 bucket, please follow the steps below to troubleshoot:

1. Use the below command to inspect logs from container:

    ```bash
    rad resource logs containers frontend -a <appname>
    ```
Also make sure to [open an Issue](https://github.com/radius-project/radius/issues/new/choose) if you encounter a generic `Internal server error` message or an error message that is not self-serviceable, so we can address the root error not being forwarded to the user.

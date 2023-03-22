---
type: docs
title: "Quickstart: Model and deploy AWS resources"
linkTitle: "Model and deploy AWS resources"
description: "Learn about how to model AWS S3 resources in Bicep and Radius"
weight: 400
categories: "AWS"
tags: "S3"
---

This reference app will show you:

* How to model an AWS S3 resource in Bicep
* How to use a sample application to interact with AWS S3

## Prerequisites
- Make sure you have an [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account) and an [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)
    - [Create an IAM AWS access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) and copy the AWS Access Key ID and the AWS Secret Access Key to a secure location for use later. If you have already created an Access Key pair, you can
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - Configure your CLI with [`aws configure`](https://docs.aws.amazon.com/cli/latest/reference/configure/index.html), specifying your configuration values
- [eksctl CLI](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/)  

## Step 1: Create an EKS Cluster
Create an EKS cluster by using the `eksctl` CLI. 

```bash
eksctl create cluster --name <my-cluster> --region=<my-region> 
```

## Step 2: Create a Radius environment with the AWS cloud provider

Create a [Radius environment]({{< ref environments >}}) where you will deploy your application.

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

   Follow the prompts to install the [control plane services]({{< ref architecture >}}), create an [environment resource]({{< ref environments >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:

   - **Namespace** - When an application is deployed, this is the namespace where your containers and other Kubernetes resources will be run. By default, this will be in the `default` namespace.
   {{% alert title="💡 About namespaces" color="success" %}} When you initialize a Radius Kubernetes environment, Radius installs the control plane resources within    the `radius-system` namespace in your cluster, separate from your applications. The namespace specified in this step will be used for your application deployments.
   {{% /alert %}}
   -  **Add AWS provider** - An [AWS cloud provider]({{<ref providers>}}) allows you to deploy and manage AWS resources as part of your application. Enter 'y' and follow the instructions. Provide a valid AWS region and the values obtained for IAM Access Key ID and IAM Secret Access Keys.
   - **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `myawsenv`.

## Step 3: Create a Bicep file which uses AWS Simple Storage Service (S3)

Create a new file called `app.bicep` and add the following bicep code:

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 4: Deploy the application

1. Deploy your application to your environment:

    ```bash
    rad deploy ./app.bicep -p aws_access_key_id=<AWS_ACCESS_KEY_ID> -p aws_secret_access_key=<AWS_SECRET_ACCESS_KEY> -p aws_region=<REGION> -p bucket=<BUCKET_NAME>
    ```

    The access key, secret key, and region can be the same values you used in while creating environment in step 2. These are used so the container we are deploying can connect to AWS. The AWS S3 Bucket name must follow the [following naming conventions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).

1. Port-forward the container to your machine with [`rad resource expose`]({{< ref rad_resource_expose >}}):

    ```bash
    rad resource expose containers frontend -a webapp --port 5234
    ```

1. Visit [localhost:5234](http://localhost:5234/swagger/index.html) in your browser. This is a swagger doc for the sample application. You can use this to interact with the AWS S3 Bucket you created. For example, you can try to upload a file to the bucket via the `/upload` endpoint.


## Step 5: Cleanup

1. If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) to delete all Radius resources running on the EKS Cluster.

2. Cleanup AWS Resources - AWS resources are not deleted when deleting a Radius environment, so to prevent additional charges, make sure to delete all resources created in this reference app. You can delete these resources in the AWS Console or via the AWS CLI. To delete the AWS S3 Bucket, see https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html.

## Next steps
{{< button text="Deploy using AWS recipes" page="quickstart-aws-recipes" >}}

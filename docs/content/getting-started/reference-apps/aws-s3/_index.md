---
type: docs
title: "Using AWS S3 with Radius"
linkTitle: "Using AWS S3"
description: "Learn about how to model AWS S3 resources in Bicep and Radius"
weight: 500
categories: "Reference-app"
tags: ["AWS"]
---

This reference app will show you:

* How to model AWS S3 resources in Bicep
* How to use a sample application to interact with AWS S3

## Prerequisites

- [Complete the getting started guide for AWS up to Step 2]({{< ref quickstart-aws >}})

## Step 1: Create a Bicep file which uses AWS Simple Storage Service (S3)

Create a new file called `app.bicep` and add the following bicep code:

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 2: Deploy the application

1. Deploy your application to your environment:

    ```bash
    rad deploy ./app.bicep -p aws_access_key_id=<AWS_ACCESS_KEY_ID> -p aws_secret_access_key=<AWS_SECRET_ACCESS_KEY> -p aws_region=<REGION> -p bucket=<BUCKET_NAME>
    ```

    The access key, secret key, and region can be the same values you used in the [AWS Quickstart]({{< ref quickstart-aws >}}). These are used so the container we are deploying can connect to AWS. The AWS S3 Bucket name must follow the [following naming conventions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).

1. Port-forward the container to your machine with [`rad resource expose`]({{< ref rad_resource_expose >}}):

    ```bash
    rad resource expose containers frontend -a webapp --port 5234
    ```

1. Visit [localhost:5234](http://localhost:5234/swagger/index.html) in your browser. This is a swagger doc for the sample application. You can use this to interact with the AWS S3 Bucket you created. For example, you can try to upload a file to the bucket via the `/upload` endpoint.


## Cleanup

{{% alert title="Delete environment" color="warning" %}}
If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) to delete all Radius resources running on the EKS Cluster.
{{% /alert %}}

{{% alert title="Cleanup AWS Resources" color="warning" %}}
AWS resources are not deleted when deleting a Radius environment, so to prevent additional charges, make sure to delete all resources created in this reference app. You can delete these resources in the AWS Console or via the AWS CLI. To delete the AWS S3 Bucket, see https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html.
{{% /alert %}}

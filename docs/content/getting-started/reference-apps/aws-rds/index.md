---
type: docs
title: "Deploy an AWS RDS-backed WordPress site"
linkTitle: "WordPress on AWS"
description: "Learn about how to use Radius to deploy a WordPress site that uses an AWS RDS database"
weight: 600
---

This reference app will show you:

* How to model and deploy containers in Radius
* How to model an AWS RDS resource in Bicep

## Prerequisites

- [Complete the getting started guide for AWS up to Step 2]({{< ref aws-quickstart >}})

## Step 1: Create a Bicep file which uses AWS RDS

This Bicep file defines:
* A `container` resource which serves the WordPress application.
* An RDS instance of a MySQL database, along with a subnet group resource. The setup here ensures that the RDS instance is deployed to the same subnet group and VPC as your EKS cluster, and additionally has the correct security group to enable communication between pods in the EKS cluster and the database.

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 2: Deploy the application

1. Deploy your application to your environment:

    ```bash
    rad deploy ./app.bicep -p eksClusterName=<YOUR_EXISTING_EKS_CLUSTER_NAME> -p subnetGroupName=<YOUR_SUBNET_GROUP_NAME> -p databaseIdentifier=<YOUR_DATABASE_NAME> -p databasePassword=<YOUR_DATABASE_PASSWORD>
    ```

1. Port-forward the container to your machine with [`rad resource expose`]({{< ref rad_resource_expose >}}):

    ```bash
    rad resource expose containers wordpress-container --application wordpress-app --port 8080 --remote-port 80
    ```

   Note: the `--remote-port` flag is set because the port exposed by the `wordpress` image is `80`.

1. Visit [localhost:8080](http://localhost:8080) in your browser. You can now create your site with WordPress.


## Cleanup

{{% alert title="Delete environment" color="warning" %}}
If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) to delete all Radius resources running on the EKS Cluster.
{{% /alert %}}

{{% alert title="Cleanup AWS Resources" color="warning" %}}
AWS resources are not deleted when deleting a Radius environment, so to prevent additional charges, make sure to delete all resources created in this reference app. You can delete these resources in the AWS Console or via the AWS CLI.

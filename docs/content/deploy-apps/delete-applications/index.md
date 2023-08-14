---
type: docs
title: "How-To: Delete an application from a Radius environment"
linkTitle: "Delete applications"
description: "Learn how to delete a Radius application"
weight: 300
categories: "How-To"
tags: ["delete"]
---

## Pre-requisites

A [deployed application]({{< ref deploy-apps >}}) in a Radius environment.

## How-to: Delete a  application

1. You can delete a Radius application from the environment using the [`rad app delete`]({{< ref rad_application_delete >}}) command.

    ```bash
    rad app delete app.bicep
    ```

    This will delete the following resources from the default Radius environment
    
    1. All the resources created by Radius on the Kubernetes cluster under the 'default-<appname>' namespace
    2. All the resources provisioned by Recipes
  
2. Delete any cloud/platform resources

    AWS, Azure, Kubernetes, and any other cloud/platform resources that were deployed alongside your Radius application and not as part of a Recipe or referenced as `existing` resource in your Radius application need to be deleted as a separate step.

    {{< tabs Azure AWS Kubernetes >}}

    {{% codetab %}}

    Azure resources can be deleted via the [Azure portal](https://portal.azure.com/) or the [Azure CLI](https://learn.microsoft.com/cli/azure/resource?view=azure-cli-latest#az-resource-delete)

    {{% /codetab %}}

    AWS resources can be deleted via the [AWS console](https://aws.amazon.com/console/) or the [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/cloudcontrol/delete-resource.html).

    {{% codetab %}}

    {{% /codetab %}}

    Kubernetes resources can be deleted via [kubectl delete](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#deleting-resources).
    
    {{% codetab %}}

 
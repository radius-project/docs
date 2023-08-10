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
  
    This will not delete the following resources from the default Radius environment
    
    1. Any resources already provisioned by the user outside of Radius (e.g. manually created resources)
    2. Any cloud/platform resources provisioned by Radius (e.g. Azure/AWS/Kubernetes resources)
    

2. Delete the Cloud/Platform resources

    To avoid incurring costs, please make sure to manually delete the cloud/platform resources provisioned by Radius.

    {{< tabs Azure AWS Kubernetes >}}

    {{% codetab %}}

    For Azure, delete the deployed Azure resources from the [Azure portal](https://portal.azure.com/) or the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/resource?view=azure-cli-latest#az-resource-delete)

    {{% /codetab %}}

    For AWS, delete the deployed AWS resources from the [AWS console](https://aws.amazon.com/console/) or the [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/cloudcontrol/delete-resource.html).

    {{% codetab %}}

    {{% /codetab %}}

    For Kubernetes, you can use the [kubectl delete](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#deleting-resources) to delete the platform Kubernetes resources.
    
    {{% codetab %}}
 
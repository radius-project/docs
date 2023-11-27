---
type: docs
title: "How-To: Delete an application from a Radius Environment"
linkTitle: "Delete apps"
description: "Learn how to delete a Radius Application"
weight: 400
categories: "How-To"
tags: ["delete"]
---

## Pre-requisites

- A [deployed application]({{< ref deploy-apps >}}) in a Radius Environment.

## Step 1: Delete the Radius Application from the environment 

You can delete the Radius Application using the [`rad app delete`]({{< ref rad_application_delete >}}) command:

```bash
rad app delete <appname>
```

This will delete the following resources from the Radius Environment
    
1. All the resources created by Radius on the Kubernetes cluster under the `<namespace-name>-<app-name>` namespace
1. All the resources provisioned by Recipes

## Step 2: Delete any cloud/platform resources

AWS, Azure, Kubernetes, and any other cloud/platform resources that were deployed alongside your Radius Application and not as part of a Recipe need to be deleted as a separate step.

{{< tabs Azure AWS Kubernetes >}}

{{% codetab %}}
Azure resources can be deleted via the [Azure portal](https://portal.azure.com/) or the [Azure CLI](https://learn.microsoft.com/cli/azure/resource?view=azure-cli-latest#az-resource-delete).
{{% /codetab %}}

{{% codetab %}}
 AWS resources can be deleted via the [AWS console](https://aws.amazon.com/console/) or the [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/cloudcontrol/delete-resource.html).
{{% /codetab %}}

{{% codetab %}}
Kubernetes resources can be deleted via [kubectl delete](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#deleting-resources).
{{% /codetab %}}

{{< /tabs >}}
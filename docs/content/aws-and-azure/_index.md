---
type: docs
title: "Configure AWS and Azure deployments"
linkTitle: "AWS and Azure"
description: "Configure credentials, Environments, and Recipe Packs to deploy application resources to AWS and Azure."
weight: 450
aliases:
  - /installation/cloud-providers/
  - /guides/installation/cloud-providers/
  - /guides/installation/cloud-providers/aws/
  - /guides/installation/cloud-providers/azure/
  - /guides/installation/providers/
  - /guides/installation/providers/overview/
---

Radius supports deploying application resources to Amazon Web Services (AWS) and Microsoft Azure. The default Recipe Pack deploys resources to Kubernetes. To use AWS or Azure cloud services, configure credentials, a target Environment, and recipes for those services.

The Radius control plane runs on a [supported Kubernetes cluster]({{< ref "/installation#supported-kubernetes-clusters" >}}), including Amazon EKS and Azure Kubernetes Service (AKS). Installing Radius on EKS or AKS does not, by itself, configure recipes to provision cloud services.

## Configure a cloud deployment

1. **Register cloud credentials.** Choose an identity from the table below and follow its [credential guide]({{< ref "/aws-and-azure/cloud-providers" >}}). The identity needs permission to provision the resources your recipes create.
2. **Configure the Environment.** Set the AWS account and region, or the Azure subscription and resource group, where resources will be deployed. See [Update an Environment]({{< ref "/management/environments#update-an-environment" >}}).
3. **Assign Recipe Packs.** Choose or author recipes for the target cloud, then assign their Recipe Packs to the Environment. See [Manage Recipe Packs]({{< ref "/management/recipe-packs" >}}). Each Resource Type the application uses needs a recipe, and the assigned packs must not define duplicate recipes for the same Resource Type.

With the Environment configured, [deploy the application to it]({{< ref "/management/environments#target-the-environment" >}}).

## Supported cloud providers and identities

| Provider | Identity | Description |
|----------|----------|-------------|
| AWS | [IAM access key]({{< ref "/aws-and-azure/cloud-providers/aws-access-key" >}}) | Deploy and connect to AWS resources using an IAM access key |
| | [IAM Roles for Service Accounts (IRSA)]({{< ref "/aws-and-azure/cloud-providers/aws-irsa" >}}) | Deploy and connect to AWS resources using AWS IRSA |
| Azure | [Service principal]({{< ref "/aws-and-azure/cloud-providers/azure-service-principal" >}}) | Deploy and connect to Azure resources using a service principal |
| | [Workload Identity]({{< ref "/aws-and-azure/cloud-providers/azure-workload-identity" >}}) | Deploy and connect to Azure resources using Workload Identity |

## Resource support and portability

The [community Recipe Packs]({{< ref "/management/recipe-packs#using-community-recipe-packs" >}}) provide implementations for AWS and Azure. Check the selected pack's resource mappings, recipe parameters, and prerequisites before deploying. AWS and Azure support does not mean that every Resource Type has a recipe for both clouds.

An application definition can be reused across clouds when each Environment provides recipes that implement the Resource Types and properties it uses. Cloud-specific resource definitions remain tied to their cloud. See [Deploying across AWS and Azure]({{< ref "/concepts#deploying-across-aws-and-azure" >}}) for an example.

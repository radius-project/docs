---
type: docs
title: "Overview: Microsoft Azure resources"
linkTitle: "Overview"
description: "Deploy and connect to Azure resources in your application"
weight: 100
categories: "Overview"
tags: ["Azure"]
---

Radius Applications are able to connect to and leverage every Azure resource with Bicep. Simply model your Azure resources in Bicep and add a connection from your Radius resources. Radius can deploy your application containers to both Azure Kubernetes Service (AKS) or Azure Container Instances (ACI).

## Configure an Azure Provider

The Azure provider allows you to deploy and connect to Azure resources from a Radius Environment on any of the [supported k8s clusters]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}}) or [Azure Container Instances (ACI)](TODO). To configure an Azure provider, you can follow the documentation [here]({{< ref "/guides/operations/providers/azure-provider" >}}).

## Set up an Azure compute environment

Radius allows you to target the deployment of your application containers to either Azure Kubernetes Service (AKS) or Azure Container Instances (ACI). The underlying compute platform is preconfigured in the Radius Environment, which means that you are able to deploy a Radius application to either AKS or ACI without needing to change the application definition. To learn more, visit the following resources: 
- The [Kubernetes operations guide](https://docs.radapp.io/guides/operations/kubernetes/overview/#supported-kubernetes-clusters) has more information about setting up Radius in an AKS cluster
- This [how-to guide](TODO) details how to configure a Radius Environment with ACI as the underlying compute platform and deploy a Radius application to ACI

## Resource library

Visit [the Microsoft docs](https://docs.microsoft.com/azure/templates/) to reference every Azure resource and how to represent it in Bicep.

{{< button text="Azure resource library" link="https://docs.microsoft.com/azure/templates/" newtab="true" >}}

## Example

{{< tabs Bicep >}}

{{% codetab %}}
In the following example, a [Container]({{< ref "guides/author-apps/containers" >}}) is connecting to an Azure Cache for Redis resource. The Container is assigned the `Redis Cache Contributor` role:

{{< rad file="snippets/azure-connection.bicep" embed=true >}}
{{% /codetab %}}

{{< /tabs >}}


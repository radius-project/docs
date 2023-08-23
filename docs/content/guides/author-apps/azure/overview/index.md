---
type: docs
title: "Microsoft Azure resources"
linkTitle: "Overview"
description: "Deploy and connect to Azure resources in your application"
weight: 500
categories: "Overview"
tags: ["Azure"]
---

Radius applications are able to connect to and leverage every Azure resource with Bicep. Simply model your Azure resources in Bicep and add a connection from your Radius resources.

## Configure an Azure Provider

The Azure provider allows you to deploy and connect to Azure resources from a Radius environment on any of the [supported clusters]({{< ref supported-clusters>}}). To configure an Azure provider, you can follow the documentation [here]({{< ref "/guides/operations/providers/howto-cloud-providers" >}}).

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


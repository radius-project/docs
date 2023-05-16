---
type: docs
title: "Microsoft Azure resources"
linkTitle: "Microsoft Azure"
description: "Deploy and connect to Azure resources in your application"
weight: 200
categories: "Concept"
tags: ["Azure"]
---

Radius applications are able to connect to and leverage every Azure resource with Bicep. Simply model your Azure resources in Bicep and add a connection from your Radius resources.

## Resource library

Visit [the Microsoft docs](https://docs.microsoft.com/azure/templates/) to reference every Azure resource and how to represent it in Bicep.

{{< button text="Azure resource library" link="https://docs.microsoft.com/azure/templates/" newtab="true" >}}

## Example

{{< tabs Bicep >}}

{{% codetab %}}
In the following example, a [Container]({{< ref container >}}) is connecting to an Azure Cache for Redis resource. The Container is assigned the `Redis Cache Contributor` role:

{{< rad file="snippets/azure-connection.bicep" embed=true >}}
{{% /codetab %}}

{{< /tabs >}}

---
type: docs
title: "Microsoft Azure resources"
linkTitle: "Microsoft Azure"
description: "Learn how to model and deploy Azure resources as part of your application"
weight: 500
---

Radius applications are able to connect to and leverage every Azure resource with Bicep. Simply model your Azure resources in Bicep and add a connection from your Radius resources.

## Resource library

Visit [the Microsoft docs](https://docs.microsoft.com/azure/templates/) to reference every Azure resource and how to represent it in Bicep.

{{< button text="Azure resource library" link="https://docs.microsoft.com/azure/templates/" >}}

## Example

{{< tabs Bicep >}}

{{% codetab %}}
In the following example, a [Container]({{< ref container >}}) is connecting to an Azure Cache for Redis resource. The Container is assigned the `Redis Cache Contributor` role:

{{< rad file="snippets/azure-connection.bicep" embed=true >}}
{{% /codetab %}}

{{< /tabs >}}

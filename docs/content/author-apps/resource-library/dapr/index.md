---
type: docs
title: "Dapr resources"
linkTitle: "Dapr"
description: "Learn how to model and deploy Dapr resources as part of your application"
weight: 600
---

Project Radius offers first-class support for the [Dapr](https://dapr.io) runtime and building blocks to make it easy to make your code fully portable across code and infrastructure.

## Dapr sidecar

A Dapr sidecar allows your services to interact with Dapr building blocks. It is required if your service connects to a Dapr building block resource.

<img src="dapr-sidecar.png" style="width:600px" alt="Diagram of the Dapr sidecar" /><br />

Easily add the Dapr sidecar to your [Containers]({{< ref container >}}) using a Dapr sidecar trait:

{{< tabs Bicep >}}

{{% codetab %}}
{{< rad file="snippets/sidecar.bicep" embed=true marker="//CONTAINER" >}}
{{% /codetab %}}

{{< /tabs >}}


## Dapr building blocks

Dapr connectors make it easy to model and configure [Dapr building blocks](https://docs.dapr.io/developing-applications/building-blocks/) as resources. Simply specify the building block and the backing resource, and Radius will automatically configure and apply the accompanying Dapr configuration.

<img src="dapr-buildingblocks.png" style="width:1000px" alt="Diagram of all the Dapr building blocks" /><br />

Model your building blocks as resources:

{{< tabs Bicep >}}

{{% codetab %}}
{{< rad file="snippets/statestore.bicep" embed=true marker="//CONTAINER" >}}
{{% /codetab %}}

{{< /tabs >}}

## Resource schema

Refer to the [connector reference docs]({{< ref connector-schema >}}) for more information on how to model Dapr resources via Radius connectors.

---
type: docs
title: "Overview: Kubernetes resources"
linkTitle: "Overview"
description: "Deploy and connect to Kubernetes resources in your application"
weight: 100
categories: "Overview"
tags: ["Kubernetes"]
---

Radius applications are able to connect to and leverage Kubernetes resources.

## Resource library

Visit [GitHub](https://github.com/Azure/bicep-types-k8s/blob/main/generated/index.md) to reference the Kubernetes resource.

{{< button text="Kubernetes resource library" link="https://github.com/Azure/bicep-types-k8s/blob/main/generated/index.md" newtab="true" >}}

## Example

{{< tabs Bicep >}}

{{% codetab %}}
{{< rad file="snippets/kubernetes-connection.bicep" embed=true >}}
{{% /codetab %}}

{{< /tabs >}}

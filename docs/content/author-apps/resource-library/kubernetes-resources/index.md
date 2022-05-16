---
type: docs
title: "Kubernetes resources"
linkTitle: "Kubernetes"
description: "Learn how to model and deploy Kubernetes resources as part of your application"
weight: 400
---

Radius applications are able to connect to and leverage Kubernetes resources.

## Resource library

Visit [GitHub](https://github.com/Azure/bicep-types-k8s/blob/main/generated/index.md) to reference the Kubernetes resource.

{{< button text="Kubernetes resource library" link="https://github.com/Azure/bicep-types-k8s/blob/main/generated/index.md" >}}

## Example

{{< tabs Bicep >}}

{{% codetab %}}
{{< rad file="snippets/kubernetes-connection.bicep" embed=true >}}
{{% /codetab %}}

{{< /tabs >}}

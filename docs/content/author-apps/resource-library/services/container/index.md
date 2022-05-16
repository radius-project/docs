---
type: docs
title: "Radius Container"
linkTitle: "Container"
description: "Learn how to model and run container workloads in your Radius application"
weight: 100
---

A Radius container represents a container workload within your application.

## Example

{{< tabs Bicep >}}

{{% codetab %}}
See the [Bicep authoring guide]({{< ref bicep >}}) for more information.
{{< rad file="snippets/container.bicep" embed=true marker="//CONTAINER" >}}
{{% /codetab %}}

{{< /tabs >}}

## Platform resources

Depending on the target environment and configuration, a container can be run on a variety of container runtimes:

| Platform | Container runtime |
|----------|-------------------|
| [Local dev]({{< ref dev-environments >}}) | k3d Kubernetes cluster |
| [Kubernetes]({{< ref kubernetes-environments >}}) | Local Kubernetes cluster |
| [Microsoft Azure]({{< ref azure-environments >}}) | AKS cluster |

## More information

- [Container schema]({{< ref container-schema >}})

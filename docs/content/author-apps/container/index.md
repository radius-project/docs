---
type: docs
title: "Containerized workloads"
linkTitle: "Containers"
description: "Model and run container workloads in your Radius application"
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

Depending on the target environment and configuration, a container can be run on a variety of platforms leveraging Kubernetes as the container runtime. 

## More information

- [Container schema]({{< ref container-schema >}})

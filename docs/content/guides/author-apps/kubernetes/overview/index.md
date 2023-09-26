---
type: docs
title: "Kubernetes resources"
linkTitle: "Overview"
description: "Deploy and connect to Kubernetes resources in your application"
weight: 1000
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

## Customize Kubernetes configurations

Radius provides a way to apply custom Kubernetes configurations to container resources that are created by Radius. This allows you to make use of Kubernetes configurations or features that are not supported by Radius, yet remain composable with other Radius features like [Connections]({{< ref "guides/author-apps/containers/overview#connections" >}}). Additionally, it provides a way to migrate your existing Kubernetes applications into Radius without having to rewrite your Kubernetes configurations, while giving you the option to incrementally adopt Radius features over time. The customizations are applied to the container resource via the [`runtimes`]({{< ref "reference/resource-schema/core-schema/container-schema/_index.md#runtimes" >}}) property within the container resource definition.

### Base Kubernetes YAML

You can provide a Kubernetes YAML definition as a base or foundation upon which Radius will build your containers, enabling you to start with your existing YAML definition and use Radius to apply customizations on top. The provided YAML is fully passed through to Kubernetes when Radius creates the container resource, which means that you may provide a definition for a CRD that Radius has no visibility into. 

Radius currently supports the following Kubernetes resource types for the `base` property: 

| Kubernetes Resource Types | number of resources | limitation |
|----|----|----|
| Deployment | 1 | Deployment name must match the name of radius container in the app-scoped namespace | 
| ServiceAccount | 1 | ServiceAccount name must match the name of radius container  in the app-scoped namespace| 
| Service | 1 | ServiceAccount name must match the name of radius container in the app-scoped namespace |
| Secrets | multiple | no limitation except in the app-scoped namespace |
| ConfigMap | multiple config maps | no limitation except in the app-scoped namespace |

### Pod patching

You can also "patch" the Kubernetes containers created and deployed by Radius using [PodSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec) definitions. This allows for setting Kubernetes-specific configurations, as well as overriding Radius behaviors, which means that you may access all Kubernetes Pod features, even if they are not supported by Radius.

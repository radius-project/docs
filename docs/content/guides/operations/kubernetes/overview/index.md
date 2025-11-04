---
type: docs
title: "Overview: Radius on Kubernetes platform"
linkTitle: "Overview"
description: "Learn how Radius can run on Kubernetes"
weight: 100
categories: ["Overview"]
tags: ["Kubernetes"]
---

Radius offers a Kubernetes-based platform for hosting the [Radius control plane]({{< ref "/guides/operations/control-plane" >}}) and [Radius Environments]({{< ref "concepts/environments" >}}).

{{< image src="kubernetes-mapping.png" alt="Diagram showing Radius resources being mapped to Kubernetes objects" width=600px >}}

## Supported Kubernetes versions

Kubernetes version `1.23.8` or higher is recommended to run Radius.

## Resource mapping

Radius resources, when deployed to a Kubernetes environment, are mapped to one or more Kubernetes objects. The following table describes the mapping between Radius resources and Kubernetes objects:

| Radius resource/configuration | Kubernetes object |
|----------------------------------|-------------------|
| [`Applications.Core/containers`]({{< ref container-schema >}}) | `apps/Deployment@v1`<br /> <br /> `core/Service@v1` _(if ports defined)_ |
| `Applications.Core/containers` connections | `core/Secret@v1` <br /> Mounted to the container as environment variables. Refer to the [connections guide]({{< ref howto-connect-dependencies >}}) to learn more. |
| [`Applications.Core/gateways`]({{< ref gateway >}})     | `projectcontour.io/HTTPProxy@v1` |
| [`Applications.Dapr/pubSubBrokers`]({{< ref dapr-pubsub >}}) | `dapr.io/Component@v1alpha1` |
| [`Applications.Dapr/secretStores`]({{< ref dapr-secretstore >}}) | `dapr.io/Component@v1alpha1` |
| [`Applications.Dapr/stateStores`]({{< ref dapr-statestore >}}) | `dapr.io/Component@v1alpha1` |

### Namespace mapping

Application-scoped resources are by default generated in a new Kubernetes namespace with the name format `'<envNamespace>-<appname>'`. This prevents multiple applications with resources of the same name from conflicting with each other.

For example, let's take an application named `'myapp'` with a container named `'frontend'`. This application is deployed into an environment configured with the `'default'` namespace. A Kubernetes Deployment named `'frontend'` is now deployed into the namespace `'default-myapp'`.

If you wish to override the default behavior and specify your own namespace for application resources to be generated into, you can leverage the [`kubernetesNamespace` application extension]({{< ref "application-schema#kubernetesNamespace" >}}). All application-scoped resources will now be deployed into this namespace instead.

### Resource naming

Resources that are generated in Kubernetes use the same name as the resource in Radius. For example, a Radius container named 'frontend' will map to a Kubernetes Deployment named `'frontend'`. This makes it easy to conceptually map between Radius and Kubernetes resources.

For multiple Radius resources that map to a single Kubernetes resource (_e.g. daprPubSubBrokers, daprSecretStores, and daprStateStores all map to a dapr.io/Component_) and there are collisions in naming, Radius has conflict logic to allow the first resource to be deployed but will throw a warning for subsequent resource deployments that have the same name. This prevents Radius resources from unintentionally overwriting the same generated resource.

## Kubernetes metadata

Radius Environments, applications, and resources can be annotated/labeled with Kubernetes metadata. Refer to the Kubernetes metadata page for more information:

{{< button text="Kubernetes metadata" page="kubernetes-metadata" >}}



## Configure container registry access

If you choose a private container registry you will need to take steps to configure your Kubernetes cluster to allow access. Follow the instructions provided by your cloud provider.

{{< tabs "Generic" "AKS + ACR" >}}

{{% codetab %}}
Visit the [Kubernetes docs](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) to learn how to configure your cluster to access a private registry, such as Docker Hub.
{{% /codetab %}}

{{% codetab %}}
Visit the [Azure docs](https://docs.microsoft.com/azure/aks/cluster-container-registry-integration?tabs=azure-cli)to learn how to configure access to an ACR registry.

```bash
az aks update --name myAKSCluster --resource-group myResourceGroup --subscription mySubscription --attach-acr <acr-name>
```

{{% /codetab %}}

{{< /tabs >}}

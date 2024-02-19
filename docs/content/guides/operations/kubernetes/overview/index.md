---
type: docs
title: "Overview: Radius on Kubernetes platform"
linkTitle: "Overview"
description: "Learn how Radius can run on Kubernetes"
weight: 100
categories: ["Overview"]
tags: ["Kubernetes"]
---

Radius offers a Kubernetes-based platform for hosting the [Radius control plane]({{< ref "/guides/operations/control-plane" >}}) and [Radius Environments]({{< ref "/guides/deploy-apps/environments/overview" >}}).

{{< image src="kubernetes-mapping.png" alt="Diagram showing Radius resources being mapped to Kubernetes objects" width=600px >}}

## Supported Kubernetes versions

Kubernetes version `1.23.8` or higher is recommended to run Radius.

## Resource mapping

Radius resources, when deployed to a Kubernetes environment, are mapped to one or more Kubernetes objects. The following table describes the mapping between Radius resources and Kubernetes objects:

| Radius resource                  | Kubernetes object |
|----------------------------------|-------------------|
| [`Applications.Core/containers`]({{< ref container-schema >}}) | `apps/Deployment@v1`<br /> <br /> `core/Service@v1` _(if ports defined)_ <br /> <br /> The `connections` property allows users to declare a connection between two resources, which Radius uses to inject resource related information into environment variables. This information is stored in a Kubernetes secret object if it is automatically-configured data and a non-secret Kubernetes object if its manually configured data. They are then used to access the respective resource information without having to hard code URIs, connection strings, access keys, or anything that an application code needs to successfully communicate. |
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

## Supported Kubernetes clusters

The following clusters have been tested and validated to ensure they support all of the features of Radius:

{{< tabs AKS k3d kind EKS >}}

{{% codetab %}}
Azure Kubernetes Service (AKS) clusters are the easiest way to get up and running quickly with a Radius Environment. To learn how to setup a cluster visit the [Azure docs](https://docs.microsoft.com/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli).

Note that [AKS-managed AAD](https://docs.microsoft.com/en-us/azure/aks/managed-aad) is not supported currently.

To create a new AKS cluster and retrieve its kubecontext, you can run the following commands:

```bash
az aks create --subscription mySubscription --resource-group myResourceGroup --name myAKSCluster --node-count 1
az aks get-credentials --subscription mySubscription --resource-group myResourceGroup --name myAKSCluster
```

Once deployed and your kubectl context has been set as your default, you can run the following to create a Radius Environment and install the control plane:

```bash
rad init
```
{{% /codetab %}}

{{% codetab %}}
[k3d](https://k3d.io) is a lightweight wrapper to run [k3s](https://github.com/rancher/k3s) (Rancher Lab’s minimal Kubernetes distribution) in Docker. 

First, ensure that memory resource is 8GB or more in `Resource` setting of `Preferences` if you're using Docker Desktop. Also make sure you've enabled Rosetta if you're running on an Apple M1 chip:

```bash
softwareupdate --install-rosetta --agree-to-license
```

Next, use the following commands to create a new cluster and install the Radius control plane, along with a new environment:

```bash
k3d cluster create -p "8081:80@loadbalancer" --k3s-arg "--disable=traefik@server:0"
rad install kubernetes --set rp.publicEndpointOverride=localhost:8081
rad init
```
{{% /codetab %}}

{{% codetab %}}
[Kind](https://kind.sigs.k8s.io/) is a tool for running local Kubernetes clusters inside Docker containers. Use the following setup to create a new cluster and install the Radius control plane, along with a new environment:

First, ensure that memory resource is 8GB or more in `Resource` setting of `Preferences` if you're using Docker Desktop. Also make sure you've enabled Rosetta if you're running on an Apple M1 chip:

```bash
softwareupdate --install-rosetta --agree-to-license
```

Second, copy the text below into a new file `kind-config.yaml`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
  extraPortMappings:
  - containerPort: 80
    hostPort: 8080
    listenAddress: "0.0.0.0"  
  - containerPort: 443
    hostPort: 8443
    listenAddress: "0.0.0.0"
```

Then, create a kind cluster with this config and initialize your Radius Environment:
```bash
# Create the kind cluster
kind create cluster --config kind-config.yaml

# Verify that the nodes are ready
# (You should see 2 nodes listed with status Ready)
kubectl get nodes

# Install Radius
rad install kubernetes --set rp.publicEndpointOverride=localhost:8080
rad init
```
{{% /codetab %}}

{{% codetab %}}
Amazon Elastic Kubernetes Service (Amazon EKS) is a managed service that you can use to run Kubernetes on AWS. Learn how to set up an EKS cluster on the [AWS docs](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html).

```bash
eksctl create cluster --name my-cluster --region region-code
```

Once deployed and your kubectl context has been set as your default, you can run the following to create a Radius Environment and install the control plane:

```bash
rad init
```

{{% /codetab %}}

{{< /tabs >}}

## Configure container registry access

If you choose a private container registry you will need to take steps to configure your Kubernetes cluster to allow access. Follow the instructions provided by your cloud provider.

{{< tabs "Generic" "AKS + ACR" >}}

{{% codetab %}}
Visit the [Kubernetes docs](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) to learn how to configure your cluster to access a private registry, such as Docker Hub.
{{% /codetab %}}

{{% codetab %}}
Visit the [Azure docs](https://docs.microsoft.com/azure/aks/cluster-container-registry-integration?tabs=azure-cli)to learn how to configure access to an ACR registry.

```bash
az aks update --name myAKSCluster -resource-group myResourceGroup --subscription mySubscription --attach-acr <acr-name>
```

{{% /codetab %}}

{{< /tabs >}}

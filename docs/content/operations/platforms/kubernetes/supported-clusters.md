---
type: docs
title: "Supported Kubernetes clusters"
linkTitle: "Supported clusters"
description: "Learn how to setup Radius on supported Kubernetes clusters"
weight: 100
---

## Minimum version

Kubernetes version `1.23.8` or higher is recommended to run Project Radius.

## Supported clusters

The following clusters have been tested and validated to ensure they support all of the features of Project Radius:

{{< tabs AKS k3d kind EKS >}}

{{% codetab %}}
Azure Kubernetes Service (AKS) clusters are the easiest way to get up and running quickly with a Radius environment. To learn how to setup a cluster visit the [Azure docs](https://docs.microsoft.com/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli).

Note that [AKS-managed AAD](https://docs.microsoft.com/en-us/azure/aks/managed-aad) is not supported currently.

To create a new AKS cluster and retrieve its kubecontext, you can run the following commands:

```bash
az aks create --subscription mySubscription --resource-group myResourceGroup --name myAKSCluster --node-count 1
az aks get-credentials --subscription mySubscription --resource-group myResourceGroup --name myAKSCluster
```

Once deployed and your kubectl context has been set as your default, you can run the following to create a Radius environment and install the control plane:

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

Then, create a kind cluster with this config and initialize your Radius environment:
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

Once deployed and your kubectl context has been set as your default, you can run the following to create a Radius environment and install the control plane:

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

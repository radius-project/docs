---
type: docs
title: "Kubernetes platform"
linkTitle: "Kubernetes"
description: "Learn how Project Radius can run on Kubernetes"
weight: 10
---

Project Radius can be installed and run on top of Kubernetes clusters. This allows you to deploy and manage Radius applications across any cloud or on-premises cluster.

## Supported clusters

The following clusters have been tested and validated to ensure they support all of the features of Project Radius:

{{< tabs AKS k3d >}}

{{% codetab %}}
Azure Kubernetes Service (AKS) clusters are the easiest way to get up and running quickly with a Radius environment. To learn how to setup a cluster visit the [Azure docs](https://docs.microsoft.com/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli).

Note that [AKS-managed AAD](https://docs.microsoft.com/en-us/azure/aks/managed-aad) is not supported currently.

Once deployed and your kubectl context has been set as your default, you can run the following to configure the Radius control plane:

```bash
az aks create --subscription mySubscription --resource-group myResourceGroup --name myAKSCluster --node-count 1
az aks get-credentials --subscription mySubscription --resource-group myResourceGroup --name myAKSCluster
rad env init kubernetes -i
```
{{% /codetab %}}

{{% codetab %}}
[k3d](https://k3d.io) is a lightweight wrapper to run [k3s](https://github.com/rancher/k3s) (Rancher Lab’s minimal Kubernetes distribution) in Docker. Use the following commands to create a new cluster and install the Radius control plane, along with a new environment:

```bash
k3d cluster create -p '8081:80@loadbalancer' --k3s-arg '--disable=traefik@server:0'
rad env init kubernetes -i --public-endpoint-override 'http://localhost:8081'
```
{{% /codetab %}}

{{< /tabs >}}

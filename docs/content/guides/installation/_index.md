---
type: docs
title: "Installation Guide"
linkTitle: "Installation"
description: "Learn how to install and manage Radius"
weight: 100
---

Installing Radius includes installing the Radius command-line interface (CLI), installing the Radius control plane on Kubernetes, and configuring credentials for Radius to access your AWS account, Azure subscription, and Git repository or OCI registry for your Recipes.

## Installation checklist

### Required steps

- Install the Radius CLI (`rad`) and Bicep CLI (`rad-bicep`)
- Install the Radius control plane on a Kubernetes cluster
- Configure Radius Resource Groups and Environments

### Additional optional steps

- Configure AWS and/or Azure credentials in Radius
- Configure a Git repository or OCI registry to store Recipes
- Customize Radius Resource Types
- Distribute Bicep extensions for Radius Resource Types
- Expose access to the Radius Dashboard
- Configure Kubernetes ingress 

## Installation Requirements

### Kubernetes requirements

Building on the [technical architecture overview]({{< ref "concepts/#technical-architecture" >}}), Radius runs on Kubernetes and exposes its Universal Control Plane (UCP) through the Kubernetes API aggregation layer. Hence, installing Radius requires **cluster-admin permissions**, so it can register CRDs, namespaces, and RBAC objects.

{{< tabs AKS EKS k3d kind>}}
{{% codetab %}}

Visit the [Azure docs](https://docs.microsoft.com/azure/aks/learn/quick-kubernetes-deploy-portal?tabs=azure-cli) to set up an AKS cluster.

{{% /codetab %}}
{{% codetab %}}

Visit [AWS docs](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html) to set up an EKS cluster. 
{{% /codetab %}}
{{% codetab %}}

[k3d](https://k3d.io) is a lightweight wrapper to run [k3s](https://github.com/rancher/k3s) (Rancher Lab’s minimal Kubernetes distribution) in Docker. 

First, ensure that memory resource is 8GB or more in `Resource` setting of `Preferences` if you're using Docker Desktop. Also make sure you've enabled Rosetta if you're running on an Apple M1 chip:

Use the following command to create a new cluster and install the Radius control plane 

```bash
k3d cluster create -p "8081:80@loadbalancer" --k3s-arg "--disable=traefik@server:*" --k3s-arg "--disable=servicelb@server:*"
```

- The first parameter adds a port mapping which routes traffic from the local machine into the cluster. 
- The second parameter disables [`traefik`](https://k3d.io/v5.1.0/usage/k3s/#traefik) pods because Radius provides an ingress controller.
- The third parameter disables the [k3d internal load balancer](https://k3d.io/v5.1.0/usage/k3s/#servicelb-klipper-lb).

Next install the Radius control plane with an override of the default public endpoint:

```bash
rad install kubernetes --set rp.publicEndpointOverride=localhost:8081
```
{{% /codetab %}}
{{% codetab %}}

[Kind](https://kind.sigs.k8s.io/) is a tool for running local Kubernetes clusters inside Docker containers. Use the following setup to create a new cluster and install the Radius control plane, along with a new environment:

First, ensure that memory resource is 8GB or more in `Resource` setting of `Preferences` if you're using Docker Desktop. Also make sure you've enabled Rosetta if you're running on an Apple M1 chip:

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
```

{{% /codetab %}}
{{< /tabs >}}

#### Other tooling requirements

- `kubectl` to troubleshoot installations. Radius CLI uses the active kubeconfig context.

- If you plan to install directly with Helm, use Helm 3 or later.

- Install [Node.js](https://nodejs.org/) to generate or publish Bicep extensions.

- Ensure you can authenticate to your registries (`docker login`/`az acr login`) from any workstation or CI runner that will push Recipes, Bicep extensions, or mirrored control-plane images if working off a private network.

Use the following how-to guides to install, upgrade, and maintain Radius.

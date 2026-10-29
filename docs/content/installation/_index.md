---
type: docs
title: "How to Install Radius"
linkTitle: "Install Radius"
description: "Learn how to install Radius on Kubernetes, configure cloud providers, and set up developer workstations"
weight: 400
aliases:
  - /guides/installation/
---

Radius runs as a control plane on a Kubernetes cluster with a command-line interface for performing Radius commands. This guide covers how to install and configure each component required to run Radius. This includes:

- How to install the [Radius CLI]({{< ref "/installation/cli" >}}) on your workstation.
- How to install the [Radius control plane]({{< ref "/installation/control-plane" >}}) on a Kubernetes cluster.
- How to configure [cloud providers]({{< ref "/installation/cloud-providers" >}}) to deploy to AWS and Azure.
- How to set up a [developer workstation]({{< ref "/installation/dev-workstation" >}}) to use Radius.
- How to configure access to the [Radius Dashboard]({{< ref "/installation/dashboard/" >}}).

## System requirements

To install and run the Radius control plane you need:

- A Kubernetes cluster running a currently supported version. Radius tracks the upstream Kubernetes [version support policy](https://kubernetes.io/releases/version-skew-policy/#supported-versions), which maintains the three most recent minor releases.
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) installed and configured with a context pointing to your target cluster.
- Cluster-administrator (`cluster-admin`) access to the cluster. Radius installs CRDs, namespaces, RBAC resources, and an [aggregated API server](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/apiserver-aggregation/), all of which require cluster-wide privileges.
- Outbound network access from the cluster to pull the Radius container images and Helm chart from `ghcr.io`.
- For local clusters (kind or k3d): a container runtime such as Docker Desktop with at least 8 GB of memory allocated.

### Supported Kubernetes clusters

Radius is tested and validated against the following Kubernetes distributions:

- [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/azure/aks/)
- [Amazon Elastic Kubernetes Service (Amazon EKS)](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [k3d](https://k3d.io)
- [kind](https://kind.sigs.k8s.io/)

### Prepare a k3d cluster

Use a recent k3d release with a Kubernetes version that meets the [system requirements](#system-requirements). Disable the bundled Traefik ingress controller because `rad install kubernetes` and `rad initialize` install Contour by default. Running both controllers can cause port conflicts and Gateway API CRD ownership errors.

Create a new cluster with Traefik disabled and an HTTP port mapping:

```bash
k3d cluster create radius \
  -p "127.0.0.1:18081:80@loadbalancer" \
  --k3s-arg "--disable=traefik@server:*"
```

The port mapping forwards traffic from `localhost:18081` to port 80 on the cluster nodes. Replace `18081` with another available local port if needed. Binding to `127.0.0.1` limits access to your workstation.

Leave the bundled k3s service load balancer (`servicelb`) enabled: it exposes Contour's Envoy proxy on the nodes so the port mapping can reach it. Do not add `--disable=servicelb`. Older Radius instructions disabled it because the previous Contour chart exposed Envoy directly through host ports; the current chart uses a Kubernetes `LoadBalancer` Service instead.

If an existing cluster runs Traefik, create a separate cluster with the options above before installing Radius. Creating a new cluster does not migrate workloads from the existing cluster. To use your own gateway controller instead of Contour, see [Use a different gateway controller]({{< ref "/integrations/routes#use-a-different-gateway-controller" >}}).

After creating the cluster, [install the Radius CLI]({{< ref "/installation/cli" >}}), then [install the Radius control plane]({{< ref "/installation/control-plane" >}}). Once you have [deployed an HTTP route]({{< ref "/integrations/routes#deploy-and-access-the-application" >}}), access it through the mapped port using the hostname configured on that route:

```bash
curl -H "Host: frontend.example.com" http://localhost:18081/
```

Replace `frontend.example.com` with your route's hostname. The port mapping alone does not create an application route, and a request without a matching hostname returns HTTP 404.

## Organization

This guide is organized into a separate page for each component you install and configure: the Radius CLI, the control plane, cloud providers, a developer workstation, and the Dashboard. Start with the Radius CLI, then continue through the remaining pages in order.

{{< button text="Next step: How to install the Radius CLI" page="installation/cli" >}}

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

## Organization

This guide is organized into a separate page for each component you install and configure: the Radius CLI, the control plane, cloud providers, a developer workstation, and the Dashboard. Start with the Radius CLI, then continue through the remaining pages in order.

{{< button text="Next step: How to install the Radius CLI" page="installation/cli" >}}

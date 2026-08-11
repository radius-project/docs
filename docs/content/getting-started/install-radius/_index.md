---
type: docs
title: "1. Install Radius"
linkTitle: "1. Install Radius"
description: "Install Radius on a Kubernetes cluster and initialize your first application"
weight: 100
---

In part one, you will install Radius on an existing Kubernetes cluster.

## Prerequisites

For this guide you only need a **Kubernetes cluster**. To install Radius, your user must have the cluster-admin role. Radius <a href="{{< ref "installation#supported-kubernetes-clusters" >}}">supports</a> <a href="https://azure.microsoft.com/en-us/products/kubernetes-service">AKS</a>, <a href="https://aws.amazon.com/eks/">EKS</a>, <a href="https://k3d.io/">k3d</a>, and <a href="https://kind.sigs.k8s.io/">kind</a> clusters. Running a local cluster with k3d or kind is recommended.

## Install the Radius CLI

{{< read file="/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## Install Radius

Create a new directory for the Todo List application:

```bash
mkdir todolist
cd todolist
```

Ensure your cluster is set as your current context with `kubectl config current-context`. If the context needs updating, change it with `kubectl config set-context <context-name>`. Then install Radius with the `rad initialize` command:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad initialize --preview
```

Select `Yes` to set up an application in the current directory.

Example output:

```
Initializing Radius...

✅ Install Radius {{< param version >}}
    - Kubernetes cluster: k3d-k3s-default
    - Kubernetes namespace: radius-system
✅ Create new environment default
    - Kubernetes namespace: default
    - Recipe pack: default
✅ Scaffold application todolist
✅ Update local configuration

Initialization complete! Have a RAD time 😎
```

Verify the pods are running:

```bash
kubectl get pods -n radius-system
```

You should see output similar to:

```
NAME                READY   STATUS    RESTARTS   AGE
applications-rp      1/1     Running   0          1m
bicep-de             1/1     Running   0          1m
contour-contour      1/1     Running   0          1m
contour-envoy        1/1     Running   0          1m
controller           1/1     Running   0          1m
dashboard            1/1     Running   0          1m
dynamic-rp           1/1     Running   0          1m
ucp                  1/1     Running   0          1m
```

For more details on installing Radius, see [How to Install Radius]({{< ref "/installation" >}}).

## Next steps

In part two of this guide, you will deploy the Todo List sample application.

{{< button text="Next step: Deploy an application" page="getting-started/deploy-todolist" >}}

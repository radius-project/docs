---
type: docs
title: "1. Install Radius"
linkTitle: "1. Install Radius"
description: "Install Radius on a Kubernetes cluster and initialize your first application"
weight: 100
---

In part one, you will install Radius on an existing Kubernetes cluster.

## Prerequisites

Use a **private, disposable Kubernetes cluster** with no existing `demo-default` application. To install Radius, your user must have the cluster-admin role. Radius <a href="{{< ref "installation#supported-kubernetes-clusters" >}}">supports</a> <a href="https://azure.microsoft.com/en-us/products/kubernetes-service">AKS</a>, <a href="https://aws.amazon.com/eks/">EKS</a>, <a href="https://k3d.io/">k3d</a>, and <a href="https://kind.sigs.k8s.io/">kind</a> clusters. Running a local cluster with k3d or kind is recommended. Do not expose the demo or database publicly: step three deliberately uses unencrypted PostgreSQL connections.

The commands use Bash on Linux or macOS, `kubectl`, and OpenSSL. On Windows, use WSL with a Linux filesystem for the protected temporary password file; Git Bash on a Windows filesystem does not provide the same Unix permission guarantees. Use a compatible Radius CLI/runtime, Bicep compiler and extension, registered PostgreSQL schema, and Kubernetes Recipe Pack. The schema must accept `tls: 'disabled'`, the PostgreSQL Recipe must implement that policy, and the Container and Secret Recipes must support password projection through `secretKeyRef`. Secret support alone does not establish TLS-policy compatibility. Check the Environment's assigned Recipe Pack and any overrides, not just the CLI version.

> **Edge adoption gate:** This tutorial depends on the [PostgreSQL transport-policy change](https://github.com/radius-project/resource-types-contrib/pull/394) and the matching samples update. Do not run the database step until compatible schemas, extensions, and recipes are publicly available and the sample has landed on `edge`. Public edge artifacts are sufficient; no numbered release is required. An older plaintext Recipe, a schema warning, or an unpublished candidate is not a supported substitute. See the [PostgreSQL operator guide](https://github.com/radius-project/resource-types-contrib/blob/131913259f3beb40807afed9730b454128f6d108/Data/postgreSqlDatabases/README.md#adopting-the-change) for the candidate policy and adoption requirements.

## Install the Radius CLI

{{< read file="/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## Install Radius

Create a new directory for the Radius Demo application:

```bash
mkdir radius
cd radius
```

Ensure your disposable cluster is set as your current context with `kubectl config current-context`. If the context needs updating, change it with `kubectl config use-context <context-name>`. Then install Radius with the `rad initialize` command:

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
✅ Scaffold application radius
✅ Update local configuration

Initialization complete! Have a RAD time 😎
```

Verify the pods are running:

```bash
kubectl get pods -n radius-system
```

You should see output similar to:

```
NAME                                  READY   STATUS    RESTARTS   AGE
applications-rp-xxxxxxxxxx-xxxxx      1/1     Running   0          1m
bicep-de-xxxxxxxxxx-xxxxx             1/1     Running   0          1m
contour-contour-xxxxxxxxxx-xxxxx      1/1     Running   0          1m
contour-envoy-xxxxxxxxxx-xxxxx        1/1     Running   0          1m
controller-xxxxxxxxxx-xxxxx           1/1     Running   0          1m
dashboard-xxxxxxxxxx-xxxxx            1/1     Running   0          1m
dynamic-rp-xxxxxxxxxx-xxxxx           1/1     Running   0          1m
ucp-xxxxxxxxxx-xxxxx                  1/1     Running   0          1m
```

For more details on installing Radius, see [How to Install Radius]({{< ref "/installation" >}}).

## Next steps

In part two of this guide, you will deploy the Radius Demo sample application.

{{< button text="Next step: Deploy an application" page="getting-started/deploy-demo" >}}

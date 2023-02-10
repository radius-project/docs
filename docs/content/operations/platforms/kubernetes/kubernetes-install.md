---
type: docs
title: "Install Radius on Kubernetes"
linkTitle: "Installation"
description: "Learn how to setup Radius on supported Kubernetes clusters"
weight: 200
---

The [Radius control plane]({{< ref architecture >}}) handles the deployment and management of Radius environments, applications, and resources.

## Install with the rad CLI

Use the [`rad install kubernetes` command]({{< ref rad_install_Kubernetes >}}) to install Radius control plane on the kubernetes cluster.
```bash
rad install kubernetes
```

{{% alert title="💡 About namespaces" color="success" %}}
When Radius initializes a Kubernetes environment, it will deploy the system resources into the `radius-system` namespace. These aren't part your application. The namespace specified in interactive mode will be used for future deployments by default.
{{% /alert %}}

## Install with Helm

1. Begin by adding the Radius Helm repository:
   ```bash
   helm repo add radius https://radius.azurecr.io/helm/v1/repo
   helm repo update
   ```
1. Get all available versions:
   ```bash
   helm search repo radius --versions
   ```
1. Install the specified chart:
   ```bash
   helm upgrade radius radius/radius --install --create-namespace --namespace radius-system --version {{< param chart_version >}} --wait --timeout 15m0s
   ```

---
type: docs
title: "How-To: Install Radius on Kubernetes"
linkTitle: "Install"
description: "Learn how to install Radius on Kubernetes"
weight: 100
categories: "How-To"
tags: ["Kubernetes"]
aliases: 
- /guides/operations/kubernetes/kubernetes-install
---

Radius handles the deployment and management of environments, applications, and other resources with components that are installed into the Kubernetes cluster.

## Prerequisites

- A Kubernetes cluster with cluster-admin privileges for your user.
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Step 1: Install the Radius CLI

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

The Radius CLI stores its configuration in a YAML file named `config.yaml` under the `rad` directory. This file contains [Workspaces]({{< ref "/guides/operations/workspaces/overview" >}}), which point to your cluster, your [Resource Group]({{< ref "/guides/operations/groups/overview" >}}), and your [Environment]({{< ref "/guides/deploy-apps/environments/overview" >}}). When the Radius CLI runs commands, it will use the configuration in the `config.yaml` file to determine which cluster, resource group, and environment to target and use.

For more information, refer to the [`config.yaml` reference documentation]({{< ref "/reference/config" >}}).

## Step 2: Install Radius 

Install Radius using any of the following options:

{{< tabs `rad initialize` `rad install` `Using Helm` >}}{{% codetab %}}

[`rad initialize`](<{{< ref rad_initialize >}}>) command installs Radius and creates a pre-configured set of Resource Types, Recipes, and Environments. It is intended to get you started quickly

``` bash
rad initialize
```

Select `Yes` to setup application in the current directory.

Example output:

```
Initializing Radius...
✅ Install Radius {{< param version >}}
    - Kubernetes cluster: k3d-k3s-default
    - Kubernetes namespace: radius-system
✅ Create new environment default
    - Kubernetes namespace: default
    - Recipe pack: local-dev
✅ Scaffold application todolist
✅ Update local configuration
Initialization complete! Have a RAD time 😎
```

This command:

- Creates a namespace called the `radius-system` namespace and installs the Radius control plane components.
- Creates a default Resource group, Environment, and Workspace.
- Pre-configures the Environment with Recipes.
- Creates `app.bicep` with a sample `demo` container.
- Creates `bicepconfig.json` which contains the Bicep extensions for Radius resources.

{{% /codetab %}}
{{% codetab %}}

[`rad install kubernetes`]({{< ref rad_install_kubernetes >}}) installs the Radius control plane into the `radius-system` namespace.

You can optionally use the `--set` flag to customize the installation with [Helm configuration options](https://github.com/radius-project/radius/blob/main/deploy/Chart/values.yaml):

```bash
# Install Radius
rad install kubernetes

# Install Radius with tracing and public endpoint override
rad install kubernetes --set global.zipkin.url=http://jaeger-collector.radius-monitoring.svc.cluster.local:9411/api/v2/spans,rp.publicEndpointOverride=localhost:8081
```

### Use your own root certificate authority certificate

Many enterprises leverage intermediate root certificate authorities (CAs) to enhance security and control over outgoing traffic originating from their employees' machines, particularly when using a firewall or proxy solution. For example, some enterprises may choose to issue CAs per org and control the traffic per org. In this setup, when Radius attempts to connect to an external endpoint, such as Azure or AWS, traffic is blocked by the firewall. You may optionally use`--set-file` when installing Radius to inject your root CA certificates into Radius:

```bash
rad install kubernetes --set-file global.rootCA.cert=/etc/ssl/your-root-ca.crt
```
{{% /codetab %}}
{{% codetab %}}

Begin by adding the Radius Helm repository:

   ```bash
   helm repo add radius oci://ghcr.io/radius-project/helm-chart
   helm repo update
   ```

Get all available versions:

   ```bash
   helm search repo radius --versions
   ```

Install the specified chart:

   ```bash
   helm upgrade radius radius/radius --install --create-namespace --namespace radius-system --version {{< param chart_version >}} --wait --timeout 15m0s
   ```

Check out the [Helm chart](https://github.com/radius-project/radius/blob/main/deploy/Chart) for more information.

{{% /codetab %}}
{{</tabs>}}

## Step 3: Verify the installation

Verify if the pods are installed and running:

```bash
kubectl get pods -n radius-system
```
You should see output similar to:

```
NAME                READY   STATUS    RESTARTS   AGE
applications-rp      1/1     Running   0          1m
bicep-de             1/1     Running   0          1m
controller           1/1     Running   0          1m
dashboard            1/1     Running   0          1m 
dynamic-rp           1/1     Running   0          1m
ucp                  1/1     Running   0          1m
```

## Step 4: Install the Bicep and Terraform extensions for VS Code (optional) 

Radius uses the Infrastructure as Code (IaC) language Bicep to define application resources and either Bicep or Terraform to deploy resources. Installing the Bicep and Terraform VS Code extensions provides syntax highlighting, auto-completion, and other useful features for these languages.  

- [Install the Bicep extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)  

- [Install the Terraform extension for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform) 

## Next steps

- Refer to the [`rad install`]({{< ref rad_install >}}) command for installation options.
- Learn about [upgrading Radius]({{< ref "guides/installation/upgrade" >}})
- Learn how to [rollback Radius]({{< ref "guides/installation/rollback" >}})

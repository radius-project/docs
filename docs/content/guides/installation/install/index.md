---
type: docs
title: "How-To: Install/Uninstall Radius on Kubernetes"
linkTitle: "Install/Uninstall"
description: "Learn how to install and uninstall Radius on Kubernetes"
weight: 100
categories: "How-To"
tags: ["Kubernetes"]
aliases: 
- /guides/operations/kubernetes/kubernetes-install
---

Radius operates on a Kubernetes cluster for the deployment and management of Environments, Applications, and other resources. This guide goes through all the installation options and client tools to interact with Radius.

## Prerequisites

- Any Kubernetes cluster. Cluster-admin permissions are required because Radius creates namespaces, deployments, and custom resource definitions in the cluster.
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- If installing via Helm, use Helm 3 or later.

## Install the Radius CLI

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

The Radius CLI stores its configuration in a YAML file named `config.yaml` under the `rad` directory. This file contains Workspaces, which points to your cluster, Resource Group, and Environment. When the Radius CLI runs commands, it will use the configuration in the `config.yaml` file to determine which configuration to target and use. Each workspace entry is updated automatically when you create and switch environments.

For more information, refer to the [`config.yaml` reference documentation]({{< ref "/reference/config" >}}).

## Install Radius

Install Radius using any of the following options:

{{< tabs `rad initialize` `rad install` `Using Helm` >}}{{% codetab %}}

[`rad initialize`](<{{< ref rad_initialize >}}>) installs Radius and creates a default set of Resource Groups, Environments, Recipes, and scaffolds a sample application.

``` bash
rad initialize
```

Select `Yes` to set up application in the current directory.

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

- Creates the radius-system namespace and installs the `radius` Helm release.
- Creates a default Resource Group, Environment, and Workspace.
- Pre-configures the environment with the `local-dev` Recipe Pack. Recipes are fetched from `ghcr.io/radius-project/recipes/local-dev`.
- Creates a sample `app.bicep`, `bicepconfig.json`, and `.rad/rad.yaml` when you opt in to scaffolding.

{{% /codetab %}}
{{% codetab %}}

[`rad install kubernetes`]({{< ref rad_install_kubernetes >}}) installs or reinstalls the Radius control plane into the `radius-system` namespace.

```bash
# Install Radius
rad install kubernetes

# Force reinstall
rad install kubernetes --reinstall
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

## Customize the Radius installation

You can customize the Radius installation regardless of the entry point (`rad initialize`, `rad install kubernetes`, or Helm) with Helm overrides (`--set`, `--set-file`). 

For more information on the Helm Installation Options, checkout the [reference guide]({{< ref "helminstallation" >}}).

### Use your own root certificate authority certificate

Many enterprises leverage intermediate root certificate authorities (CAs) to enhance security and control over outgoing traffic originating from their employees' machines, particularly when using a firewall or proxy solution. For example, some enterprises may choose to issue CAs per org and control the traffic per org. In this setup, when Radius attempts to connect to an external endpoint, such as Azure or AWS, traffic is blocked by the firewall. You may optionally use`--set-file` when installing Radius to inject your root CA certificates into Radius:

```bash
rad install kubernetes --set-file global.rootCA.cert=/etc/ssl/your-root-ca.crt
```

### Air-gapped environments

Radius pulls container images for control plane services from the GitHub Container Registry (ghcr.io). In environments with strict security controls or no internet access (air‑gapped), mirror the required images to an internal registry and configure Radius to use that registry.

Example of mirroring images (requires access to both registries):

```bash
# List of Radius images
IMAGES=(
  "controller"
  "ucpd"
  "applications-rp"
  "dynamic-rp"
  "deployment-engine"
  "dashboard"
  "bicep"
)

SOURCE_REGISTRY="ghcr.io/radius-project"
TARGET_REGISTRY="myregistry.azurecr.io"
VERSION="latest"  # or specific version like "0.48"

# Mirror each image
for IMAGE in "${IMAGES[@]}"; do
  docker pull ${SOURCE_REGISTRY}/${IMAGE}:${VERSION}
  docker tag ${SOURCE_REGISTRY}/${IMAGE}:${VERSION} ${TARGET_REGISTRY}/${IMAGE}:${VERSION}
  docker push ${TARGET_REGISTRY}/${IMAGE}:${VERSION}
done
```
Then install Radius configured to pull images from your private registry, and supply image pull secrets if authentication is required.

```bash
rad install kubernetes \
  --set global.imageRegistry=myregistry.azurecr.io
  --set global.imagePullSecrets[0].name=myregistry-secret
```

Note: When using a custom registry, images are pulled directly from <registry>/<image-name>:<tag> format. For example, with myregistry.azurecr.io, the controller image will be pulled from myregistry.azurecr.io/controller:latest.

### Workload Identity 

Radius enables you to deploy and connect to cloud resources across Azure and AWS. `global.azureWorkloadIdentity.enabled` and `global.aws.irsa.enabled` options enable workload identity support for the cloud providers.

```bash
# Azure workload identity
rad install kubernetes --set global.azureWorkloadIdentity.enabled=true

# AWS IAM Roles for Service Accounts
rad install kubernetes --set global.aws.irsa.enabled=true
```

### Skip Contour

Radius installs Contour as the ingress controller by default. If your platform already has a preferred ingress, you can skip installing Contour.

```bash
rad install kubernetes --set --skip-contour-install
```

## Verify the installation

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

## Uninstall Radius 

To uninstall the existing Radius installation, use any of the following commands:

{{< tabs "Uninstall" "Uninstall with purge" >}}

{{% codetab %}}
```bash
rad uninstall kubernetes
```
You should see the Helm releases that will be removed and prompted for user confirmation:

```
About to uninstall Radius. This will remove:
- Helm releases: radius, contour
                                              
Continue uninstalling Radius?                 
  >  1. No                         
```

Select `Yes`. All the Radius services running in the `radius-system` namespace will be removed. Note that the Radius configuration and data will still be persisted in the cluster.

{{% /codetab %}}
{{% codetab %}}

```bash
rad uninstall kubernetes --purge
```

You should see the list of all the Radius resources that will be removed and prompted for user confirmation 

```
About to uninstall Radius. This will remove:
- Helm releases: radius, contour
- Radius environments:
  • /planes/radius/local/resourcegroups/default/providers/Applications.Core/environments/default (namespace default)
- Kubernetes namespaces: radius-system
- Kubernetes namespaces (skipped): default
- Kubernetes API services: v1alpha3.api.ucp.dev
- Kubernetes custom resource definitions: deploymentresources.radapp.io, deploymenttemplates.radapp.io, recipes.radapp.io, queuemessages.ucp.dev, resources.ucp.dev
                                              
Continue uninstalling Radius?                 
  >  1. No                                    
```

Select `Yes`. This will delete all the Radius data from your cluster.

{{% /codetab %}}
{{< /tabs >}}

## Remove the rad CLI

You can remove the rad CLI by deleting the `rad` binary under `/usr/local/bin/` and `~/.rad` folder from your machine.

## Next steps

- Refer to the [`rad install`]({{< ref rad_install >}}) command for installation options.
- Learn about [upgrading Radius]({{< ref "guides/installation/upgrade" >}})
- Learn how to [rollback Radius]({{< ref "guides/installation/rollback" >}})

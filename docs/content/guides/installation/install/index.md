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

This guide goes through all the installation options and client tools to interact with Radius.

## Radius CLI 

The `rad` CLI is the primary interface for installing and operating Radius. Install it on any workstation or automation runner that interacts with Radius.

Use the project installer to add `rad` plus the embedded `rad-bicep` compiler:

```bash
curl -fsSL "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" | /bin/bash
```

To install a **specific version**, pass the version number (without the leading `v`) to the script. The installer translates it to the tagged release:

  ```bash
  curl -fsSL "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" | /bin/bash -s 0.50.0
  ```

To install into **an alternate directory**, set `RADIUS_INSTALL_DIR` before invoking the script. This is required in environments like Azure Cloud Shell that disallow writes to `/usr/local/bin`:

```bash
export RADIUS_INSTALL_DIR=$HOME/bin
curl -fsSL "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" | /bin/bash
```

The Radius CLI stores its configuration in a YAML file named `config.yaml` under the `rad` directory. This file contains Workspaces, which points to your cluster, Resource Group, and Environment. When the Radius CLI runs commands, it will use the configuration in the `config.yaml` file to determine which configuration to target and use. Each workspace entry is updated automatically when you create and switch environments.

For more information, refer to the [`config.yaml` reference documentation]({{< ref "/reference/config" >}}).

## Radius Control Plane Installation

The Radius Control Plane services can be installed using Radius CLI or Helm. `rad install` and `rad init` both pin the chart version to the CLI’s channel; keeping them aligned prevents API mismatches.

{{< tabs `rad initialize` `rad install` `Using Helm` >}}{{% codetab %}}

[`rad initialize`](<{{< ref rad_initialize >}}>) is meant to get started with Radius and doesn't allow much customization. It

- Creates the radius-system namespace and installs the `radius` Helm release.
- Creates a default Resource Group, Environment, and Workspace.
- Pre-configures the environment with the `local-dev` Recipe Pack. Recipes are fetched from `ghcr.io/radius-project/recipes/local-dev`.
- Creates a sample `app.bicep`, `bicepconfig.json`, and `.rad/rad.yaml` when you opt in to scaffolding.

{{% /codetab %}}
{{% codetab %}}

[`rad install kubernetes`]({{< ref rad_install_kubernetes >}}) installs or reinstalls only the Radius control plane into the `radius-system` namespace. Use this option when you need to customize the installation for your production workloads and platform needs.

{{% /codetab %}}
{{% codetab %}}

You can directly install the Radius control plane services with Helm chart. Use this option if you are already using Helm as part of your GitOps or automation systems.

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

### Customize the Radius installation

You can customize the Radius installation regardless of the entry point (`rad initialize`, `rad install kubernetes`, or Helm) with Helm overrides (`--set`, `--set-file`). 

For more information on the Helm Installation Options, checkout the [reference guide]({{< ref "helminstallation" >}}).

#### Bring your own root certificate authority certificate

Many enterprises leverage intermediate root certificate authorities (CAs) to enhance security and control over outgoing traffic originating from their employees' machines, particularly when using a firewall or proxy solution. Radius can mount an intermediate CA bundle into every control-plane pod. Set `global.rootCA.cert` using `--set-file` option via CLI or in the Helm chart. 

Example:

```bash
rad install kubernetes --set-file global.rootCA.cert=/etc/ssl/your-root-ca.crt
```

#### Deploy to Air-gapped environments

Radius pulls container images for control plane services from the GitHub Container Registry (ghcr.io). In environments with strict security controls or no internet access (air‑gapped), mirror the required images to an internal registry and configure Radius to use that registry.

Example of mirroring images (requires access to both registries):

```sh
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
  --set global.imageRegistry=myregistry.azurecr.io \
  --set global.imageTag={{ .Chart.AppVersion }} \
  --set global.imagePullSecrets[0].name=myregistry-secret
```

When using a custom registry, images are pulled directly from <registry>/<image-name>:<tag> format. For example, with myregistry.azurecr.io, the controller image will be pulled from myregistry.azurecr.io/controller:latest.

#### Configure workload identity

Radius enables you to deploy and connect to cloud resources across Azure and AWS. The chart flags `global.azureWorkloadIdentity.enabled` and `global.aws.irsa.enabled` toggle the Kubernetes-side configuration to use workload identity; you still need to configure cloud identities and register credentials afterward. See the [Azure workload identity guide]({{< ref "/guides/operations/providers/azure-provider/howto-azure-provider-wi" >}}) and the [AWS IRSA guide]({{< ref "/guides/operations/providers/aws-provider/howto-aws-provider-irsa" >}}).

```bash
# Azure workload identity
rad install kubernetes --set global.azureWorkloadIdentity.enabled=true

# AWS IAM Roles for Service Accounts
rad install kubernetes --set global.aws.irsa.enabled=true
```

### Skip Contour

Radius installs the Bitnami Contour chart alongside the control plane so gateways and the dashboard can expose HTTP(S) endpoints. If your platform already runs an ingress or gateway controller, disable Contour and make sure your controller understands the `projectcontour.io/HTTPProxy` CRDs (or adjust your application definitions accordingly).

```bash
rad install kubernetes --skip-contour-install
```

Radius still emits `HTTPProxy` resources when you deploy gateways. If you use a different ingress API, install the matching CRDs and update your app manifests so the generated resources are compatible with your controller.

#### Radius Dashboard

The Dashboard is enabled by default. You can disable it when you do not need the Backstage-based UI:

  ```bash
  rad install kubernetes --set dashboard.enabled=false
  ```

When enabled, expose it via Contour or your ingress. In locked-down clusters you can port-forward:

  ```bash
  kubectl port-forward svc/dashboard -n radius-system 7007:7007
  ```

## Troubleshooting installation

- **403 when pulling charts from ghcr.io** – Clear cached credentials with `docker logout ghcr.io`, or mirror the chart and install with `rad install kubernetes --chart /path/to/radius-<version>.tgz`.
- **Existing Radius release detected** – Rerun the installer with `--reinstall` or uninstall the existing release before retrying, otherwise Helm skips the upgrade.
- **Helm reports missing permissions** – Verify the kube context and ensure the account has cluster-admin rights (`kubectl auth can-i create crd`).
- **Contour chart download fails** – Provide a local chart via `--contour-chart` if the cluster cannot reach the Bitnami registry.
- **Pods stuck after install** – Inspect with `kubectl describe pod -n radius-system` to identify image pull issues.

## Next steps

- Review the [`rad install`]({{< ref rad_install >}}) command reference for the full set of flags.
- Follow the [upgrade guide]({{< ref "guides/installation/upgrade" >}}) to plan version rollouts.
- Learn how to [roll back Radius]({{< ref "guides/installation/rollback" >}}) if an installation or upgrade needs to be reversed.

---
type: docs
title: "How to set up developer workstations"
linkTitle: "Developer workstations"
description: "Learn how to set up a developer workstation for creating and deploying applications"
weight: 500
aliases:
  - /guides/installation/dev-workstation/
  - /guides/installation/vscode/
  - /guides/installation/vscode/overview/
  - /guides/installation/bicepconfig/
  - /guides/installation/dev-workstation#configure-bicepconfigjson/
---

Setting up a developer workstation is very similar to [installing Radius]({{< ref "/installation" >}}) for the first time. The main difference is that Radius is already running in the Kubernetes cluster, so instead of installing the control plane, you point your workstation at the existing installation. This guide walks through setting up a workstation for authoring and deploying Radius applications, and how a platform team can prepare their developers' workstations at scale.

## Install the Radius CLI

The [Radius CLI]({{< ref "/installation/cli" >}}) (`rad`) is the primary tool for deploying and managing Radius applications.

{{< read file="/shared-content/installation/rad-cli/install-rad-cli.md" >}}

For more detail, including how to change the installation directory, see [Install the Radius CLI]({{< ref "/installation/cli#install-the-radius-cli" >}}).

## Connect to your Radius installation

The `rad` CLI talks to Radius through your current `kubectl` context, so make sure [`kubectl`](https://kubernetes.io/docs/tasks/tools/) is installed and its current context points at the Kubernetes cluster where Radius is installed:

```bash
kubectl config current-context
```

From your application's directory, initialize Radius:

```bash
rad initialize
```

Because Radius is already installed in the cluster, `rad initialize` does not install the control plane again. Instead, it:

- Creates a Radius Workspace that points the `rad` CLI at your existing Radius installation.
- Writes a `bicepconfig.json` into the current directory so you can author Radius resource types in Bicep.

Select `Yes` when prompted to set up the application in the current directory.

## Distribute Bicep extensions to developers

When you install Radius, via `rad install` or `rad initialize`, a set of out-of-the-box Resource Types are created along with a Bicep extension for each Resource Type. If additional Resource Types have been created in the Radius control plane, a new Bicep extension for those Resource Types must be created and distributed to each developer workstation so that everyone is using the same set of Resource Types.

[`rad bicep publish-extension`]({{< ref rad_bicep_publish-extension >}}) compiles the Resource Types into a Bicep extension. Publish it to an Azure Container Registry (ACR) to share across a team, or write it to a local file for testing or for distributing alongside your application.

{{< tabs "Azure Container Registry" "Local file" >}}

{{% codetab %}}
Publish the extension to an ACR. You must be logged in to the registry (for example, with `docker login`) and have permission to push:

```bash
rad bicep publish-extension \
  --from-file ./mycompany-radius-resources.yaml \
  --target br:mycompany.azurecr.io/radius-resources:v1
```

{{% /codetab %}}

{{% codetab %}}
Publish the extension to a local file for testing or for distributing alongside your application:

```bash
rad bicep publish-extension \
  --from-file ./mycompany-radius-resources.yaml \
  --target ./mycompany-radius-resources.tgz
```

{{% /codetab %}}

{{< /tabs >}}

Once the extension is published, each developer references it from their `bicepconfig.json` as described in [Add custom resource types to bicepconfig.json](#configure-bicepconfigjson).

## Add custom resource types to bicepconfig.json {#configure-bicepconfigjson}

`rad initialize` generates a `bicepconfig.json` that includes the **`radius`** extension, which configures the Bicep extension for all out-of-the-box Resource Types. Bicep resolves this file from the same directory as your Bicep files, or the nearest parent directory. With the `radius` extension in place, you can deploy applications that use any of the out-of-the-box Resource Types:

```json
{
  "extensions": {
    "radius": "br:biceptypes.azurecr.io/radius:<release-version>"
  }
}
```

To author against Resource Types that your team has [published as a Bicep extension](#distribute-bicep-extensions-to-developers), add that extension to the `extensions` map alongside `radius`. Reference an ACR-published extension by its registry path, or a local extension by its path on disk:

{{< tabs "Azure Container Registry" "Local file" >}}

{{% codetab %}}

```json
{
  "extensions": {
    "radius": "br:biceptypes.azurecr.io/radius:<release-version>",
    "mycompany": "br:mycompany.azurecr.io/radius-resources:v1"
  }
}
```

{{% /codetab %}}

{{% codetab %}}

```json
{
  "extensions": {
    "radius": "br:biceptypes.azurecr.io/radius:<release-version>",
    "mycompany": "./mycompany-radius-resources.tgz"
  }
}
```

{{% /codetab %}}

{{< /tabs >}}

With the extension referenced, developers can use the distributed types in their Bicep files:

```bicep
extension radius
extension mycompany
```

Sharing a common `bicepconfig.json` keeps every developer on the same extension versions.

## Install the Bicep extension for VS Code

Radius applications are authored in [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview). Visual Studio Code offers the best authoring experience, providing formatting, IntelliSense, and validation for Bicep templates and Radius resource types.

To install the Bicep extension, refer to their [installation documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#visual-studio-code-and-bicep-extension).

## Create Kubernetes users and roles

Radius runs on Kubernetes, so access to a Radius installation is governed by Kubernetes [role-based access control (RBAC)](https://kubernetes.io/docs/reference/access-authn-authz/rbac/). Platform engineers need the `cluster-admin` role to [install and upgrade Radius]({{< ref "/installation/control-plane" >}}), because those operations create cluster-scoped resources. Developers only need access to the Radius API.

The following example `ClusterRole` grants minimal access to the Radius API (`api.ucp.dev`):

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: aggregator-cluster-role
rules:
- apiGroups: ["api.ucp.dev"]
  resources: ["*"]
  verbs: ["*"]
```

Bind this `ClusterRole` to each developer's user account with a `ClusterRoleBinding` so they can access the Radius API.

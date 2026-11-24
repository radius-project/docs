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

For released Radius 0.62, retain the [ACR configuration below](#released-radius-062). Before using the GHCR examples for development or a future release, check the [Radius and Bicep compatibility requirements]({{< ref "/installation/cli#bicep-compatibility-for-ghcr" >}}).

{{< read file="/shared-content/installation/rad-cli/install-rad-cli.md" >}}

For more detail, including how to change the installation directory, see [Install the Radius CLI]({{< ref "/installation/cli#install-the-radius-cli" >}}).

## Connect to your Radius installation

The `rad` CLI talks to Radius through your current `kubectl` context, so make sure [`kubectl`](https://kubernetes.io/docs/tasks/tools/) is installed and its current context points at the Kubernetes cluster where Radius is installed:

```bash
kubectl config current-context
```

From your application's directory, install Radius:

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

`rad initialize` generates a `bicepconfig.json` that includes the **`radius`** extension, which configures the Bicep extension for all out-of-the-box Resource Types. Existing files are not overwritten. Bicep resolves this file from the same directory as your Bicep files, or the nearest parent directory.

### Released Radius 0.62

Keep the ACR references for applications using the released 0.62 contract. Include `aws` only if your application uses AWS resource types; preserve any other extensions and settings in your configuration.

```json
{
  "extensions": {
    "radius": "br:biceptypes.azurecr.io/radius:0.62",
    "aws": "br:biceptypes.azurecr.io/aws:0.62"
  }
}
```

A future patch or release candidate in the same minor line may use a different publishing contract. Follow that release's published configuration rather than inferring the registry from its minor version.

### Development and future GHCR releases

Use `edge` for development. For a future release, use GHCR only after its [release and artifact prerequisites]({{< ref "/installation/cli#bicep-compatibility-for-ghcr" >}}) are satisfied. A release with GHCR defaults generates the following configuration with OCI enabled; migrate an older file only when adopting that release's contract.

```json
{
  "experimentalFeaturesEnabled": {
    "ociEnabled": true
  },
  "extensions": {
    "radius": "br:ghcr.io/radius-project/bicep-types-radius:<release-version>"
  }
}
```

Replace `<release-version>` with the `major.minor` stable channel for your compatible Radius release, or its full `major.minor.patch` version to select a specific approved release. Channel tags are mutable and advance to the newest approved stable release in that line. Full stable versions are published once by CI policy; the registry does not enforce protection against overwrites.

For a release candidate, use the full prerelease version exactly as published, preserving `rc.N` or `rcN` spelling. Do not substitute a stable channel, `latest`, or `edge` when the selected release artifact is unavailable.

For development builds, use `edge`. GHCR `latest` selects the newest approved stable release, unlike the legacy ACR `latest` development tag. These tag meanings apply to both the Radius and AWS extension packages.

To pin exact content instead of a tag, use `br:ghcr.io/radius-project/bicep-types-radius@sha256:<manifest-digest>` (or the same syntax with `bicep-types-aws`). Use the manifest's 64-character lowercase hexadecimal digest, not a Git commit SHA. Digest pinning does not prevent deletion of the package content.

Generic OCI support must be enabled in every effective `bicepconfig.json` that references GHCR. If an application or sample directory has its own configuration file, include `experimentalFeaturesEnabled.ociEnabled` there as well instead of relying on the parent configuration.

To author against Resource Types that your team has [published as a Bicep extension](#distribute-bicep-extensions-to-developers), add that extension to the `extensions` map alongside `radius`. The examples below use the development/future GHCR configuration; a released 0.62 application keeps its Radius ACR reference. Reference your team's ACR-published extension by its registry path, or a local extension by its path on disk:

{{< tabs "Azure Container Registry" "Local file" >}}

{{% codetab %}}

```json
{
  "experimentalFeaturesEnabled": {
    "ociEnabled": true
  },
  "extensions": {
    "radius": "br:ghcr.io/radius-project/bicep-types-radius:<release-version>",
    "mycompany": "br:mycompany.azurecr.io/radius-resources:v1"
  }
}
```

{{% /codetab %}}

{{% codetab %}}

```json
{
  "experimentalFeaturesEnabled": {
    "ociEnabled": true
  },
  "extensions": {
    "radius": "br:ghcr.io/radius-project/bicep-types-radius:<release-version>",
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

Editor validation also requires Bicep tooling with generic OCI support (v0.45.6 or later).

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

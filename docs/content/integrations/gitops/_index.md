---
type: docs
title: "How to deploy Applications using Flux"
linkTitle: "Deploy Applications with Flux"
description: "Learn how to deploy Applications with Flux and Radius integration"
weight: 100
aliases:
  - /guides/gitops/
  - /guides/gitops/overview/
  - /guides/gitops/howto-flux/
---

Radius integrates with [Flux](https://fluxcd.io/) to continuously deploy and manage cloud-native Applications and infrastructure from a Git repository. The repository provides a version-controlled source of truth, while Flux detects changes and triggers Radius to reconcile the deployed resources with the desired state.

This guide explains how the Radius integration works, how to configure a repository, and how to deploy and manage an existing Radius Application with Flux.

## GitOps capabilities in Radius

1. **Declarative configuration:** Store Bicep Application definitions, parameters, and Radius deployment configuration in Git so the desired state is version controlled and reviewable.
1. **Continuous deployment:** Flux detects new repository revisions, and Radius compiles and deploys the Bicep files selected in the repository configuration.
1. **Reconciliation:** Radius creates or updates a `DeploymentTemplate` for each configured Bicep file. Removing an entry from the configuration deletes its `DeploymentTemplate` and the resources managed by that deployment.
1. **Security and compliance:** Git history provides an auditable record of changes. Repository access, branch protection, and review policies remain managed through the Git provider and Flux.
1. **Scalability and flexibility:** A repository can define multiple deployments with separate Kubernetes namespaces and Radius Resource Groups. Multiple Flux `GitRepository` resources can target repositories for different clusters or deployment stages.

## How Radius integrates with Flux

The Radius controller watches Flux `GitRepository` resources in the Kubernetes cluster. When Flux publishes a new repository revision, Radius:

1. Downloads the artifact from the Flux source controller.
1. Looks for `radius-gitops-config.yaml` at the root of the artifact. Repositories without this file are ignored by Radius.
1. Compiles each Bicep file listed in the configuration and applies its optional Bicep parameters.
1. Creates or updates a `DeploymentTemplate` in the configured Kubernetes namespace.
1. Deploys the template into the configured Radius Resource Group.
1. Deletes `DeploymentTemplate` resources previously created from the repository when their Bicep files are removed from the configuration.

Flux manages access to and synchronization of the Git repository. Radius manages Bicep compilation and deployment after Flux produces a new artifact.

## Before you begin

Before deploying an Application with Flux, verify that:

- The [Radius control plane]({{< ref "/installation/control-plane" >}}) is installed in the Kubernetes cluster.
- The [Flux control plane components](https://fluxcd.io/flux/installation/#install-the-flux-controllers) are installed in your Kubernetes cluster.
- The [Flux CLI](https://fluxcd.io/docs/installation/) is installed.
- The target [Radius Resource Group]({{< ref "/management/groups" >}}) exists.
- An existing Bicep file defines the Radius Application and resources to deploy.
- A remote Git repository, such as GitHub or GitLab, is available to store the deployment files.

{{% alert title="⚠️ Flux Network Policy" color="warning" %}}
When installing Flux using the `flux bootstrap` or `flux install` commands, specify `--network-policy=false`, or configure the network policy to allow access from the `radius-system` namespace to the source controller. This access allows Radius to communicate with the Flux source controller and synchronize changes from your Git repository.

For more information, see the [Flux network policy documentation](https://fluxcd.io/flux/installation/configuration/optional-components/#network-policies).
{{% /alert %}}

## Step 1: Configure the repository

Add the existing Bicep Application definition to the Git repository. Add a `.bicepparam` file when the deployment requires parameters, then create `radius-gitops-config.yaml` at the repository root:

```text
.
├── app.bicep
├── app.bicepparam
└── radius-gitops-config.yaml
```

The following configuration deploys `app.bicep` with `app.bicepparam`, creates its `DeploymentTemplate` in the `app` Kubernetes namespace, and targets the `default` Radius Resource Group:

```yaml
config:
  - name: app.bicep
    params: app.bicepparam
    namespace: app
    resourceGroup: default
```

Each entry under `config` supports these fields:

| Field | Required | Description |
| --- | --- | --- |
| `name` | Yes | Path to a `.bicep` file in the repository. The file must exist. |
| `params` | No | Path to an existing `.bicepparam` file used to compile the Bicep file. |
| `namespace` | No | Kubernetes namespace for the generated `DeploymentTemplate`. Radius creates the namespace if needed. Defaults to the Bicep filename without `.bicep`. |
| `resourceGroup` | No | Radius Resource Group where the template deploys resources. Defaults to the Bicep filename without `.bicep`. The Resource Group must already exist. |

Add another entry under `config` for each additional Bicep deployment. Specify `namespace` and `resourceGroup` explicitly when the filename-derived defaults do not match the intended deployment scope.

Commit and push the deployment files:

```bash
git add app.bicep app.bicepparam radius-gitops-config.yaml
git commit -m "Configure Radius deployment"
git push origin main
```

Omit `app.bicepparam` from the repository, configuration, and `git add` command when the Bicep file does not require parameters.

## Step 2: Create a Flux GitRepository source

Create a Flux `GitRepository` source for your repository:

```bash
flux create source git radius-flux-app \
  --url=<your-repo-url> \
  --branch=main
```

Flux creates a `GitRepository` resource and begins polling the selected branch. For private repository authentication and other source options, see the [Flux GitRepository documentation](https://fluxcd.io/flux/components/source/gitrepositories/).

## Step 3: Verify the deployment

Check whether Flux has fetched the repository:

```bash
flux get sources git radius-flux-app
```

Then inspect the `DeploymentTemplate` created by Radius:

```bash
kubectl get deploymenttemplates -A
kubectl describe deploymenttemplate app.bicep -n app
```

A ready `DeploymentTemplate` indicates that Radius compiled the Bicep file and completed the deployment. Use [`rad app graph`]({{< ref rad_application_graph >}}) with the Application name declared in the Bicep file to inspect the resulting Application graph:

```bash
rad app graph -a <application-name>
```

## Step 4: Update a deployment

Update the Bicep definition, its parameter file, or its entry in `radius-gitops-config.yaml`, then commit and push the change. Flux publishes the new revision, and Radius updates the corresponding `DeploymentTemplate` and deployed resources.

## Remove a deployment

Remove a Bicep entry from `radius-gitops-config.yaml` and push the change when Flux should stop managing that deployment. To remove every deployment associated with the repository, use an empty configuration:

```yaml
config: []
```

When Radius processes the revision, it deletes the `DeploymentTemplate` for each removed entry. The `DeploymentTemplate` controller deletes resources managed by those deployments. Review the affected resources before pushing the change.

After the deployment is removed, delete unreferenced Bicep and parameter files from the repository if they are no longer needed.

## Troubleshoot reconciliation

Check each stage in order to isolate where reconciliation stopped:

### Check the Flux source

Confirm that Flux fetched the expected revision:

```bash
flux get sources git radius-flux-app
kubectl describe gitrepository radius-flux-app -n flux-system
```

If Flux cannot fetch a private repository, review the `GitRepository` authentication and secret configuration in the [Flux documentation](https://fluxcd.io/flux/components/source/gitrepositories/#secret-reference).

### Check the repository configuration

Confirm that `radius-gitops-config.yaml` is at the repository root and that every `name` and `params` path refers to an existing file. Radius ignores a repository without the configuration file and rejects entries with missing files or a `name` that does not end in `.bicep`.

### Check the DeploymentTemplate

Inspect the generated `DeploymentTemplate` status and Kubernetes events:

```bash
kubectl get deploymenttemplates -A
kubectl describe deploymenttemplate app.bicep -n app
```

### Check the Radius controller

Inspect the Radius controller logs for configuration parsing, Bicep compilation, or deployment errors:

```bash
kubectl logs -n radius-system deployment/controller
```

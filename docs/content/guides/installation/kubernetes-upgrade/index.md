---
type: docs
title: "How-To: Upgrade Radius on Kubernetes"
linkTitle: "Upgrade Radius on Kubernetes"
description: "Learn how to upgrade Radius on Kubernetes"
weight: 400
slug: 'upgrade'
categories: "How-To"
tags: ["Kubernetes"]
---

Radius supports in-place upgrades on Kubernetes clusters using the `rad upgrade kubernetes` command. This command upgrades the Radius control plane while preserving your existing environments and applications.

## Prerequisites

- [Radius installed on Kubernetes cluster]({{< ref "guides/installation/kubernetes-install" >}})
- [Latest rad CLI]({{< ref howto-rad-cli >}})

## Step 1: Upgrade the rad CLI

First, ensure you have the latest version of the rad CLI:

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## Step 2: Upgrade Radius control plane

Use the [`rad upgrade kubernetes` command]({{< ref rad_upgrade_kubernetes >}}) to upgrade Radius in your cluster:

```bash
# Upgrade to the latest version matching your CLI
rad upgrade kubernetes

# Upgrade to a specific version
rad upgrade kubernetes --version 0.49.0

# Upgrade with custom configuration
rad upgrade kubernetes --set key=value
```

### Preflight checks

The upgrade process automatically runs preflight checks to ensure your cluster is ready for the upgrade. These checks include:

- **Kubernetes connectivity and permissions**: Verifies connection to the cluster and required RBAC permissions
- **Helm connectivity and installation status**: Confirms Radius is installed via Helm and can be upgraded
- **Version compatibility validation**: Ensures the target version is compatible with your current version
- **Cluster resource availability**: Checks for sufficient resources (optional warning)
- **Custom configuration validation**: Validates any custom Helm values

To skip preflight checks (not recommended):

```bash
rad upgrade kubernetes --skip-preflight
```

To run only preflight checks without upgrading:

```bash
rad upgrade kubernetes --preflight-only
```

## Step 3: Verify the upgrade

After the upgrade completes, verify that Radius is running the new version:

```bash
# Check Radius version
rad version

# Verify pods are running
kubectl get pods -n radius-system

# Check your environments are still available
rad env list
```

## Important considerations

### Breaking changes

While Radius supports in-place upgrades, breaking changes may still occur between major versions. Always review the [release notes](https://github.com/radius-project/radius/releases) before upgrading to understand any breaking changes or migration steps required.

### Rollback capability

If an upgrade encounters issues, you can rollback to a previous version using the [`rad rollback kubernetes` command]({{< ref "guides/installation/kubernetes-rollback" >}}).

It's recommended to backup your environment configurations before upgrading, which you may do with something like `rad env show -o json > env-backup.json`.

## Alternative: Fresh installation

If you prefer to do a fresh installation instead of an in-place upgrade, follow these steps:

1. Delete all existing Radius Environments:

   ```bash
   # List all environments
   rad env list

   # Delete each environment
   rad env delete <environment-name>
   ```

2. Uninstall Radius:

   ```bash
   rad uninstall kubernetes
   ```

3. Install the latest version:

   ```bash
   rad install kubernetes
   ```

4. Create new environments and deploy your applications

## Next steps

- Learn how to [rollback Radius]({{< ref "guides/installation/kubernetes-rollback" >}}) if needed
- Review [Radius versioning]({{< ref "guides/installation/versioning" >}}) for version compatibility information
- Refer to the [`rad upgrade`]({{< ref "reference/cli/rad_upgrade_kubernetes" >}}) CLI reference docs for more details

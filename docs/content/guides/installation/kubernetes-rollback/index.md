---
type: docs
title: "How-To: Rollback Radius on Kubernetes"
linkTitle: "Rollback Radius on Kubernetes"
description: "Learn how to rollback Radius to a previous version on Kubernetes"
weight: 350
categories: "How-To"
tags: ["Kubernetes"]
---

Radius supports rolling back to previous versions on Kubernetes clusters using the `rad rollback kubernetes` command. This feature allows you to quickly revert to a known-good version if issues are encountered after an upgrade.

## Prerequisites

- [Radius installed on Kubernetes cluster]({{< ref "guides/installation/kubernetes-install" >}})
- [rad CLI]({{< ref howto-rad-cli >}})
- Previous Radius installation to rollback to

## Understanding Helm revisions

Radius uses Helm for installation and upgrades on Kubernetes. Each installation or upgrade creates a new Helm revision. These revisions serve as restore points that you can rollback to if needed.

To view the revision history:

```bash
# List all Radius Helm revisions
helm history radius -n radius-system

# Example output:
# REVISION  UPDATED                   STATUS      CHART        APP VERSION  DESCRIPTION
# 1         Mon Oct 2 10:00:00 2024   superseded  radius-0.48  0.48         Install complete
# 2         Mon Oct 9 11:00:00 2024   superseded  radius-0.49  0.49         Upgrade complete
# 3         Mon Oct 16 12:00:00 2024  deployed    radius-0.50  0.50         Upgrade complete
```

## Step 1: Check current version and available revisions

Before rolling back, check your current Radius version and available revisions:

```bash
# Check current version
rad version

# List available revisions using rad CLI
rad rollback kubernetes --list-revisions

# Alternatively, view Helm revision history directly
helm history radius -n radius-system
```

## Step 2: Rollback to a previous version

Use the `rad rollback kubernetes` command to rollback to a specific revision:

```bash
# Rollback to the previous revision (revision 0 or omit --revision flag)
rad rollback kubernetes

# Rollback to the previous revision explicitly using revision 0
rad rollback kubernetes --revision 0

# Rollback to a specific revision number
rad rollback kubernetes --revision 3

# Switch workspace before rolling back (if needed)
rad workspace switch myworkspace
rad rollback kubernetes --revision 2
```

The rollback process will:

1. Revert the Helm release to the specified revision
2. Restore the previous version's configuration
3. Restart Radius components with the previous version

## Step 3: Verify the rollback

After the rollback completes, verify that Radius is running the previous version:

```bash
# Check Radius version
rad version

# Verify pods are running
kubectl get pods -n radius-system

# Check Helm release status
helm status radius -n radius-system

# Verify your environments are still available
rad env list
```

## Important considerations

### CRD compatibility

> **Warning:** Custom Resource Definitions (CRDs) are not automatically rolled back due to [Helm limitations](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/).
>
> If the newer version introduced CRD changes, rolling back the control plane might result in compatibility issues. In such cases, you may need to:
>
> 1. Manually revert CRD changes, or
> 2. Perform a fresh installation of the desired version

### Data and configuration

- **Environments and applications**: These are preserved during rollback as they are stored as Kubernetes resources
- **Custom Helm values**: Previous configuration values are restored with the rollback
- **Workspace configuration**: Local workspace configuration (in ~/.rad) is not affected by rollback

### When rollback might not work

Rollback may not be successful if:

- The previous version's state is corrupted
- There are incompatible CRD changes between versions
- Required dependencies are no longer available
- Breaking changes in the data format between versions

In these cases, a fresh installation may be required.

## Alternative: Fresh installation

If rollback is not possible or encounters issues, you can perform a fresh installation:

1. Backup your environment configurations:

   ```bash
   rad env show -o json > env-backup.json
   ```

2. Uninstall Radius completely:

   ```bash
   rad uninstall kubernetes
   ```

3. Install the desired version:

   ```bash
   # Install a specific version using a local chart
   rad install kubernetes --chart /path/to/radius-chart-<version>

   # Or use Helm directly to install a specific version
   helm install radius oci://ghcr.io/radius-project/helm-chart --version <chart-version> -n radius-system --create-namespace
   ```

4. Create new environments and deploy your applications using the backup as reference

## Troubleshooting

### Failed rollback

If the rollback fails, check the Helm rollback status:

```bash
# Check Helm release status
helm status radius -n radius-system

# View detailed history
helm history radius -n radius-system

# Check pod status
kubectl get pods -n radius-system
kubectl describe pods -n radius-system
```

### Manual Helm rollback

If the rad CLI rollback fails, you can use Helm directly:

```bash
# Rollback using Helm
helm rollback radius [REVISION] -n radius-system

# Example: rollback to revision 2
helm rollback radius 2 -n radius-system
```

## Next steps

- Learn about [upgrading Radius]({{< ref "guides/installation/kubernetes-upgrade" >}})
- Review [Radius versioning]({{< ref "reference/limitations" >}}) for version compatibility
- Check [release notes](https://github.com/radius-project/radius/releases) for version-specific information
- Refer to the [`rad rollback kubernetes`]({{< ref "reference/cli/rad_rollback_kubernetes" >}}) CLI reference docs for more details

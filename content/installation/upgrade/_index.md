---
type: docs
title: "How to upgrade Radius"
linkTitle: "Upgrade Radius"
description: "Learn how to upgrade Radius on Kubernetes, including how to roll back to a previous version"
weight: 600
aliases:
  - /guides/installation/control-plane/upgrade/
---

Radius supports in-place upgrades on Kubernetes clusters using the `rad upgrade kubernetes` command. This command upgrades the Radius control plane while preserving your existing environments and applications. If an upgrade causes issues, you can roll back to a previous version.

## Important considerations

While Radius supports in-place upgrades, breaking changes may still occur between major versions. Always review the [release notes](https://github.com/radius-project/radius/releases) before upgrading to understand any breaking changes or migration steps required.

## Step 1: Record the existing version

Use the `rad version` command and record the existing version of the Radius CLI and control plane. In the example below, both the Radius CLI and control plane are running v0.58:

```bash
# Check Radius version
$ rad version
CLI Version Information:
RELEASE   VERSION   BICEP     COMMIT
0.58.0    v0.58.0   0.42.1    d8289818dc121527659b781707500a1c9d46c2fe

Control Plane Information:
STATUS     VERSION
Installed  0.58.0
```

## Step 2: Upgrade the Radius CLI

First, ensure you have the latest version of the Radius CLI:

{{< read file="/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## Step 3: Upgrade the Radius control plane

Use the [`rad upgrade kubernetes`]({{< ref rad_upgrade_kubernetes >}}) command to upgrade Radius in the cluster:

```bash
# Upgrade to the latest version matching your CLI
rad upgrade kubernetes

# Upgrade to a specific version
rad upgrade kubernetes --version 0.59.0
```

### Preflight checks

The upgrade process automatically runs preflight checks to ensure the cluster is ready for the upgrade. These checks include:

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

## Step 4: Verify the upgrade

After the upgrade completes, verify all Radius pods are running.

```bash
# Verify pods are running
$ kubectl get pods -n radius-system
NAME                               READY   STATUS    RESTARTS   AGE
applications-rp                    1/1     Running   0          47s
bicep-de                           1/1     Running   0          47s
controller                         1/1     Running   0          47s
dashboard                          1/1     Running   0          47s
dynamic-rp                         1/1     Running   0          47s
ucp                                1/1     Running   0          47s
```

Then verify that the Radius control plane is running the new version, v0.59 in this example:

```bash
# Check Radius version
$ rad version
CLI Version Information:
RELEASE   VERSION   BICEP     COMMIT
0.59.0    v0.59.0   0.42.1    2bf2c25fcdde20d4cba1371618829bbbe1f9a997

Control Plane Information:
STATUS     VERSION
Installed  0.59.0
```

## Rollback

> **Warning:** Custom Resource Definitions (CRDs) are not automatically rolled back due to [Helm limitations](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/). If the newer version introduced CRD changes, rolling back the control plane might result in compatibility issues. In such cases, you may need to manually revert CRD changes or perform a fresh installation of the desired version.

Radius supports rolling back to previous versions on Kubernetes clusters using the [`rad rollback kubernetes`]({{< ref rad_rollback_kubernetes >}}) command. This lets you quickly revert to a known-good version if issues are encountered after an upgrade.

```bash
# Roll back to the previously installed version
rad rollback kubernetes
```

- **Environments and applications**: Preserved during rollback, as they are stored as Kubernetes resources.
- **Custom Helm values**: Previous configuration values are restored with the rollback.
- **Workspace configuration**: Local Workspace configuration (in `~/.rad`) is not affected by rollback.

If the Radius CLI rollback fails, you can roll back using Helm directly:

```bash
# Roll back to a specific revision, e.g. revision 2
helm rollback radius 2 -n radius-system
```

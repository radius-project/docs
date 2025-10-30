---
type: docs
title: "How-To: Upgrade or Roll Back Radius on Kubernetes"
linkTitle: "Upgrade & Rollback"
description: "Upgrade the Radius control plane and revert to a previous revision when required"
weight: 300
categories: "How-To"
tags: ["Kubernetes"]
aliases:
  - /guides/operations/kubernetes/kubernetes-upgrade
  - /guides/operations/kubernetes/kubernetes-rollback
---

Radius supports in-place upgrades on Kubernetes with `rad upgrade kubernetes`. If a release misbehaves, restore a prior Helm revision with `rad rollback kubernetes`. Use the workflow below to move forward—and back—safely.

## Upgrade Radius

1. **Update the `rad` CLI** – Installation and upgrade commands are tied to the CLI version. Install the latest CLI before upgrading Radius services.

2. **Run the upgrade** – The upgrade process automatically runs preflight checks to ensure your cluster is ready for the upgrade. These checks include:

- Kubernetes connectivity and permissions: Verifies connection to the cluster and required RBAC permissions
- Helm connectivity and installation status: Confirms Radius is installed via Helm and can be upgraded
- Version compatibility validation: Ensures the target version is compatible with your current version
- Cluster resource availability: Checks for sufficient resources (optional warning)
- Custom configuration validation: Validates any custom Helm values

   ```bash
   # Upgrade to the version that matches your CLI (recommended)
   rad upgrade kubernetes

   # Upgrade to a specific version
   rad upgrade kubernetes --version 0.50.0

   # Upgrade with custom Helm values
   rad upgrade kubernetes --set key=value
   ```

   Need to adjust the checks?

   ```bash
   rad upgrade kubernetes --preflight-only     # Run checks only
   rad upgrade kubernetes --skip-preflight     # Skip checks (not recommended)
   ```

3. **Verify success** – Confirm the control plane restarted on the expected version and your environments still respond.

   ```bash
   rad version
   kubectl get pods -n radius-system
   rad env list
   ```

> **Tip:** Review the [release notes](https://github.com/radius-project/radius/releases) for breaking changes and back up environment definitions before upgrading: `rad env show -o json > env-backup.json`.

## Roll back workflow

1. **Inspect available revisions** – Each install or upgrade produces a Helm revision. Identify the target revision before rolling back.

   ```bash
   rad rollback kubernetes --list-revisions
   helm history radius -n radius-system
   ```

2. **Restore the desired revision** – Reapply the chosen Helm revision and restart the control plane.

   ```bash
   rad rollback kubernetes                 # Previous revision
   rad rollback kubernetes --revision 0    # Explicit previous revision
   rad rollback kubernetes --revision 3    # Specific revision number
   ```

3. **Validate the rollback** – Re-run the basic health checks to confirm the older version is active.

   ```bash
   rad version
   kubectl get pods -n radius-system
   helm status radius -n radius-system
   rad env list
   ```

> **Warning:** Helm does not roll back Custom Resource Definitions (CRDs). If the newer release changed CRDs, you may need to revert them manually or perform a clean installation of the target version.

### When rollback is not viable

Rollback can fail if the desired revision has been pruned, if CRDs or data formats changed, or if the older container images are no longer available. Capture diagnostics (`helm status radius -n radius-system`, `kubectl describe pod -n radius-system <pod-name>`) and move to a clean install if required.

## Fresh installation (fallback option)

If rollback fails or you prefer a clean slate:

1. Optionally export environment definitions: `rad env show -o json > env-backup.json`
2. Remove environments and uninstall Radius: `rad env delete <name>` and `rad uninstall kubernetes`
3. Install the target version (`rad install kubernetes --chart …` or `helm install …`)
4. Re-create environments and redeploy applications

## Troubleshooting

- **Upgrade failed preflight checks** – Resolve the reported connectivity, permission, or configuration issues before re-running the command.
- **Rollback failed** – Inspect Helm and Kubernetes events to determine why the revision could not be restored.
- **Previous revision missing** – If the target revision is gone, perform a fresh installation of the desired release.

## Next steps

- Review [Radius versioning]({{< ref "guides/operations/versioning" >}}) for compatibility guidance
- Reference the [`rad upgrade`]({{< ref "reference/cli/rad_upgrade_kubernetes" >}}) and [`rad rollback`]({{< ref "reference/cli/rad_rollback_kubernetes" >}}) CLI docs for advanced options

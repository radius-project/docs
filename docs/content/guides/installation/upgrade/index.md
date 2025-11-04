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

Radius upgrades drives a Helm upgrade of the Radius control plane (and Contour, if installed), while rollbacks replays an earlier Helm revision. Both these operations target the `radius` Helm release in the `radius-system` namespace.

## Upgrade Radius

### Before you run `rad upgrade`

- Install the latest `rad` CLI. The CLI release determines the default chart version pushed to the cluster.
- Make sure your kubeconfig user has cluster-admin permissions. The upgrade re-applies cluster-scoped resources and CRDs.
- Confirm Radius is already installed in the target cluster—`rad upgrade` exits early if it cannot find the `radius` Helm release.

### Choose the target version

`rad upgrade kubernetes` resolves the upgrade version the same way the code does:

- **Default:** The CLI release version. On edge builds, the CLI resolves the latest stable chart from `ghcr.io/radius-project/helm-chart`.
- **`--version <semver>`:** Force a specific chart version (for example `0.50.0`). The preflight logic prevents downgrades and only allows a one-minor-step upgrade.
- **`--version latest`:** Resolve to the newest chart available in the Radius registry.
- **`--chart <path>`:** Point to a local chart archive—useful in air-gapped environments or when validating a release candidate.
- **Custom values:** Pass the same overrides you used during install with `--set` and `--set-file` (for example image registry overrides or custom CA bundles). The CLI parses these flags before invoking Helm, matching the logic in `pkg/cli/helm/radius.go`.

```bash
# Recommended: upgrade to the version that matches your CLI
rad upgrade kubernetes

# Upgrade to a specific chart version
rad upgrade kubernetes --version 0.50.0

# Override Helm values during the upgrade
rad upgrade kubernetes --set global.imageRegistry=myregistry.azurecr.io

# Reapply custom certificates or feature toggles
rad upgrade kubernetes \
  --set global.prometheus.path=/metrics-radius \
  --set database.enabled=true \
  --set preupgrade.enabled=true \
  --set-file global.rootCA.cert=/etc/ssl/your-root-ca.crt
```

### Understand the preflight checks

Unless you skip them, the command runs `pkg/upgrade/preflight` checks before touching the cluster:

- **Kubernetes connectivity** – Verifies kubeconfig context and basic cluster permissions.
- **Helm connectivity** – Confirms the `radius` release exists and Helm can talk to it.
- **Radius installation status** – Ensures the control plane is currently installed.
- **Version compatibility** – Blocks downgrades or multi-version jumps.
- **Custom configuration validation** – Parses all `--set`/`--set-file` input and warns when keys do not map to the chart.
- **Resource availability** – Emits warnings if the cluster reports low capacity.

The upgrade stops on any error-level check. Configuration and resource checks surface as warnings so you can review them after the run.

```bash
# Dry-run the checks without upgrading
rad upgrade kubernetes --preflight-only

# Skip preflight checks (not recommended)
rad upgrade kubernetes --skip-preflight
```

If you enable the chart’s Helm-hook job (`--set preupgrade.enabled=true`), Radius also runs the same checks inside the cluster before applying the new release. Review the job output with:

```bash
kubectl logs job/pre-upgrade -n radius-system
```

### Run the upgrade and verify

`rad upgrade` upgrades the Radius release and then re-applies the bundled Contour chart (if Contour was installed). Watch the logs or re-run the command with `--verbose` if you need Helm output.

```bash
rad upgrade kubernetes
```

After the command finishes, confirm the expected version is running:

```bash
rad version
kubectl get pods -n radius-system
rad env list
```

If the pre-upgrade job is enabled, confirm it succeeded before moving on:

```bash
kubectl get jobs -n radius-system -l control-plane=pre-upgrade
```

> **Tip:** Read the [release notes](https://github.com/radius-project/radius/releases) for breaking changes, and back up environment definitions before upgrading: `rad env show -o json > env-backup.json`.

## Roll back Radius

`rad rollback kubernetes` uses Helm history to revert to an earlier chart. The command validates that Radius is currently installed before executing.

### Inspect available revisions

Each `rad install` or `rad upgrade` run creates a Helm revision. List the revisions directly from the CLI, or fall back to native Helm tooling:

```bash
rad rollback kubernetes --list-revisions
helm history radius -n radius-system
```

The `--list-revisions` output matches the data returned by `helm history`, including chart version, status, updated time, and the Helm description field.

### Restore a revision

- `rad rollback kubernetes` (no flags) finds the most recent revision with an older chart version and replays it. This matches the logic in `pkg/cli/helm/cluster.go`, which prevents rolling back to the current release.
- `rad rollback kubernetes --revision 0` is the explicit form of “previous revision”, aligning with Helm semantics.
- `rad rollback kubernetes --revision N` replays the exact revision number you specify after verifying it exists.

```bash
# Roll back to the previous successful revision
rad rollback kubernetes

# Explicit previous revision (alias for --revision 0)
rad rollback kubernetes --revision 0

# Roll back to a specific revision number
rad rollback kubernetes --revision 3
```

After the rollback, validate that the older version is active:

```bash
rad version
kubectl get pods -n radius-system
helm status radius -n radius-system
rad env list
```

> **Warning:** Helm does not revert CRDs. If the newer release introduced CRD schema changes, you may need to apply the prior definitions manually or reinstall the desired version.

The rollback command operates on the `radius` release only. If you also changed your ingress stack (Contour or another controller), roll that release back separately.

### When rollback is not viable

Rollback can fail when:

- The target revision was pruned or never existed in the cluster history.
- The upgrade introduced CRD or data format changes that are incompatible with older controllers.
- The container registry no longer hosts the images for the older chart.

Collect diagnostics with `helm status radius -n radius-system` and `kubectl describe pod -n radius-system <pod-name>`. If Helm cannot restore a working state, perform a clean installation of the target version.

## Fresh installation (fallback)

1. Export any environments you need to re-create: `rad env show -o json > env-backup.json`
2. Delete the environments and uninstall Radius: `rad env delete <name>` and `rad uninstall kubernetes`
3. Install the desired version (`rad install kubernetes --chart …` or `helm install …`)
4. Re-create environments and redeploy applications

## Troubleshooting

- **Preflight failures:** Resolve the specific connectivity, RBAC, or configuration errors surfaced by the preflight output, then rerun the upgrade.
- **Rollback failures:** Review Helm and Kubernetes events to pinpoint why the release could not be restored.
- **Missing revision:** If the required revision is gone, install the desired version from scratch.

## Next steps

- Review [Radius versioning]({{< ref "guides/operations/versioning" >}}) for compatibility expectations.
- See the [`rad upgrade`]({{< ref "reference/cli/rad_upgrade_kubernetes" >}}) and [`rad rollback`]({{< ref "reference/cli/rad_rollback_kubernetes" >}}) command references for the full flag set.

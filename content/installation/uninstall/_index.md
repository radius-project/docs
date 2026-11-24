---
type: docs
title: "How to uninstall Radius"
linkTitle: "Uninstall Radius"
description: "Learn how to uninstall the Radius control plane from your Kubernetes cluster, and what is retained or removed"
weight: 700
aliases:
  - /guides/installation/control-plane/uninstall/
---

Use [`rad uninstall kubernetes`]({{< ref rad_uninstall_kubernetes >}}) to remove the Radius control plane from a Kubernetes cluster. By default, Radius configuration and data are kept so that you can reinstall Radius later. Add `--purge` to delete them as well.

## Before you begin

Uninstalling Radius doesn't delete the resources your applications deployed. If you no longer need them, delete your applications with [`rad application delete`]({{< ref rad_application_delete >}}) while the control plane is still running, so that Radius removes the resources it deployed for them:

```bash
rad application delete my-app --group my-group
```

## What is removed

| | `rad uninstall kubernetes` | `rad uninstall kubernetes --purge` |
| --- | --- | --- |
| Radius control plane services and the Contour installation that `rad install` added | Removed | Removed |
| cert-manager, when `rad` installed it and no other workloads use it | Removed | Removed |
| `radius-system` namespace, including the stored Radius data such as Resource Groups, Environments, and applications | Retained | Removed |
| Radius custom resource definitions (CRDs) | Retained | Removed |
| `v1alpha3.api.ucp.dev` API service | Removed | Removed |
| Resources deployed by your applications, such as workloads in Environment namespaces and cloud resources created by Recipes | Retained | Retained |
| Local CLI configuration and Workspaces in `~/.rad/config.yaml` | Retained | Retained |

Before it makes any changes, `rad uninstall kubernetes` lists what it will remove and asks for confirmation. Use `--yes` to skip the prompt, for example in scripts, and `--kubecontext` to uninstall Radius from a cluster other than the one selected by the current `kubectl` context.

## Retain configuration and data

To uninstall the Radius control plane while keeping your Radius configuration and data, run:

```bash
rad uninstall kubernetes
```

Radius stores its data in the `radius-system` namespace, so the namespace and the Radius CRDs remain in the cluster. When you reinstall Radius in the same cluster, your existing Resource Groups, Environments, and applications are available again.

## Delete configuration and data

To remove Radius and all of its data from the cluster, run:

```bash
rad uninstall kubernetes --purge
```

After uninstalling the control plane, the command deletes the `v1alpha3.api.ucp.dev` API service and the Radius CRDs, then deletes the `radius-system` namespace and waits until the deletion completes.

{{% alert title="Warning" color="warning" %}}
Purged data can't be recovered. Reinstalling Radius afterwards starts with a fresh control plane, so you need to recreate your Resource Groups and Environments and update any Workspaces that refer to them.
{{% /alert %}}

## Delete data after uninstalling

`--purge` only takes effect while Radius is installed. If you already ran `rad uninstall kubernetes` without `--purge`, running it again reports that Radius is not installed and leaves the retained data in place. To delete that data, remove the `radius-system` namespace and the Radius CRDs with `kubectl`:

```bash
kubectl delete namespace radius-system
kubectl delete crd deploymentresources.radapp.io deploymenttemplates.radapp.io queuemessages.ucp.dev resources.ucp.dev --ignore-not-found
```

## Troubleshooting

### The `radius-system` namespace is stuck in `Terminating`

Deleting the `radius-system` namespace with `kubectl delete namespace` while Radius is still installed can hang indefinitely. Radius registers the cluster-wide `v1alpha3.api.ucp.dev` API service, which is served from the `radius-system` namespace. Once namespace deletion stops that service, Kubernetes can no longer discover the `api.ucp.dev` API group and can't finish deleting the namespace.

To confirm the cause, inspect the namespace conditions:

```bash
kubectl describe namespace radius-system
```

The conditions include a `NamespaceDeletionDiscoveryFailure` message similar to:

```text
Discovery failed for some groups, 1 failing: unable to retrieve the complete list of server APIs: api.ucp.dev/v1alpha3: stale GroupVersion discovery: api.ucp.dev/v1alpha3
```

Messages such as `Failed to delete all resource types` or `Some resources are remaining: pods` might also appear while the namespace is stuck.

Delete the stale API service so that Kubernetes can finish deleting the namespace, then check that the namespace is gone:

```bash
kubectl delete apiservice v1alpha3.api.ucp.dev
kubectl get namespace radius-system
```

Deleting the namespace directly bypasses `rad uninstall kubernetes`, so cluster-wide objects that Radius installed, such as its CRDs and RBAC roles, remain in the cluster. To remove them, reinstall Radius with [`rad install kubernetes`]({{< ref rad_install_kubernetes >}}), then run `rad uninstall kubernetes --purge`.

To avoid this problem, uninstall Radius with `rad uninstall kubernetes --purge` instead of deleting the namespace yourself.

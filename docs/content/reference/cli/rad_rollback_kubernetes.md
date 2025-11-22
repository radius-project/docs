---
type: docs
title: "rad rollback kubernetes CLI reference"
linkTitle: "rad rollback kubernetes"
slug: rad_rollback_kubernetes
url: /reference/cli/rad_rollback_kubernetes/
description: "Details on the rad rollback kubernetes Radius CLI command"
---
## rad rollback kubernetes

Rolls back Radius on a Kubernetes cluster

### Synopsis

Roll back Radius in a Kubernetes cluster to a previous revision.

This command rolls back the Radius control plane in the cluster associated with the active workspace.
By default, it rolls back to the previous successful deployment with an older version (n-1 revision).
You can also specify a specific revision number to rollback to, or use --list-revisions to see all available revisions.

Note: Specifying --revision 0 or omitting the --revision flag will roll back to the previous version.
This aligns with Helm's behavior where revision 0 is a special value meaning "previous revision".

The rollback operation will:
- Check that Radius is currently installed
- Verify that the target revision exists and is valid
- Roll back to the specified revision or previous version
- Wait for the rollback to complete

This command operates on the cluster associated with the active workspace.
To rollback Radius in a different cluster, switch to the appropriate workspace first using 'rad workspace switch'.

Radius is installed in the 'radius-system' namespace. For more information visit https://docs.radapp.io/concepts/


```
rad rollback kubernetes [flags]
```

### Examples

```
# Rollback Radius to the previous version in the cluster of the active workspace
rad rollback kubernetes

# Rollback to the previous version explicitly using revision 0
rad rollback kubernetes --revision 0

# Rollback Radius to a specific revision number
rad rollback kubernetes --revision 3

# List available revisions without performing rollback
rad rollback kubernetes --list-revisions

# Check which workspace is active
rad workspace show

# Switch to a different workspace before rolling back
rad workspace switch myworkspace
rad rollback kubernetes --revision 2

```

### Options

```
  -h, --help                 help for kubernetes
      --kubecontext string   The Kubernetes context to use, will use the default if unset
      --list-revisions       List available revisions without performing rollback
      --revision int         Specify the revision number to rollback to (0 or omitted = previous version)
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad rollback]({{< ref rad_rollback.md >}})	 - Rolls back Radius for a given platform


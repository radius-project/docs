---
type: docs
title: "rad group delete CLI reference"
linkTitle: "rad group delete"
slug: rad_group_delete
url: /reference/cli/rad_group_delete/
description: "Details on the rad group delete Radius CLI command"
---
## rad group delete

Delete a resource group

### Synopsis

Delete a resource group and all its resources.

The command will:
- Check if the resource group contains any deployed resources
- Show an appropriate confirmation prompt based on whether resources exist
- Delete all resources in the group (if any) before deleting the group itself

Resources are deleted in stages rather than all at once. Workloads are deleted first, then secrets
and secret stores, then applications, and finally environments along with the recipe packs and
settings they reference. Deleting a resource runs its recipe, which needs that configuration to
still exist, so the configuration is removed last.

If any resource fails to delete, the remaining resources in the same stage still finish and every
failure is reported. Later stages are skipped and the resource group is left in place. Re-running
the command is safe and will retry the resources that are left.

The group is checked again once its resources have been deleted. If anything is still there -- for
example a resource deployed into the group while the command was running -- the resource group is
left in place and the remaining resources are reported, so that they are not left unreachable
inside a deleted group.

Use the --yes flag to skip confirmation prompts.

```
rad group delete resourcegroupname [flags]
```

### Examples

```
rad group delete rgprod
rad group delete rgprod --yes
```

### Options

```
  -g, --group string       The resource group name
  -h, --help               help for delete
  -w, --workspace string   The workspace name
  -y, --yes                The confirmation flag
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad group]({{< ref rad_group.md >}})	 - Manage resource groups


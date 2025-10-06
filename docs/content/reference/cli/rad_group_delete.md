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


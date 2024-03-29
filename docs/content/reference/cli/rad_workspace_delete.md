---
type: docs
title: "rad workspace delete CLI reference"
linkTitle: "rad workspace delete"
slug: rad_workspace_delete
url: /reference/cli/rad_workspace_delete/
description: "Details on the rad workspace delete Radius CLI command"
---
## rad workspace delete

Delete local workspace

### Synopsis

Delete local workspace

```
rad workspace delete [flags]
```

### Examples

```
# Delete current workspace
rad workspace delete

# Delete named workspace
rad workspace delete my-workspace
```

### Options

```
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

* [rad workspace]({{< ref rad_workspace.md >}})	 - Manage workspaces


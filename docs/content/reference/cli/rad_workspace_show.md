---
type: docs
title: "rad workspace show CLI reference"
linkTitle: "rad workspace show"
slug: rad_workspace_show
url: /reference/cli/rad_workspace_show/
description: "Details on the rad workspace show Radius CLI command"
---
## rad workspace show

Show local workspace

### Synopsis

Show local workspace

```
rad workspace show [flags]
```

### Examples

```
# Show current workspace
rad workspace show

# Show named workspace
rad workspace show my-workspace
```

### Options

```
  -h, --help               help for show
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad workspace]({{< ref rad_workspace.md >}})	 - Manage workspaces


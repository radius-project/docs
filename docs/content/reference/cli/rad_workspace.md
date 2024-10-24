---
type: docs
title: "rad workspace CLI reference"
linkTitle: "rad workspace"
slug: rad_workspace
url: /reference/cli/rad_workspace/
description: "Details on the rad workspace Radius CLI command"
---
## rad workspace

Manage workspaces

### Synopsis

Manage workspaces
		Workspaces allow you to manage multiple Radius platforms and environments using a local configuration file. 
		You can easily define and switch between workspaces to deploy and manage applications across local, test, and production environments.
		

### Examples

```

# Create workspace with no default resource group or environment set
rad workspace create kubernetes myworkspace --context kind-kind
# Create workspace with default resource group and environment set
rad workspace create kubernetes myworkspace --context kind-kind --group myrg --environment myenv

```

### Options

```
  -h, --help               help for workspace
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI
* [rad workspace create]({{< ref rad_workspace_create.md >}})	 - Create a workspace
* [rad workspace delete]({{< ref rad_workspace_delete.md >}})	 - Delete local workspace
* [rad workspace list]({{< ref rad_workspace_list.md >}})	 - List local workspaces
* [rad workspace show]({{< ref rad_workspace_show.md >}})	 - Show local workspace
* [rad workspace switch]({{< ref rad_workspace_switch.md >}})	 - Switch current workspace


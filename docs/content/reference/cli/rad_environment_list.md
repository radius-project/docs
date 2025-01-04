---
type: docs
title: "rad environment list CLI reference"
linkTitle: "rad environment list"
slug: rad_environment_list
url: /reference/cli/rad_environment_list/
description: "Details on the rad environment list Radius CLI command"
---
## rad environment list

List environments

### Synopsis

List environments using the current, or specified workspace.

```
rad environment list [flags]
```

### Examples

```

# List environments
rad env list

```

### Options

```
  -g, --group string       The resource group name
  -h, --help               help for list
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string        config file (default "$HOME/.rad/config.yaml")
  -e, --environment string   The environment name
```

### SEE ALSO

* [rad environment]({{< ref rad_environment.md >}})	 - Manage Radius Environments


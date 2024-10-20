---
type: docs
title: "rad env list CLI reference"
linkTitle: "rad env list"
slug: rad_env_list
url: /reference/cli/rad_env_list/
description: "Details on the rad env list Radius CLI command"
---
## rad env list

List environments

### Synopsis

List environments using the current, or specified workspace.

```
rad env list [flags]
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

* [rad env]({{< ref rad_env.md >}})	 - Manage Radius Environments


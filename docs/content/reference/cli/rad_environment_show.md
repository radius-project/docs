---
type: docs
title: "rad environment show CLI reference"
linkTitle: "rad environment show"
slug: rad_environment_show
url: /reference/cli/rad_environment_show/
description: "Details on the rad environment show Radius CLI command"
---
## rad environment show

Show environment details

### Synopsis

Show environment details. Shows the user's default environment by default.

```
rad environment show [flags]
```

### Examples

```

# Show current environment
rad env show

# Show specified environment
rad env show my-env

# Show specified environment in a specified resource group
rad env show my-env --group my-env

```

### Options

```
  -e, --environment string   The environment name
  -g, --group string         The resource group name
  -h, --help                 help for show
  -o, --output string        output format (supported formats are json, table) (default "table")
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad environment]({{< ref rad_environment.md >}})	 - Manage Radius Environments


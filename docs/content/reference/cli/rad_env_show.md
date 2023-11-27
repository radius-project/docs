---
type: docs
title: "rad env show CLI reference"
linkTitle: "rad env show"
slug: rad_env_show
url: /reference/cli/rad_env_show/
description: "Details on the rad env show Radius CLI command"
---
## rad env show

Show environment details

### Synopsis

Show environment details. Shows the user's default environment by default.

```
rad env show [flags]
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

* [rad env]({{< ref rad_env.md >}})	 - Manage Radius Environments


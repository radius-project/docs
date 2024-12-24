---
type: docs
title: "rad environment delete CLI reference"
linkTitle: "rad environment delete"
slug: rad_environment_delete
url: /reference/cli/rad_environment_delete/
description: "Details on the rad environment delete Radius CLI command"
---
## rad environment delete

Delete environment

### Synopsis

Delete environment. Deletes the user's default environment by default.

```
rad environment delete [flags]
```

### Examples

```

# Delete current environment
rad env delete

# Delete current environment and bypass confirmation prompt
rad env delete --yes

# Delete specified environment
rad env delete my-env

# Delete specified environment in a specified resource group
rad env delete my-env --group my-env

```

### Options

```
  -e, --environment string   The environment name
  -g, --group string         The resource group name
  -h, --help                 help for delete
  -o, --output string        output format (supported formats are json, table) (default "table")
  -w, --workspace string     The workspace name
  -y, --yes                  The confirmation flag
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad environment]({{< ref rad_environment.md >}})	 - Manage Radius Environments


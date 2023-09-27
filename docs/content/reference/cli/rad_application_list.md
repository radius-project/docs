---
type: docs
title: "rad application list CLI reference"
linkTitle: "rad application list"
slug: rad_application_list
url: /reference/cli/rad_application_list/
description: "Details on the rad application list Radius CLI command"
---
## rad application list

List Radius applications

### Synopsis

Lists Radius applications deployed in the resource group associated with the default environment

```
rad application list [flags]
```

### Examples

```

# List applications
rad app list

# List applications in a specific resource group
rad app list --group my-group

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
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad application]({{< ref rad_application.md >}})	 - Manage Radius applications


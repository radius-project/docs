---
type: docs
title: "rad resource show CLI reference"
linkTitle: "rad resource show"
slug: rad_resource_show
url: /reference/cli/rad_resource_show/
description: "Details on the rad resource show Radius CLI command"
---
## rad resource show

Show Radius resource details

### Synopsis

Show details of the specified Radius resource

```
rad resource show [resourceType] [resourceName] [flags]
```

### Examples

```

# show details of a resource in the workspace resource group
rad resource show Radius.Compute/containers orders
rad resource show Radius.Data/redisCaches cache

# show details of a resource in a specified resource group
rad resource show Radius.Compute/containers orders --group my-group

```

### Options

```
  -g, --group string       The resource group name
  -h, --help               help for show
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
  -a, --application string   The application name
      --config string        config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad resource]({{< ref rad_resource.md >}})	 - Manage resources


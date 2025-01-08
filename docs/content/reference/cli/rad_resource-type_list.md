---
type: docs
title: "rad resource-type list CLI reference"
linkTitle: "rad resource-type list"
slug: rad_resource-type_list
url: /reference/cli/rad_resource-type_list/
description: "Details on the rad resource-type list Radius CLI command"
---
## rad resource-type list

List resource resource types

### Synopsis

List resource resource types
		
Resource types are the entities that can be created and managed by Radius such as 'Applications.Core/containers'. Each resource type can define multiple API versions, and each API version defines a schema that resource instances conform to. Resource types can be configured using resource providers.

```
rad resource-type list [flags]
```

### Examples

```

# List all resource types
rad resource-type list
```

### Options

```
  -h, --help               help for list
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad resource-type]({{< ref rad_resource-type.md >}})	 - Manage resource types


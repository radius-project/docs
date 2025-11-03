---
type: docs
title: "rad resource-type delete CLI reference"
linkTitle: "rad resource-type delete"
slug: rad_resource-type_delete
url: /reference/cli/rad_resource-type_delete/
description: "Details on the rad resource-type delete Radius CLI command"
---
## rad resource-type delete

Delete a resource type

### Synopsis

Delete a resource type

Deleting a resource type will delete the specified resource type. For example, deleting 'Applications.Core/containers' will delete that type (but not deployed instances of the type).

The resource type name argument must be a fully qualified resource type name in the format 'ResourceType.Namespace/resourceTypeName' (e.g., 'Radius.Compute/containers').


```
rad resource-type delete [resource-type-name] [flags]
```

### Examples

```

# Delete a resource type (fully qualified name required)
rad resource-type delete Radius.Compute/containers

# Delete a resource type (bypass confirmation)
rad resource-type delete Applications.Core/containers --yes
```

### Options

```
  -h, --help               help for delete
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
  -y, --yes                The confirmation flag
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad resource-type]({{< ref rad_resource-type.md >}})	 - Manage resource types


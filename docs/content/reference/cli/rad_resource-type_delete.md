---
type: docs
title: "rad resource-type delete CLI reference"
linkTitle: "rad resource-type delete"
slug: rad_resource-type_delete
url: /reference/cli/rad_resource-type_delete/
description: "Details on the rad resource-type delete Radius CLI command"
---
## rad resource-type delete

Delete resource provider

### Synopsis

Delete resource provider
		
Resource types are the entities that implement resource types such as 'Applications.Core/containers'. Each resource type can define multiple API versions, and each API version defines a schema that resource instances conform to. Resource providers can be created and deleted by users.

Deleting a resource type will delete all resources of the specified resource type. For example, deleting 'Applications.Core/containers' will delete all containers.

```
rad resource-type delete [resource type] [flags]
```

### Examples

```

# Delete a resource type
rad resource-type delete Applications.Core/containers

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


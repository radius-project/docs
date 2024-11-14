---
type: docs
title: "rad resource-type show CLI reference"
linkTitle: "rad resource-type show"
slug: rad_resource-type_show
url: /reference/cli/rad_resource-type_show/
description: "Details on the rad resource-type show Radius CLI command"
---
## rad resource-type show

Show resource resource type

### Synopsis

Show resource resource type
		
Resource types are the entities that can be created and managed by Radius such as 'Applications.Core/containers'. Each resource type can define multiple API versions, and each API version defines a schema that resource instances conform to. Resource types can be configured using resource providers.

```
rad resource-type show [resource type] [flags]
```

### Examples

```

# Show a resource type
rad resource-type show 'Applications.Core/containers'
```

### Options

```
  -h, --help               help for show
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad resource-type]({{< ref rad_resource-type.md >}})	 - Manage resource types


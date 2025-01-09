---
type: docs
title: "rad resource-type create CLI reference"
linkTitle: "rad resource-type create"
slug: rad_resource-type_create
url: /reference/cli/rad_resource-type_create/
description: "Details on the rad resource-type create Radius CLI command"
---
## rad resource-type create

Create or update a resource type

### Synopsis

Create or update a resource type from a resource provider manifest.
	
	Resource types are user defined types such as 'Mycompany.Messaging/plaid'.
	
	Creating a resource type defines a new type that can be used in applications.
	
	Input can be passed in using a JSON or YAML file using the --from-file option.
	

```
rad resource-type create [input] [flags]
```

### Examples

```

# Create a resource type from YAML file
rad resource-type create myType --from-file /path/to/input.yaml

# Create a resource type from JSON file
rad resource-type create myType --from-file /path/to/input.json

```

### Options

```
  -f, --from-file string   The input file. May be an absolute path or a path relative to the current working directory
  -h, --help               help for create
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad resource-type]({{< ref rad_resource-type.md >}})	 - Manage resource types


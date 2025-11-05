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

Create or update a resource type from a resource type definition file.

Resource types define the resources that Radius can deploy and the API for those resources. They are defined by a name, one or more API versions, and an OpenAPI schema. 

Input can be passed in using a JSON or YAML file using the --from-file option.

The resource type name argument is optional. If specified, only the specified type is created/updated. If not specified, all resource types in the referenced file are created/updated.

The resource type name argument is the simple name (e.g., 'testResources') not the fully qualified name.


```
rad resource-type create [resource-type-name] [flags]
```

### Examples

```

# Create a specific resource type from a YAML file
rad resource-type create myType --from-file /path/to/input.yaml

# Create a specific resource type from a JSON file
rad resource-type create myType --from-file /path/to/input.json

# Create all resource types from a YAML file
rad resource-type create --from-file /path/to/input.yaml
 
# Create all resource types from a JSON file
rad resource-type create --from-file /path/to/input.json

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


---
type: docs
title: "rad resource-provider create CLI reference"
linkTitle: "rad resource-provider create"
slug: rad_resource-provider_create
url: /reference/cli/rad_resource-provider_create/
description: "Details on the rad resource-provider create Radius CLI command"
---
## rad resource-provider create

Create or update a resource provider

### Synopsis

Create or update a resource provider
		
Resource providers are the entities that implement resource types such as 'Applications.Core/containers'. Resource providers can be defined, registered, and unregistered by users.

Creating a resource provider defines new resource types that can be used in applications.

Input can be passed in using a JSON or YAML file using the --from-file option.


```
rad resource-provider create [input] [flags]
```

### Examples

```

# Create a resource provider from YAML file
rad resource-provider create --from-file /path/to/input.yaml

# Create a resource provider from JSON file
rad resource-provider create --from-file /path/to/input.json

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

* [rad resource-provider]({{< ref rad_resource-provider.md >}})	 - Manage resource providers


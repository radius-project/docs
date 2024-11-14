---
type: docs
title: "rad resource create CLI reference"
linkTitle: "rad resource create"
slug: rad_resource_create
url: /reference/cli/rad_resource_create/
description: "Details on the rad resource create Radius CLI command"
---
## rad resource create

Create or update a resource

### Synopsis

Create or update a resource
		
Resources are the primary entities that make up applications.

Input can be passed via the -f flag to specify a file name.

```
rad resource create [resource type] [name] -f [inputfilepath] [flags]
```

### Examples

```

# Create a resource (from file)
rad resource create 'Applications.Core/containers' mycontainer -f /path/to/input.json
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
  -a, --application string   The application name
      --config string        config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad resource]({{< ref rad_resource.md >}})	 - Manage resources


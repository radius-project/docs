---
type: docs
title: "rad resource list CLI reference"
linkTitle: "rad resource list"
slug: rad_resource_list
url: /reference/cli/rad_resource_list/
description: "Details on the rad resource list Radius CLI command"
---
## rad resource list

Lists resources

### Synopsis

List all resources of a specified type. If no resource type is given, lists all resources of any type in an environment or application.

Applications and environments given with '-a/--application' and '-e/--environment' are Radius.Core/applications and Radius.Core/environments resources.
A resource type with no application or environment lists every resource of that type in the resource group, including Applications.* resource types.

```
rad resource list [resourceType] [flags]
```

### Examples

```

# list all resources of a specified type in the resource group
rad resource list Radius.Compute/containers
rad resource list Radius.Data/redisCaches

# list all resources of a specified type in an application
rad resource list Radius.Compute/containers --application icecream-store

# list all resources of a specified type in an application (shorthand flag)
rad resource list Radius.Compute/containers -a icecream-store

# list all resources of a specified type in a specified environment
rad resource list Radius.Compute/containers -e not-default-env

# list all resources of any type in the default environment
rad resource list

# list all resources of any type in a specified environment
rad resource list -e not-default-env

# list all resources of any type in an application
rad resource list -a icecream-store

```

### Options

```
  -a, --application string   The application name
  -e, --environment string   The environment name
  -g, --group string         The resource group name
  -h, --help                 help for list
  -o, --output string        output format (supported formats are json, table) (default "table")
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad resource]({{< ref rad_resource.md >}})	 - Manage resources


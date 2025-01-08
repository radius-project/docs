---
type: docs
title: "rad resource-provider list CLI reference"
linkTitle: "rad resource-provider list"
slug: rad_resource-provider_list
url: /reference/cli/rad_resource-provider_list/
description: "Details on the rad resource-provider list Radius CLI command"
---
## rad resource-provider list

List resource providers

### Synopsis

List resource providers
		
Resource providers are the entities that implement resource types such as 'Applications.Core/containers'. Resource providers can be created and deleted by users.

```
rad resource-provider list [flags]
```

### Examples

```

# List all resource providers
rad resource-provider list
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

* [rad resource-provider]({{< ref rad_resource-provider.md >}})	 - Manage resource providers


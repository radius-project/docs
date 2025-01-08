---
type: docs
title: "rad resource-provider show CLI reference"
linkTitle: "rad resource-provider show"
slug: rad_resource-provider_show
url: /reference/cli/rad_resource-provider_show/
description: "Details on the rad resource-provider show Radius CLI command"
---
## rad resource-provider show

Show resource provider

### Synopsis

Show resource provider
		
Resource providers are the entities that implement resource types such as 'Applications.Core/containers'. Resource providers can be created and deleted by users.

```
rad resource-provider show [resource provider namespace] [flags]
```

### Examples

```

# Show a resource provider
rad resource-provider show Applications.Core
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

* [rad resource-provider]({{< ref rad_resource-provider.md >}})	 - Manage resource providers


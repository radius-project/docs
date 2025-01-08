---
type: docs
title: "rad resource-provider delete CLI reference"
linkTitle: "rad resource-provider delete"
slug: rad_resource-provider_delete
url: /reference/cli/rad_resource-provider_delete/
description: "Details on the rad resource-provider delete Radius CLI command"
---
## rad resource-provider delete

Delete resource provider

### Synopsis

Delete resource provider
		
Resource providers are the entities that implement resource types such as 'Applications.Core/containers'. Resource providers can be created and deleted by users.

Deleting a resource provider will delete all resource types that it defines. For example, deleting 'Applications.Core' will delete 'Applications.Core/containers' and all other resource types defined by 'Applications.Core'.

Deleting a resource type will delete all resources of the types. For example, deleting 'Applications.Core/containers' will delete all containers.

```
rad resource-provider delete [resource provider namespace] [flags]
```

### Examples

```

# Delete a resource provider
rad resource-provider delete Applications.Core

# Delete a resource provider (bypass confirmation)
rad resource-provider delete Applications.Core --yes
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

* [rad resource-provider]({{< ref rad_resource-provider.md >}})	 - Manage resource providers


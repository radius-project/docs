---
type: docs
title: "rad group switch CLI reference"
linkTitle: "rad group switch"
slug: rad_group_switch
url: /reference/cli/rad_group_switch/
description: "Details on the rad group switch Radius CLI command"
---
## rad group switch

Switch default resource group scope

### Synopsis

Switch default resource group scope
	
	Radius workspaces contain a resource group scope, where Radius Applications and resources are deployed by default. The switch command changes the default scope of the workspace to the specified resource group name.
	
	Resource groups are used to organize and manage Radius resources. They often contain resources that share a common lifecycle or unit of deployment.
			
	Note that these resource groups are separate from the Azure cloud provider and Azure resource groups configured with the cloud provider.

```
rad group switch resourcegroupname [flags]
```

### Examples

```
rad group switch rgprod -w wsprod
```

### Options

```
  -g, --group string       The resource group name
  -h, --help               help for switch
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad group]({{< ref rad_group.md >}})	 - Manage resource groups


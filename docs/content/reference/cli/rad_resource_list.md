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

List all resources of specified type

```
rad resource list [resourceType] [flags]
```

### Examples

```

	sample list of resourceType: containers, gateways, pubSubBrokers, extenders, mongoDatabases, rabbitMQMessageQueues, redisCaches, sqlDatabases, stateStores, secretStores

	# list all resources of a specified type in the default environment

	rad resource list containers
	rad resource list gateways

	# list all resources of a specified type in an application
	rad resource list containers --application icecream-store
	
	# list all resources of a specified type in an application (shorthand flag)
	rad resource list containers -a icecream-store
	
```

### Options

```
  -a, --application string   The application name
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


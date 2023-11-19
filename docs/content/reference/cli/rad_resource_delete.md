---
type: docs
title: "rad resource delete CLI reference"
linkTitle: "rad resource delete"
slug: rad_resource_delete
url: /reference/cli/rad_resource_delete/
description: "Details on the rad resource delete Radius CLI command"
---
## rad resource delete

Delete a Radius resource

### Synopsis

Deletes a Radius resource with the given name

```
rad resource delete [resourceType] [resourceName] [flags]
```

### Examples

```
		sample list of resourceType: containers, gateways, httpRoutes, daprPubSubBrokers, extenders, mongoDatabases, rabbitMQMessageQueues, redisCaches, sqlDatabases, daprStateStores, daprSecretStores

		# Delete a container named orders
		rad resource delete containers orders
```

### Options

```
  -g, --group string       The resource group name
  -h, --help               help for delete
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
  -y, --yes                The confirmation flag
```

### Options inherited from parent commands

```
  -a, --application string   The application name
      --config string        config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad resource]({{< ref rad_resource.md >}})	 - Manage resources


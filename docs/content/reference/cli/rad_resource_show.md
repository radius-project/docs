---
type: docs
title: "rad resource show CLI reference"
linkTitle: "rad resource show"
slug: rad_resource_show
url: /reference/cli/rad_resource_show/
description: "Details on the rad resource show Radius CLI command"
---
## rad resource show

Show Radius resource details

### Synopsis

Show details of the specified Radius resource

```
rad resource show [resourceType] [resourceName] [flags]
```

### Examples

```

sample list of resourceType: Applications.Core/containers, Applications.Core/gateways, Applications.Dapr/daprPubSubBrokers, Applications.Core/extenders, Applications.Datastores/mongoDatabases, Applications.Messaging/rabbitMQMessageQueues, Applications.Datastores/redisCaches, Applications.Datastores/sqlDatabases, Applications.Dapr/daprStateStores, Applications.Dapr/daprSecretStores

# show details of a specified resource in the default environment

rad resource show applications.core/containers orders
rad resource show applications.core/gateways orders_gateways

# show details of a specified resource in an application
rad resource show applications.core/containers orders --application icecream-store

# show details of a specified resource in an application (shorthand flag)
rad resource show applications.core/containers orders -a icecream-store 

```

### Options

```
  -g, --group string       The resource group name
  -h, --help               help for show
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


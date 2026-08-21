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

```
rad resource list [resourceType] [flags]
```

### Examples

```

sample list of resourceType: Applications.Core/containers, Applications.Core/gateways, Applications.Dapr/daprPubSubBrokers, Applications.Core/extenders, Applications.Datastores/mongoDatabases, Applications.Messaging/rabbitMQMessageQueues, Applications.Datastores/redisCaches, Applications.Datastores/sqlDatabases, Applications.Dapr/daprStateStores, Applications.Dapr/daprSecretStores

# list all resources of a specified type in the default environment

rad resource list Applications.Core/containers
rad resource list Applications.Core/gateways

# list all resources of a specified type in an application
rad resource list Applications.Core/containers --application icecream-store

# list all resources of a specified type in an application (shorthand flag)
rad resource list Applications.Core/containers -a icecream-store

# list all resources of a specified type in a specified environment
rad resource list Applications.Core/containers -e not-default-env

# list all resources of any type in the default environment
rad resource list

# list all resources of any type in a specified environment
rad resource list -e not-default-env

# list all resources of any type in an application
rad resource list -a icecream-store

# list preview resources in a Radius.Core environment or application
rad resource list -e not-default-env --preview
rad resource list -a icecream-store --preview

```

### Options

```
  -a, --application string   The application name
  -e, --environment string   The environment name
  -g, --group string         The resource group name
  -h, --help                 help for list
  -o, --output string        output format (supported formats are json, table) (default "table")
      --preview              Use the Radius.Core preview implementation (can also be set via RADIUS_PREVIEW=true)
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad resource]({{< ref rad_resource.md >}})	 - Manage resources


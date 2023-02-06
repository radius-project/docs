---
type: docs
title: "Radius Recipes"
linkTitle: "Recipes"
description: "Learn about Radius recipes and how to create and connect them to your environments"
weight: 30
---

{{% alert title="Warning" color="warning" %}}
Recipes are a work-in-progress, currently we support the following Links: [MongoDb]({{< ref mongodb >}}), [Redis]({{< ref redis >}})
{{% /alert %}}


Recipes enables  **separation of concerns** between infrastructure teams and developers by allowing for a **automated infrastructure deployment** that doesn't require developers to pick up infrastructure resource expertise.
Recipe is a bicep template stored in container registry that can be deployed by [Links]({{< ref links-concept >}}) once a Recipe has been registered in a Radius environment. 

## Recipe features

### Recipe Template Parameters

| Feature | Description | Example |
|---------|-------------|------------|
| `context` | The `context` parameter is an object that contains information about the Link calling the recipe and is passed to a template automatically by Radius. The following properties can be found: `resource`, `application`, `environment`, `runtime` | `param context object` |
| **Custom Parameters** | Any [parameter type supported by Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters) can be placed in your template to allow for developers or custom Radius environments to overwrite. |  `param <parameter-name> <parameter-data-type> = <default-value>` |

### Recipe Output Parameters

Recipe templates allow users **2** possible returnable objects `value` and `resource`.

{{< tabs Value Resource  >}}

{{% codetab %}}
Any property utilized in [Link schemas]({{< ref link-schema >}}) can be added to a `value` object as a property.

#### Example
```bicep
output values object = {
  host: memoryDBCluster.properties.ClusterEndpoint.Address
  port: memoryDBCluster.properties.ClusterEndpoint.Port
  connectionString: 'redis://${memoryDBCluster.properties.ClusterEndpoint.Address}:${memoryDBCluster.properties.ClusterEndpoint.Port}'
  password: ''
}
```
{{% /codetab %}}
{{% codetab %}}

You can output an object that references a Bicep resource.

#### Example
```bicep
output resource string = memoryDBCluster.id
```
{{% /codetab %}}
{{< /tabs >}}


## Example

### How to author a recipe template

### How to publish a recipe template

### How to register a recipe
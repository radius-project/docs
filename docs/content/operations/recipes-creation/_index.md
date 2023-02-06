---
type: docs
title: "Radius Recipes"
linkTitle: "Recipes"
description: "Learn how to automate infrastructure deployment with Recipes"
weight: 30
---

{{% alert title="Warning" color="warning" %}}
Recipes are a work-in-progress, currently we support the following Links: [Redis]({{< ref redis >}})
{{% /alert %}}


Recipes enables  **separation of concerns** between infrastructure teams and developers by allowing for a **automated infrastructure deployment** that doesn't require developers to pick up infrastructure resource expertise.

## Recipe features

### Recipe Template Parameters


#### Create **unique** and **repeatable** infrastructure

 You can leverage the `context` parameter which contains information about the Link deploying the recipe and is passed automatically by the Radius server in order to have multiple Links relying on a Recipe. The following metadata can be found and leveraged in the `context` parameter:


| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `resource` | object | An object containing information on the resource 
| `application` | object | An object containing information on the application the resource belongs to
| `environment` | object | An object containing information on the environment the resource belongs to
| `runtime` | object | An object containing information on the underlying runtime


#### Customize Recipes on demand

You can create any [parameter type supported by Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters) for your Recipe to allow for developers or custom Radius environments to overwrite.   

```bicep
param <parameter-name> <parameter-data-type> = <default-value>` 
```

### Recipe Output Parameters

Recipes allow users **2** possible returnable objects `value` and `resource`.

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

If you specify both `values` and `resource` objects, any configuration inside the `values` object will override what is set by the `resource` object.

## Author a Recipe

### Create a Bicep file

You can turn any valid Bicep file into a Recipe by setting up the following structure in your file:

```bicep
param context object

// YOUR INFRASTRUCTURE RESOURCES
...

output values object = {
  host: ...
  port: ...
}
```


### Store your Bicep file in a OCI compliant registry

Make sure your Cloud provider configured in your Radius environment pull permissions for your container registry.

Example:
```
az bicep publish --file <YOUR-FILENAME>.bicep --target
```

### Register your Recipe with your Radius environment

```
rad recipe register --name <NAME-OF-RECIPE> -e <ENV-NAME> -w <WORKSPACE-NAME> --template-path <PATH-TO-FILE-IN-REGISTRY> --link-type Applications.Link/<LINK-TYPE>
```

## Further reading
- Visit the Recipe developer guide for more information.
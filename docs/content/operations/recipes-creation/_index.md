---
type: docs
title: "Author Custom Radius Recipes"
linkTitle: "Author Recipes"
description: "Learn how to author custom Recipe templates to automate infrastructure deployment"
weight: 30
---

Recipes enable a **separation of concerns** between infrastructure teams and developers by **automating infrastructure deployment**.

Learn more in the Recipes overview page:

{{< button page="recipes" text="Recipes overview" >}}

## Author a custom Recipe

This page will describe how to author and publish a custom Recipe template, letting you define how infrastructure should be deployed and configured within your environment.

### Select an Infrastructure as Code language

Today, Recipes only support the Bicep IaC language. Your custom Recipe template will begin with a new Bicep file, which will contain all of the resources you want to automatically deploy for each resource that runs the Recipe.


### Ensure your resource names are **unique** and **repeatable**
Recipe will be called by multiple many resources and need to be generalized templates. The resources inside of a Recipe cannot interfere or overwrite each other. To make sure you don't accidently overwrite or corrupt your infrastructure, you will want to make sure **each resource in your Recipe contains unique names**.
Additionally, every time an application is deployed, Recipes are re-evaluated and deployed. Because IaC languages like Bicep are idempotent, if there are no changes to the template then nothing is re-deployed or re-configured. To make sure Recipes can be re-run, **each resource needs a repeatable name that is the same every time it is deployed**.
To make naming easy, a `context` parameter is automatically injected into your template.
It contains information about the backing resource which you can use to generate unique and repeatable names:


| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `resource` | object | An object containing information on the resource 
| `application` | object | An object containing information on the application the resource belongs to
| `environment` | object | An object containing information on the environment the resource belongs to
| `runtime` | object | An object containing information on the underlying runtime


#### Customize Recipes on demand

You can create any [parameter type supported by Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters) for your Recipe to allow for developers or custom Radius environments to overwrite.   

```bicep
@description('A custom parameter that can be set by a developer or operator')
param myParam string = 'default value'` 
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
---
type: docs
title: "Tutorial: Use a Composite Recipe"
linkTitle: "Composite Recipes"
description: "Learn how to create a composite recipe for a custom resource type"
weight: 201
categories: ["Tutorial"]
---
## Overview

This tutorial introduces composite Recipes. Rather than being composed of infrastructure or cloud resources like typical Recipes, composite Recipes are composed of other Radius resource types. Composite Recipes are authored in Bicep and can include any Radius resource types including built-in types, other custom types, AWS types, and/or Azure types. 

The previous tutorial demonstrated how to define a custom resource type for a PostgreSQL database, author a Recipe for deploying the database on Kubernetes, and adding the new Resource Type to an application. The sample Todo List application used the built-in Containers resource type for the frontend service. This tutorial continues using the same application but extends the Containers resource type with additional functionality.

{{< image src="images/todolist.png" alt="Diagram of the Todo List application with using a web service" width=600px >}}

This tutorial demonstrates:

* Creating a web service custom resource type which adds an `ingress` property to the Containers schema
* Creating a composite Recipe in Bicep which creates a Gateway resource when the ingress property is true
* Modifying the Todo List application to use the new web service

## Prerequisites

This tutorial assumes you have completed the previous tutorials in this section and have Radius installed and configured. 

Composite Recipes are only written in Bicep. If you used Terraform in the previous tutorial for your Recipes, you will need an OCI registry to store your Recipe. While Terraform-based Recipes are stored in Git, Bicep-based Recipes can only be published to OCI registry.

## Step 1: Create the web service resource type

Create or modify the `types.yaml` file so that it has both the `postgreSQL` type from the previous tutorial and the new `webServices` type. The schema for the new web services resource type is lengthy, so it is best to download the fully prepared file with both resource types.

{{< button text="Download types.yaml" link="snippets/types.yaml" newtab="true" >}}

This web services schema is simpler than it appears:

* `environment` and `application`, and `connections` have the same purpose as in the previous PostgreSQL example. These properties are on all resource types.
* `ingress` is the first property the developer can set. The purpose of this property is to expose an option for developers to specify if the web service is accessible to connections from outside the cluster. This functionality will be implemented in the Recipe in step 3. 
* `container` is a duplication of the Containers schema. Since the web service resource type extended Containers, the original schema must be included here. As you will see when implementing the Recipe, duplicating the Containers schema exactly makes it simple to pass multiple properties in only a few lines of code.

Create the resource type using the [rad resource-type create]({{< ref rad_resource-type_create >}}) command.

```bash
rad resource-type create webServices -f types.yaml
```

You should see output similar to:

```bash
$ rad resource-type create webServices -f types.yaml
Resource provider "Radius.Resources" found. Registering resource type "webServices".
Creating resource type Radius.Resources/webServices with capabilities SupportsRecipes 
Creating API Version Radius.Resources/webServices@2023-10-01-preview
Updating location Radius.Resources/global with new resource type
Resource type Radius.Resources/webServices created successfully

TYPE                          NAMESPACE         APIVERSION
Radius.Resources/webServices  Radius.Resources  ["2023-10-01-preview"]
```

You can confirm the resource type was created using `rad resource-type list` command.

## Step 2: Update the Bicep extension

The `rad resource-type create` command created the resource type in the Radius control plane. The next step is to create a Bicep extension which will be used by the Radius CLI and VS Code (if you have the Bicep VS Code extension installed).

Generate the Bicep extension using the [rad bicep publish-extension]({{< ref rad_bicep_publish-extension >}}) command.

```bash
rad bicep publish-extension -f types.yaml --target radiusResources.tgz
```
In the previous tutorial, you modified the `bicepconfig.json` file which is a one time change. If you skipped the previous tutorial, modify the `bicepconfig.json` file by adding the highlighted line.

{{< rad file="snippets/bicepconfig.json" lang=json embed=true markdownConfig="{linenos=table,hl_lines=[\"8\"]}" >}}

## Step 3: Create, publish, and register the Composite Recipe

The previous tutorial demonstrated deploying a resource using Terraform or Bicep resource providers such as the Kubernetes provider. This tutorial creates a Composite Recipes which uses only built-in Radius types. 

Create a new file called `webServices.bicep` and add the following:

{{% rad file="snippets/webServices.bicep" embed=true %}}

Notice that the `container` and `connections` properties are passed to the `Applications.Core/containers` built-in type using a single line.

Publish the Recipe to an OCI registry. Make sure to replace `host` and `registry` with your container registry.

```bash
rad bicep publish --file webServices.bicep --target br:<host>/<registry>/webServices:latest
```

Register the Bicep template as the `default` Recipe in the `default` environment.

```bash
rad recipe register default --environment default --resource-type Radius.Resources/webServices --template-kind bicep --template-path <host>/<registry>/webServices:latest
```

You can confirm the Recipe was registered using `rad recipe list` command.

## Step 4: Modify the Todo List application

Using the same `todolist.bicep` application definition from the previous tutorial, change the resource type for the `frontend` resource from `Applications.Core/containers` to `Radius.Resources/webServices`.

```bicep
resource frontend 'Radius.Resources/webServices@2023-10-01-preview' = {
  name: 'frontend'
```

Run the application using `rad run`. 

```sh
rad run todolist.bicep --application todolist
```

Visit the application at [http://localhost:3000](http://localhost:3000) and confirm the application is running exactly as in the previous tutorial.

## Step 5: Enable ingress on the application

Up to this point, port forwarding had to be used to access the application. Radius has built-in capabilities for managing ingress external connections to the application using the [Gateway]({{< ref Gateways >}}) resource.

Now that the application is using the new web service resource type, modify the application again and enable the `ingress` option.

```bicep
resource frontend 'Radius.Resources/webServices@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: todolist.id
    ingress: true
```



Run the application. But this time, use `rad deploy`. Since the application has a Gateway resource now, the application can be accessed directly without port forwarding.

```bash
rad deploy todolist.bicep
```

Once the deployment completes, use the `rad resource show` command to get the URL of the application.

```bash
rad resource show Applications.Core/gateways gateway -o json | grep url
```

Open the URL in your browser.

{{% alert title="Warning" color="warning" %}}
The application will only be accessible if the Kubernetes cluster you are using has a load balancer controller. If you are using AKS or EKS, the controller is enabled by default. If you are using a local Kubernetes cluster such as kind or k3d, you will need to configure a load balancer controller. See this tutorial for [k3d](https://k3d.io/v5.3.0/usage/exposing_services/) and this for [kind](https://kind.sigs.k8s.io/docs/user/loadbalancer).
{{% /alert %}}

## Step 6: Clean up

To clean up the resources created in this tutorial, run the following commands

Delete the application and all resources created by the application.

```bash
rad application delete todolist
```

Delete the environment.

```bash
rad environment delete default
```

Delete the resource group.

```bash
rad group delete default
```

Delete the PostgreSQL and web service resource types.

```bash
rad resource-type delete Radius.Resources/postgreSQL
rad resource-type delete Radius.Resources/webServices
```

Uninstall Radius.

```bash
rad uninstall kubernetes
```
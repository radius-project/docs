---
type: docs
title: "Tutorial: Create a composite Recipe"
linkTitle: "Create a composite Recipe"
description: "Learn how to create a composite recipe for a custom resource type"
weight: 140
categories: ["Tutorial"]
---
## Overview

This tutorial introduces composite Recipes. Rather than being composed of infrastructure or cloud resources like typical Recipes, composite Recipes are composed of other Radius resource types. Composite Recipes are authored in Bicep and can include any Radius resource types including built-in types, other custom types, AWS types, and/or Azure types. 

The previous tutorial demonstrated how to define a custom resource type for a PostgreSQL database, author a Recipe for deploying the database on Kubernetes, and adding the new Resource Type to an application. The sample Todo List application used the built-in Containers resource type for the frontend service. This tutorial continues using the same application but extends the Containers resource type with additional functionality.

This tutorial demonstrates:

* Creating a web service custom resource type which adds an `ingress` property to the Containers schema
* Creating a composite Recipe in Bicep which creates a Gateway resource when the ingress property is true
* Modifying the Todo List application to use the new web service

{{< image src="tutorial3.png" alt="Diagram of the Todo List application with using a web service" width=600px >}}

## Prerequisites

This tutorial assumes you have completed the [Add a custom resource type]({{< ref "/tutorials/custom-resource-type" >}}) tutorial and have the demo application deployed with a PostgreSQL database. this section and have Radius installed and configured. 

Composite Recipes are only written in Bicep. If you used Terraform in the previous tutorial for your Recipes, you will need an OCI registry to store your Recipe. While Terraform-based Recipes are stored in Git, Bicep-based Recipes can only be published to OCI registry.

## Step 1: Create the web service resource type

Create or modify the `types.yaml` file so that it has both the `postgreSQL` type from the previous tutorial and the new `webServices` type. The schema for the new web services resource type is lengthy, so it is best to download the fully prepared file with both resource types.

{{< button text="Download types.yaml" link="snippets/types.yaml" newtab="true" >}}

This web services schema is simpler than it appears:

* `environment` and `application` have the same purpose as in the previous PostgreSQL example. These properties are on all resource types.
* `connections` is used to create dependencies, see [How-To: Connect to dependencies]({{< ref "guides/author-apps/containers/howto-connect-dependencies" >}}) for more details
* `ingress` is the first property the developer can set. The purpose of this property is to expose an option for developers to specify if the web service is accessible to connections from outside the cluster. This functionality will be implemented in the Recipe in step 3. 
* `container` is a duplication of the Containers schema. Since the web service resource type extended Containers, the original schema must be included here. As you will see when implementing the Recipe, duplicating the Containers schema exactly makes it simple to pass multiple properties in only a few lines of code.

Create the resource type using the [rad resource-type create]({{< ref rad_resource-type_create >}}) command.

```bash
rad resource-type create webServices -f types.yaml
```
You can confirm the resource type was created using `rad resource-type list` command.

## Step 2: Update the Bicep extension

Generate the Bicep extension using the [rad bicep publish-extension]({{< ref rad_bicep_publish-extension >}}) command.

```bash
rad bicep publish-extension -f types.yaml --target radiusResources.tgz
```

Since the `bicepconfig.json` file was modified in the previous tutorial, it does not need to be further modified.

## Step 3: Create, publish, and register the composite Recipe

The previous tutorial demonstrated deploying a resource using Terraform or Bicep resource providers such as the Kubernetes provider. This tutorial creates a composite Recipes which uses only built-in Radius types. These composite Recipes are only possible using Bicep.

1. Create a new file called `webservices.bicep` and add the following:

   {{% rad file="snippets/webservices.bicep" lang="bicep" embed=true %}}

   Notice that the `container` and `connections` properties are passed to the `Applications.Core/containers` built-in type using a single line.

1. Publish the Recipe to an OCI registry. Make sure to replace `host` and `registry` with your container registry.

   ```bash
   rad bicep publish --file webservices.bicep --target br:<host>/<registry>/webservices:latest
   ```

1. Register the Bicep template as the `default` Recipe in the `default` environment.

   ```bash
   rad recipe register default --environment default \
     --resource-type Radius.Resources/webServices \
     --template-kind bicep \
     --template-path <host>/<registry>/webservices:latest
   ```

   You can confirm the Recipe was registered using `rad recipe list` command.

## Step 4: Replace the container resource with a web service

1. Using the same `app.bicep` file, change the resource type for the `demo` resource from `Applications.Core/containers` to `Radius.Resources/webServices`.

   ```diff
   - resource demo 'Applications.Core/containers@2023-10-01-preview' = {
   + resource demo 'Radius.Resources/webServices@2023-10-01-preview' = {
   ```

1. Add `ingress: true` to the demo resource so that a Gateway gets deployed as part of the web service. The web service also needs an environment property similar to the database custom resource.

   ```diff
   resource demo 'Radius.Resources/webServices@2023-10-01-preview' = {
     name: 'demo'
       properties: {
         application: application
   +     environment: environment
   +     ingress: true
   ```

1. Since the web service resource type has a build-in Gateway, remove the Gateway resource.

   ```diff
   - resource gateway 'Applications.Core/gateways@2023-10-01-preview' = {
   -   name: 'gateway'
   -   properties: {
   -     application: application
   -     routes: [
   -       {
   -         path: '/'
   -         destination: 'http://demo:3000'
   -       }
   -     ]
   -   }
   - }
   ```

1. Run the application using `rad run`. 

   ```bash
   rad deploy app.bicep
   ```

1. Unlike before, the Gateway URL is not automatically shown. Use the `rad resource show` command to get the URL of the application. 

   ```bash
   rad resource show Applications.Core/gateways gateway -o json | grep url
   ```

1. Open the URL in your browser.

## Step 6: Clean up

1. Delete the application and all resources created by the application.

   ```bash
   rad application delete todolist
   ```

1. Delete the environment.

   ```bash
   rad environment delete default
   ```

1. Delete the resource group.

   ```bash
   rad group delete default
   ```

1. Delete the PostgreSQL and web service resource types.

   ```bash
   rad resource-type delete Radius.Resources/postgreSQL
   rad resource-type delete Radius.Resources/webServices
   ```

1. Delete the default workspace

   ```bash
   rad workspace delete default
   ```

1. Uninstall Radius.

   ```bash
   rad uninstall kubernetes
   ```

1. Delete the `radius-system` namespace

   ```bash
   kubectl delete namespace radius-system
   ```

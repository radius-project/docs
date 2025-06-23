---
type: docs
title: "Tutorial: Create a composite Recipe"
linkTitle: "Create a composite Recipe"
description: "Learn how to create a composite recipe"
weight: 140
categories: ["Tutorial"]
---
## Overview

This tutorial introduces composite Recipes. Rather than being composed of infrastructure or cloud resources like typical Recipes, composite Recipes are composed of other Radius resource types. Composite Recipes are authored in Bicep and can include any Radius resource types including built-in types and types you have defined.

The previous tutorial demonstrated how to define a resource type for a PostgreSQL database, author a Recipe for deploying the database on Kubernetes, and adding the new Resource Type to an application. The sample Todo List application used the built-in Containers resource type for the frontend service. This tutorial continues using the same application but extends the Containers resource type with additional functionality.

This tutorial demonstrates:

* Creating a web service resource type which adds an `ingress` property to the Containers schema
* Creating a composite Recipe in Bicep which creates a Gateway resource when the ingress property is true
* Modifying the Todo List application to use the new web service

{{< image src="tutorial3.png" alt="Diagram of the Todo List application with using a web service" width=600px >}}

## Prerequisites

This tutorial assumes you have completed the [Create a resource type]({{< ref "/tutorials/create-resource-type" >}}) tutorial and have the demo application deployed with a PostgreSQL database and have Radius installed and configured. 

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

```
$ rad resource-type create webServices -f types.yaml
Resource provider "Radius.Resources" found. Registering resource type "webServices".
Creating resource type Radius.Resources/webServices with capabilities SupportsRecipes 
Creating API Version Radius.Resources/webServices@2023-10-01-preview
Updating location Radius.Resources/global with new resource type
Resource type Radius.Resources/webServices created successfully

TYPE                          NAMESPACE         APIVERSION
Radius.Resources/webServices  Radius.Resources  ["2023-10-01-preview"]
```

You can confirm the resource type was created using [`rad resource-type list`]({{< ref rad_resource-type_list >}}) command.

```bash
rad resource-type list
```

```
$ rad resource-type list
TYPE                                    NAMESPACE                APIVERSION
...
Radius.Resources/postgreSQL             Radius.Resources         ["2023-10-01-preview"]
Radius.Resources/webServices            Radius.Resources         ["2023-10-01-preview"]
```

## Step 2: Update the Bicep extension

Generate the Bicep extension using the [rad bicep publish-extension]({{< ref rad_bicep_publish-extension >}}) command.

```bash
rad bicep publish-extension -f types.yaml --target radiusResources.tgz
```
```
$ rad bicep publish-extension -f types.yaml --target radiusResources.tgz
Writing types to /var/folders/w8/89pqzjp52pbg4g256z9cpkww0000gn/T/bicep-extension-542196227/types.json
Writing index to /var/folders/w8/89pqzjp52pbg4g256z9cpkww0000gn/T/bicep-extension-542196227/index.json
Writing documentation to /var/folders/w8/89pqzjp52pbg4g256z9cpkww0000gn/T/bicep-extension-542196227/index.md
WARNING: The 'publish-extension' CLI command group is an experimental feature. Experimental features should be enabled for testing purposes only, as there are no guarantees about the quality or stability of these features. Do not enable these settings for any production usage, or your production environment may be subject to breaking.
Successfully published Bicep extension "types.yaml" to "radiusResources.tgz"
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
   ```
   $ rad bicep publish --file webservices.bicep --target br:<host>/<registry>/tutorial/webservices:latest
   Building webservices.bicep...
   WARNING: The following experimental Bicep features have been enabled: Extensibility. Experimental features should be enabled for testing purposes only, as there are no guarantees about the quality or stability of these features. Do not enable these settings for any production usage, or your production environment may be subject to breaking.
   Pushed to <host>/<registry>/webservices@...

   Successfully published Bicep file "webservices.bicep" to "<host>/<registry>/tutorial/webservices:latest"
    ```

1. Register the Bicep template as the `default` Recipe in the `default` environment.

   ```bash
   rad recipe register default --environment default \
     --resource-type Radius.Resources/webServices \
     --template-kind bicep \
     --template-path <host>/<registry>/webservices:latest
   ```
   ```
   Successfully linked recipe "default" to environment "default" 
   ```

   You can confirm the Recipe was registered using `rad recipe list` command.

   ```bash
   rad recipe list
   ```
   ```
    rad recipe list                                    
    RECIPE    TYPE                                    TEMPLATE KIND  TEMPLATE VERSION  TEMPLATE
    ...
    default   Radius.Resources/webServices            bicep                            <host>/<registry>/webservices:latest
    default   Radius.Resources/postgreSQL             terraform                        git::https://github.com/<github-user-name>/recipes.git//kubernetes/postgres
    ...
    ```

## Step 4: Replace the container resource with a web service

1. Using the same `app.bicep` file, change the resource type for the `demo` resource from `Applications.Core/containers` to `Radius.Resources/webServices`.

   ```diff
   - resource demo 'Applications.Core/containers@2023-10-01-preview' = {
   + resource demo 'Radius.Resources/webServices@2023-10-01-preview' = {
   ```

1. Add `ingress: true` to the demo resource so that a Gateway gets deployed as part of the web service. The web service also needs an environment property similar to the PostgreSQL resource.

   ```diff
   resource demo 'Radius.Resources/webServices@2023-10-01-preview' = {
     name: 'demo'
       properties: {
         application: application
   +     environment: environment
   +     ingress: true
   ```

1. Since the web service resource type has a built-in Gateway, remove the Gateway resource.

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

1. Run the application using `rad deploy`. 

    ```bash
    rad deploy app.bicep
    ```
    ```
    $ rad deploy app.bicep
    Building app.bicep...
    WARNING: The following experimental Bicep features have been enabled: Extensibility. Experimental features should be enabled for testing purposes only, as there are no guarantees about the quality or stability of these features. Do not enable these settings for any production usage, or your production environment may be subject to breaking.
    Deploying template 'app.bicep' for application 'todolist' and environment '/planes/radius/local/resourceGroups/default/providers/Applications.Core/environments/default' from workspace 'default'...

    Deployment In Progress... 

    Completed            postgresql      Radius.Resources/postgreSQL
    Completed            backend         Applications.Core/containers
    Completed            demo            Radius.Resources/webServices

    Deployment Complete

    Resources:
        backend         Applications.Core/containers
        postgresql      Radius.Resources/postgreSQL
        demo            Radius.Resources/webServices
    ```

1. Unlike before, the Gateway URL is not automatically shown. Use the `rad resource show` command to get the URL of the application. 

   ```bash
   rad resource show Applications.Core/gateways gateway -o json | grep url
   ```
   ```
   "url": "http://gateway.todolist.172.18.0.6.nip.io"
   ```

1. Open the URL in your browser. The application has not changed despite changing the demo from a container to a web service resource and removing the gateway.

## Step 6: Clean up

1. Delete the application and all resources created by the application.

   ```bash
   rad application delete todolist
   ```

1. Delete the PostgreSQL and web service resource types.

   ```bash
   rad resource-type delete Radius.Resources/postgreSQL
   rad resource-type delete Radius.Resources/webServices
   ```
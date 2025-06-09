---
type: docs
title: "Tutorial: Create a resource type"
linkTitle: "Create a resource type"
description: "Learn how to define and deploy a resource type in your Radius application"
weight: 120
categories: ["Tutorial"]
---

## Overview

Radius includes several built-in resource types which developers can use to build applications. These include resource types such as Containers, Gateways, and Secrets. You can also create your own resource types. This tutorial guides you through creating a PostgreSQL resource and deploying the sample Todo List application with PostgreSQL.

{{< image src="tutorial2.png" alt="Diagram of the Todo List with PostgreSQL" width=600px >}}

## Prerequisites

This tutorial assumes you have completed the [Create a new application]({{< ref "/tutorials/new-app" >}}) tutorial and have Radius installed and the demo application deployed. 

Additionally, you will need a location to store your Recipe:

  - **Terraform** configurations must be stored in a Git repository. Ideally for this tutorial the Git repository has anonymous access. If not, you will need to configure [Git authentication]({{< ref "guides/recipes/terraform/howto-private-registry" >}}).
  
  - **Bicep** templates must be stored in an OCI registry. As with Git, you must have anonymous access to the registry or configure [authentication]({{< ref "guides/recipes/howto-private-bicep-registry" >}}).

Finally, [Node.js](https://nodejs.org/en/download) must be installed on the workstation to generate the Bicep extension to deploy the new resource type. 

<!-- TODO: Add option for users to skip the need for an OCI registry or Git repository for their recipe by showing a `rad recipe register` command which includes a reference to an already deployed recipe in the Radius project.  -->

## Step 1: Create a PostgreSQL resource type in Radius

To create a PostgreSQL resource type in Radius, first create the resource type definition then add the resource type to Radius.

1. Create a new file called `types.yaml` and add the following:

   {{% rad file="snippets/types.yaml" lang=YAML embed=true %}}

   The PostgreSQL resource type definition includes:

    - **`name`**: The namespace of the resource type, as a convention `Radius.Resources` is recommended but any name in the form `PrimaryName.SecondaryName` can be used
    - **`types`**: The resource type name
    - **`capabilities`**: This specifies features of the resource type. The only available option is `SupportsRecipes` which indicates that the resource type can be deployed via a Recipe. 
    - **`apiVersions`**: The version of the schema defined below
    - **`schema`**: The OpenAPI v3 schema which defines the properties of the resource type
        - **`environment`**: The Radius environment ID which the resource is deployed to, this property is set by the Radius CLI when the resource is deployed
        - **`application`**: The application ID which the resource belongs to
        - **`size`**: The size of the PostgreSQL database
        - **`host`**: The hostname of the database server
        - **`port`**: The port of the database server
        - **`username`**: The username
        - **`password`**: The password

    The `host`, `port`, `username`, and `password` properties are read-only properties set by Recipe.

1. Create the resource type using the [rad resource-type]({{< ref rad_resource-type_create >}}) command:

    ```bash
    rad resource-type create postgreSQL -f types.yaml
    ```

   ```
   $ rad resource-type create postgreSQL -f types.yaml 
   Resource provider "Radius.Resources" not found.
   Creating resource provider Radius.Resources at location global
   Creating resource type Radius.Resources/postgreSQL
   Creating API Version Radius.Resources/postgreSQL@2023-10-01-preview
   Creating location Radius.Resources/global/
   ```

## Step 2: Create a Bicep extension

The `rad resource-type create` command created the resource type in the Radius control plane. The next step is to create a Bicep extension which will be used by the Radius CLI and VS Code (if you have the Bicep VS Code extension installed).

{{% alert title="Warning" color="warning" %}}
This step is required even if you use Terraform-based Recipes to deploy the PostgreSQL resource type as part of the application.
{{% /alert %}}

1. Generate the Bicep extension using the [rad bicep publish-extension]({{< ref rad_bicep_publish-extension >}}) command.

   ```bash
   rad bicep publish-extension -f types.yaml --target radiusResources.tgz
   ```
    
   ```
   $ rad bicep publish-extension -f types.yaml --target radiusResources.tgz
   Writing types to /var/folders/w8/89pqzjp52pbg4g256z9cpkww0000gn/T/bicep-extension-2214011863/types.json
   Writing index to /var/folders/w8/89pqzjp52pbg4g256z9cpkww0000gn/T/bicep-extension-2214011863/index.json
   Writing documentation to /var/folders/w8/89pqzjp52pbg4g256z9cpkww0000gn/T/bicep-extension-2214011863/index.md
   WARNING: The 'publish-extension' CLI command group is an experimental feature. Experimental features should be enabled for testing purposes only, as there are no guarantees about the quality or stability of these features. Do not enable these settings for any production usage, or your production environment may be subject to breaking.
   Successfully published Bicep extension "types.yaml" to "radiusResources.tgz"
   ```

1. Open the `bicepconfig.json` file and modify the contents.

    ```diff
    {
        "experimentalFeaturesEnabled": {
            "extensibility": true
        },
        "extensions": {
            "radius": "br:biceptypes.azurecr.io/radius:latest",
    -        "aws": "br:biceptypes.azurecr.io/aws:latest"
    +        "aws": "br:biceptypes.azurecr.io/aws:latest",
    +        "radiusResources": "radiusResources.tgz"
        }
    }
    ```

    The final file should be:

    ```
    {
        "experimentalFeaturesEnabled": {
                "extensibility": true
        },
        "extensions": {
                "radius": "br:biceptypes.azurecr.io/radius:latest",
                "aws": "br:biceptypes.azurecr.io/aws:latest",
                "radiusResources": "radiusResources.tgz"
        }
    }
    ```

    Now, any Bicep template with `extension radiusResources` will reference the `radiusResources.tgz` file for details about the PostgreSQL resource type.

## Step 3: Create a Recipe for the PostgreSQL resource type

[Recipes]({{< ref "/guides/recipes/overview" >}}) define how resource are deployed. Recipes can be either Terraform configurations or Bicep templates. Once the Terraform configuration or Bicep template has been published in a Git repo or OCI registry, it can be registered as a recipe in a Radius environment. 

{{< tabs Terraform Bicep >}}{{% codetab %}} 

Terraform configurations must be stored in a Git repository accessible by Radius. As discussed in the prerequisites, using a Git repository with anonymous access is easiest for this tutorial, otherwise you will need to configure [Git authentication]({{< ref "guides/recipes/terraform/howto-private-registry" >}}). Learn more about Recipes in this [How-to guide]({{< ref "/guides/recipes/howto-author-recipes" >}}). 

1. Create a new directory in your Git repository for the PostgreSQL Terraform module then create the `main.tf` file and add the following:

   {{% rad file="snippets/recipes/terraform/main.tf" embed=true %}}  

    <!--TODO: Replace with button to download like in the composite recipe tutorial. Save the full contents for the Recipe how-to which explains what all of this is.  -->

1. Register the Terraform configuration as a Recipe called `default`. Since Recipes are registered with Environments, use the  `default` environment created in the previous tutorial.

    ```bash
    rad recipe register default \
      --environment default \
      --resource-type Radius.Resources/postgreSQL \
      --template-kind terraform \
      --template-path git::<git-server-name>/<repository-name>.git//<directory>/<subdirectory>
    ```

    For example, if the `main.tf` file is in a GitHub repository named `recipes` in a directory called `/kubernetes/postgresql`, the command would look like this:
    
    ```bash 
      --template-path git::https://github.com/<github-user-name>/recipes.git//kubernetes/postgresql
    ```

    The output will be:

    ```
    Successfully linked recipe "default" to environment "default"
    ```

1. Verify the Recipe is registered using the [`rad recipe list`]({{< ref rad_recipe_list >}}) command. 

    ```bash
    rad recipe list
    ```

    ```
    $ rad recipe list
    RECIPE    TYPE                         TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
    ...
    default   Radius.Resources/postgreSQL  terraform                       git::https://github.com/<github-user-name>/recipes.git//kubernetes/postgres
    ```
    
{{% /codetab %}}
{{% codetab %}}

Bicep templates must be stored in an OCI registry accessible by Radius. As discussed in the prerequisites, using an OCI registry with anonymous access is easiest for this tutorial, otherwise you will need to configure [authentication]({{< ref "guides/recipes/howto-private-bicep-registry" >}}). Learn more about Recipes in this [How-to guide]({{< ref "/guides/recipes/howto-author-recipes" >}}).

1. Create a new file called `postgresql.bicep` and add the following:

   {{% rad file="snippets/recipes/bicep/postgresql.bicep" embed=true %}}

    <!--TODO: Replace with button to download like in the composite recipe tutorial. Save the full contents for the Recipe how-to which explains what all of this is.  -->

1. Publish the Recipe to the OCI registry. Make sure to replace `host` and `registry` with your container registry.

    ```bash
    rad bicep publish --file postgresql.bicep --target br:<host>/<registry>/postgresql:latest
    ```

    ```
    Successfully published Bicep file "postgresql.bicep" to "<host>/<registry>/postgresql:latest"
    ```

1. Register the Bicep template as a Recipe called `default`. Since Recipes are registered with Environments, use the  `default` environment created in the previous tutorial.

    ```bash
    rad recipe register default --environment default \
      --resource-type Radius.Resources/postgreSQL \
      --template-kind bicep \
      --template-path <host>/<registry>/postgresql:latest
    ```

    ```
    Successfully linked recipe "default" to environment "default"
    ```

1. Verify the Recipe is registered using the [`rad recipe list`]({{< ref rad_recipe_list >}}) command. You should see output similar to:

   ```bash
   rad recipe list
   ```

    ```
    $ rad recipe list
    RECIPE    TYPE                         TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
    ...
    default   Radius.Resources/postgreSQL  bicep                           <host>/<repository>/postgresql:latest
    ```

{{% /codetab %}}
{{< /tabs >}}

## Step 4: Replace MongoDB with PostgreSQL

1. Edit the `app.bicep` file from the previous tutorial and add the `radiusResources` extension at the top of the file.
   
    ```diff
    extension radius
    + extension radiusResources
    ```

1. Remove the MongoDB resource and replace it with a PostgreSQL resource.

    ```diff
    - resource mongodb 'Applications.Datastores/mongoDatabases@2023-10-01-preview' = {
    -   name: 'mongodb'
    -   properties: {
    -       environment: environment
    -       application: application
    -   }
    - }
    + resource postgresql 'Radius.Resources/postgreSQL@2023-10-01-preview' = {
    +   name: 'postgresql'
    +   properties: {
    +     environment: environment
    +     application: application
    +     size: 'S'
    +   }
    + }
    ```

1. Modify the `demo` container to use the PostgreSQL. Because PostgreSQL is a custom resource type, the environment variables must be manually specified.

    ```diff
    resource demo 'Applications.Core/containers@2023-10-01-preview' = {
        name: 'demo'
        properties: {
        application: application
        container: {
          image: 'ghcr.io/radius-project/samples/demo:latest'
          ports: {
            web: {
              containerPort: 3000
            }
          }
    +      env: {
    +        CONNECTION_POSTGRES_HOST: {
    +          value: postgresql.properties.host
    +        }
    +        CONNECTION_POSTGRES_PORT: {
    +          value: string(postgresql.properties.port)
    +        }
    +        CONNECTION_POSTGRES_USERNAME: {
    +          value: postgresql.properties.username
    +        }
    +        CONNECTION_POSTGRES_DATABASE: {
    +          value: postgresql.properties.database
    +        }
    +        //This is stored and passed as cleartext for demo purposes. In production, use a secret store.
    +        CONNECTION_POSTGRES_PASSWORD: {
    +          value: postgresql.properties.password
    +        }   
    +      }
        }
        connections: {
    -      mongodb: {
    -        source: mongodb.id
    -      }
    +      postgresql: {
    +        source: postgresql.id
    +   }
          backend: {
            source: 'http://backend:80'
          }
        }
      }
    }
    ```

   {{% alert title="Caution" color="warning" %}}
   In this example the POSTGRESQL_PASSWORD is stored as a cleartext property for demo purposes. In production environments, always use secrets to store and reference sensitive information like passwords.
   {{% /alert %}}

## Step 5: Run the application

Run the application using `rad run`. The `rad run` command sets up port forwarding to the application. .

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
Completed            gateway         Applications.Core/gateways
Completed            demo            Applications.Core/containers

Deployment Complete

Resources:
    backend         Applications.Core/containers
    demo            Applications.Core/containers
    gateway         Applications.Core/gateways
    postgresql      Radius.Resources/postgreSQL

Public Endpoints:
    gateway         Applications.Core/gateways http://gateway.todolist.172.18.0.6.nip.io
```

Open the gateway URL in your browser. The Radius Connections section now has PostgreSQL details and MongoDB is no longer there.

{{< image src="todolist_postgresql.png" alt="Todo List with PostgreSQL connection" width=800px >}}

<br><br>

{{< button text="Next step: Create a composite Recipe →" page="create-composite-recipe" >}}
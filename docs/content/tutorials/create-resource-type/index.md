---
type: docs
title: "2. Create Resource Types in Radius"
linkTitle: "2. Create Resource Types"
description: "Learn how to create a Radius Resource type"
weight: 300
categories: ["Tutorial"]
---

Radius includes several built-in resource types which developers can use to build applications. These include resource types such as Containers, Gateways, and Secrets. You can also create your own resource types. 

## Pre-requisites

[Node.js](https://nodejs.org/en/download) must be installed on the workstation to generate the Bicep extension to deploy the new resource type. 

<!-- TODO: Add option for users to skip the need for an OCI registry or Git repository for their recipe by showing a `rad recipe register` command which includes a reference to an already deployed recipe in the Radius project.  -->

## Create a PostgreSQL resource type in Radius

To create a PostgreSQL resource type in Radius, first create the resource type definition then add the resource type to Radius.

1. Create a new file called `types.yaml` and add the following:

   {{% rad file="snippets/types.yaml" lang=YAML embed=true %}}

   The PostgreSQL resource type definition includes:

    - **`namespace`**: The namespace of the resource type, as a convention `Radius.Data` is recommended but any name in the form `PrimaryName.SecondaryName` can be used
    - **`types`**: The resource type name
    - **`description`**: The developer documentation on how and when to use the resource is embedded in the description
    - **`apiVersions`**: The version of the schema defined below
    - **`schema`**: The OpenAPI v3 schema which defines the properties of the resource type
        - **`environment`**: The Radius environment ID which the resource is deployed to, this property is set by the Radius CLI when the resource is deployed
        - **`application`**: The application ID which the resource belongs to
        - **`size`**: The size of the PostgreSQL database
        - **`host`**: The host name used to connect to the database
        - **`port`**: The port used to connect to the database
        - **`username`**: The username used to connect to the database
        - **`password`**: The password used to connect to the database

    The `host`, `port`, `username`, and `password` properties are read-only properties set by Recipe.

2. Create the resource type using the [rad resource-type]({{< ref rad_resource-type_create >}}) command:

    ```bash
    rad resource-type create postgreSQL -f types.yaml
    ```

   ```
   $ rad resource-type create postgreSQL -f types.yaml 
   Creating resource type Radius.Resources/postgreSQL
   Creating API Version Radius.Resources/postgreSQL@2023-10-01-preview
   Creating location Radius.Resources/global/
   ```

## Create a Bicep extension

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

{{< button text="Next Step: Create Environment" page="create-environment" color="primary" >}}
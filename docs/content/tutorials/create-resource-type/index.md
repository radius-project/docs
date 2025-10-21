---
type: docs
title: "2. Create Resource Types"
linkTitle: "2. Create Resource Types"
description: "Learn how to create Radius Resource Types"
weight: 200
---

Resource types are the building blocks of Radius and define what developers can deploy. In part two of this tutorial, you will create a PostgreSQL resource type. For a comprehensive description of resource types, see the [Resource Types concept page]<insert link>

## Create a PostgreSQL resource type in Radius

To create a PostgreSQL resource type in Radius, first create the resource type definition then add the resource type to Radius.

1. Create a new file called `types.yaml` and add the following:

   {{% rad file="snippets/types.yaml" lang=YAML embed=true %}}

   The PostgreSQL resource type definition includes:

    - **`namespace`**: The namespace of the resource type, as a convention `Radius.Data` is recommended but any name in the form `PrimaryName.SecondaryName` can be used
    - **`types`**: The resource type name
    - **`description`**: The developer documentation on how and when to use the resource, formatted using Markdown
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
    rad resource-type create postgreSqlDatabases -f types.yaml
    ```

   ```
   $ rad resource-type create postgreSqlDatabases -f types.yaml
   Creating resource type Radius.Data/postgreSqlDatabases
   Creating API Version Radius.Data/postgreSqlDatabases@2023-10-01-preview
   Creating location Radius.Data/global/
   ```

## Create a Bicep extension

The `rad resource-type create` command created the resource type in the Radius control plane. The next step is to create a Bicep extension which will be used by the Radius CLI and VS Code (if you have the Bicep extension for VS Code installed).

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
   Successfully published Bicep extension "types.yaml" to "radiusResources.tgz"
   ```

1. Create the `bicepconfig.json` file and add the following contents.

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

## View the resource type in Radius Dashboard

Radius Dashboard is the front end experience to visualize your resource types, environments and application resources. Create a port-forward to access the Radius Dashboard:

```bash
kubectl port-forward --namespace=radius-system svc/dashboard 7007:80 
```
Navigate to [http://localhost:7007/resource-types/Radius.Data/postgreSqlDatabases](http://localhost:7007/resource-types/Radius.Data/postgreSqlDatabases) to view the documentation of the PostgreSQL resource type.

{{< image src="resource-type.png" alt="Radius Resource types in Dashboard" width="700px" >}} <br /><br />

In part three of this tutorial, you will create a Recipe to deploy the PostgreSQL resource type you just created.  
<br>
{{< button text="Next Step: Create Recipes" page="create-recipe" color="primary" >}}  

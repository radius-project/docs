---
type: docs
title: "2. Create Resource Types"
linkTitle: "2. Create Resource Types"
description: "Learn how to create Resource Types"
weight: 200
---

Resource Types are the building blocks of Radius and define what developers can deploy. In part two of this tutorial, you will create a PostgreSQL Resource Type.

## Create a PostgreSQL Resource Type

To create a PostgreSQL Resource Type in Radius, create the resource type definition file then create the resource type in Radius. The resource type definition for PostgreSQL is in the Radius [resource-types-contrib](https://github.com/radius-project/resource-types-contrib/tree/main/Data/postgreSqlDatabases) repository where all the Radius Resource Types and Recipes are maintained.

Create a new directory for the Todo List application.

   ```bash
   mkdir todolist
   cd todolist
   ```

{{< button text="Download postgreSqlDatabases.yaml" link="https://raw.githubusercontent.com/radius-project/resource-types-contrib/main/Data/postgreSqlDatabases/postgreSqlDatabases.yaml" newtab="true" >}}

The PostgreSQL Resource Type definition includes:

- **`namespace`**: The namespace of the resource type, as a convention `Radius.Data` is recommended but any name in the form `PrimaryName.SecondaryName` can be used
- **`types`**: The name of the Resource Type
- **`description`**: The developer documentation on how and when to use the resource, formatted using Markdown
- **`apiVersions`**: The version of the schema defined below
- **`schema`**: The OpenAPI v3 schema which defines the properties of the resource type
    - **`environment`**: The Radius environment ID which the resource is deployed to, this property is set by the Radius CLI when the resource is deployed
    - **`application`**: The application ID which the resource belongs to
    - **`size`**: The size of the PostgreSQL database which must be 'S','M', or 'L'
    - **`host`**: The host name used to connect to the database
    - **`port`**: The port used to connect to the database
    - **`username`**: The username used to connect to the database
    - **`password`**: The password used to connect to the database

The `host`, `port`, `username`, and `password` properties are read-only properties. These properties are set by the Recipe as outputs.

Create the Resource Type using the `rad resource-type create` command:

```bash
rad resource-type create postgreSqlDatabases -f postgreSqlDatabases.yaml
```

```
Creating resource type Radius.Data/postgreSqlDatabases
Creating API Version Radius.Data/postgreSqlDatabases@2025-08-01-preview
Creating location Radius.Data/global/
```

## Create a Bicep extension

The `rad resource-type create` command creates the Resource Type in the Radius control plane. The next step is to create a Bicep extension which will be used by the Radius CLI and VS Code (if you have the Bicep extension for VS Code installed).

{{% alert title="Warning" color="warning" %}}
This step is required even if you use Terraform-based Recipes to deploy the PostgreSQL Resource Type as part of the application.
{{% /alert %}}

1. Generate the Bicep extension using the [rad bicep publish-extension]({{< ref rad_bicep_publish-extension >}}) command.

   ```bash
   rad bicep publish-extension -f postgreSqlDatabases.yaml --target radiusResources.tgz
   ```
    You should see output similar to:
   ```
   $ rad bicep publish-extension -f postgreSqlDatabases.yaml --target radiusResources.tgz
   Writing types to /var/folders/w8/89pqzjp52pbg4g256z9cpkww0000gn/T/bicep-extension-2214011863/types.json
   Writing index to /var/folders/w8/89pqzjp52pbg4g256z9cpkww0000gn/T/bicep-extension-2214011863/index.json
   Writing documentation to /var/folders/w8/89pqzjp52pbg4g256z9cpkww0000gn/T/bicep-extension-2214011863/index.md
   Successfully published Bicep extension "postgreSqlDatabases.yaml" to "radiusResources.tgz"
   ```

1. Create a file called `bicepconfig.json` file and add the following contents:

    ```
    {
        "extensions": {
            "radius": "br:biceptypes.azurecr.io/radius:latest",
            "radiusResources": "radiusResources.tgz"
        }
    }
    ```

    Now, any Bicep template with `extension radiusResources` will reference the `radiusResources.tgz` file for details about the PostgreSQL resource type.

## View the Resource Type in Radius Dashboard

The Radius Dashboard is the GUI for viewing Resource types, Environments and Applications. In order to access it, Kubernetes must expose the Dashboard's network port. The easiest way to do that is using the `kubectl port-forward` command:

```bash
kubectl port-forward --namespace=radius-system svc/dashboard 7007:80 
```
Navigate to [http://localhost:7007/resource-types/Radius.Data/postgreSqlDatabases](http://localhost:7007/resource-types/Radius.Data/postgreSqlDatabases) to view the documentation of the PostgreSQL resource type. You should see the Dashboard similar to the screenshot below.

{{< image src="resource-type.png" alt="Radius Resource types in Dashboard" width="700px" >}} <br /><br />

In part three of this tutorial, you will create a Recipe to deploy the PostgreSQL Resource Type you just created.  
<br>
{{< button text="Next Step: Create Recipes" page="create-recipe" color="primary" >}}  

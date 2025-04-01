---
type: docs
title: "Tutorial: Create a resource type in Radius"
linkTitle: "Create resource type"
description: "Learn how to define and deploy a resource type in your Radius application"
weight: 200
categories: ["resource-types"]
---

This tutorial will teach you the following:

1. Define and create a resource type in Radius
1. Register a Recipe for the resource type
1. Deploy the application with the new resource type. 

In this tutorial, we will create the postgreSQL resource type and deploy the sample todoapp with postgreSQL.

{{< image src="todoapp.png" alt="Diagram of the todoapp with postgreSQL" width=600px >}}

## Prerequisites

- [Supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview" >}})
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})

## Step 1 : Initialize a Radius environment

1. Begin in a new directory for your application:

   ```bash
   mkdir todoapp
   cd todoapp
   ```
   
1. Initialize a new Radius environment:

   *Select 'Yes' when prompted to create an application.*

   ```bash
   rad init
   ```

## Step 2 : Create the resource type in Radius

Radius supports a set of built-in resource types such as containers, gateways and secrets out of the box that you can use in your applications. The definitions of these resource types are managed by Radius. To create a new resource type in Radius, you need to define the schema for the resource type and create the resource type in Radius. 

In this step we will define the schema for the postgreSQL resource type in `yaml` and create the resource type to Radius.

1. Create a new file called `postgreSQL.yaml` and add the following content:

    ```yaml
    name: MyCompany.Resources
    types:
    postgreSQLDatabase:
        apiVersions:
        '2023-10-01-preview':
            schema: 
            type: object
            properties:
                environment:
                type: string
                application:
                type: string
                description: The resource ID of the application.
                size:
                type: string
                description: The size of the resource type. S,M,L,XL
                status:
                type: object
                properties:
                    binding:
                    type: object
                    properties:
                        database:
                        type: string
                        description: The name of the database.
                        host:
                        type: string
                        description: The host name of the database.
                        port:
                        type: string
                        description: The port number of the database.
                        username:
                        type: string
                        description: The username for the database.
                        password:
                        type: string
                        description: The password for the database.
        capabilities: ["SupportsRecipes"]
    ```

    The `postgreSQL.yaml` file defines the schema for the postgreSQLDatabase resource type. The schema includes the following properties:

    - `environment`: The environment in which the resource type is deployed.
    - `application`: The application to which the resource belongs to.
    - `size`: The capacity of the resource type.
    - `status`: This is a read-only property that is set by the Recipe that includes connection information to the resource type.`

1. Create the resource type using the [rad resource-type]({{< ref rad_resource-type_create >}}) command:

    ```bash
    rad resource-type create postgreSQLDatabase -f postgreSQL.yaml
    ```
    The resource type `MyCompany.Resources/postgreSQLDatabase` is created and Radius will now be able to manage this resource type.

## Step 3 : Register a Recipe for the new resource type
    
In this step, we will publish a Recipe for the postgreSQLDatabase resource type and register the Recipe to an environment in Radius.
 
1. Create a new file called `postgreSQL.bicep` and add the following content:

    {{% rad file="snippets/postgreSQL.bicep" embed=true %}}

1. Publish the Recipe to the registry

    ```bash
    rad bicep publish --file postgreSQL.bicep --target br:ghcr.io/mycompany/recipes/postgreSQL:1.0
    ```
    The Recipe for the postgreSQLDatabase is published to the registry 

1. Now register the postgreSQL Recipe to the environment in Radius

    ```bash
    rad recipe register postgreSQL --environment default --resource-type MyCompany.Resources/postgreSQLDatabase --template-path ghcr.io/mycompany/recipes/postgreSQL:1.0
    ```
    The Recipe for the postgreSQLDatabase resource type is registered to the `default` environment in Radius.

## Step 4: Model the new resource-type in your application

1. Generate the Bicep extension for the postgreSQLDatabase resource type

    ```bash
    rad bicep publish-extension -f postgreSQL.yaml --target ./mycompany.gz
    ```
The bicep extension `mycompany` for the postgreSQLDatabase resource type is generated and published thus enabling the user to author the postgreSQLDatabase resource type in Bicep.

Open the `bicepconfig.json` file and add the `mycompany` extension to the `extensions` section.

    ```json
        {
            "experimentalFeaturesEnabled": {
                "extensibility": true
            },
            "extensions": {
                "radius": "br:biceptypes.azurecr.io/radius:<release-version>",
                "aws": "br:biceptypes.azurecr.io/aws:<release-version>",
                "mycompany": "/todoapp/mycompany.gz"
            }
        }
    ```

1. Add the postgreSQLDatabase resource type in `app.bicep` file

    {{% rad file="snippets/app.bicep" embed=true marker="//POSTGRES" %}}

1. Add the container with the connection information for the postgreSQLDatabase resource type

    {{% rad file="snippets/app.bicep" embed=true marker="//CONNECTIONS" %}}

## Step 5: Deploy the application

Use the command below to run the updated application again, then open the browser to [http://localhost:3000](http://localhost:3000).

```sh
rad run app.bicep
```

You should see the Radius Connections section with new environment variables added. The `todoappcontainer` container now has connection information for PostgreSQL (`CONNECTION_POSTGRES_HOST`, `CONNECTION_POSTGRES_PORT`, etc.)

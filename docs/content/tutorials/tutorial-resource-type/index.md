---
type: docs
title: "Tutorial: Create a Resource Type in Radius"
linkTitle: "Create resource type"
description: "Learn how to define and deploy a resource type in your Radius application"
weight: 200
categories: ["resource-types"]
---

This tutorial will teach you the following:

1. Define and create a resource type in Radius
1. Register a Recipe for the resource type
1. Deploy an application using the new resource type 

In this tutorial, we will create a PostgreSQL resource type and deploy the sample TodoApp with PostgreSQL.

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

Radius supports a set of built-in resource types such as containers, gateways, and secrets out of the box that you can use in your applications. The schema definitions and deployments of these resource types are managed by Radius.

To create a new resource type in Radius, you need to define the schema so that Radius can extend the APIs to support the new resource type in your application.

In this step, we will define the schema for the PostgreSQL resource type in `YAML` and create the resource type to Radius.

1. Create a new file called `postgres.yaml` and add the following:
    
    {{% rad file="snippets/postgres.yaml" lang=YAML embed=true %}}

    This defines the schema for the PostgreSQL resource type. The schema includes the following:

    - `name`: The namespace to which the resource type belongs to. This is used to group resource types together.
    - `types`: The resource type name. 
    - `apiVersions`: The API version of the resource type. 
    - `schema`: The schema of the resource type. This defines the properties of the resource type.
        - `environment`: The environment in which the resource type is deployed.
        - `application`: The application to which the resource belongs to.
        - `status`: This is a read-only property that is set by the Recipe that includes connection information to the resource type.
    - `capabilities`: This indicates that the resource type supports Recipes.

1. Create the resource type using the [rad resource-type]({{< ref rad_resource-type_create >}}) command:

    ```bash
    rad resource-type create postgreSQLDatabase -f postgreSQL.yaml
    ```
    The resource type `MyCompany.Resources/postgreSQL` is created and Radius will now be able to manage this resource type.

## Step 3 : Register a Recipe for the resource type

[Recipes]({{< ref "guides/recipes/overview" >}}) define how resource types are deployed. In this step, we will publish a Recipe for the PostgreSQL resource type and register it to the `default` environment in Radius.
 
1. Create a new file called `postgreSQL.bicep` and add the following:

    {{% rad file="snippets/bicep/postgreSQL.bicep" embed=true %}}
  
    This defines how the PostgreSQL resource type is deployed.

1. Publish the Recipe to an OCI-compliant registry

    ```bash
    rad bicep publish --file postgreSQL.bicep --target br:ghcr.io/<username>/recipes/postgreSQL:1.0
    ```
    The Recipe is published to GitHub container registry.

1. Register the Recipe to the `default` environment in Radius

    ```bash
    rad recipe register postgreSQL --environment default --resource-type MyCompany.Resources/postgreSQL --template-kind bicep --template-path ghcr.io/<username>/recipes/postgreSQL:1.0
    ```
    The Recipe for the PostgreSQL resource type is registered to the `default` environment in Radius.

1. Verify the Recipe is registered to the `default` environment

    ```bash
    rad recipe list
    ```

## Step 4: Model the resource-type in your application

In this step, we will generate the Bicep extension for the PostgreSQL resource type so that you can model this new resource-type in Bicep.

1. Generate the Bicep extension using the [rad bicep publish-extension]({{< ref rad_bicep_publish-extension >}}) command:

    ```bash
    rad bicep publish-extension -f postgreSQL.yaml --target ./mycompany.gz
    ```
    The bicep extension `mycompany` is generated and saved to the `mycompany.gz` file. 

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

1. Add the postgreSQL resource type in `app.bicep` file

    {{% rad file="snippets/app.bicep" marker="//POSTGRES" %}}

1. Add the container with the connection information for the postgreSQL resource type

    {{% rad file="snippets/app.bicep" marker="//CONNECTION" %}}

## Step 5: Deploy the application

Use the command below to run the updated application again, then open the browser to [http://localhost:3000](http://localhost:3000).

```sh
rad run app.bicep
```

You should see the Radius Connections section with new environment variables added. The `todoappcontainer` container now has connection information for PostgreSQL (`CONNECTION_POSTGRES_HOST`, `CONNECTION_POSTGRES_PORT`, etc.)

{{< image src="todoapp_postgres.png" alt="Todoapp with postgreSQL connection" width=800px >}}

## Next steps

In this tutorial, you learned how to create a PostgreSQL resource type in Radius and deploy the sample Todoapp with the resource type. You can use the same steps to create and deploy other resource types in Radius.
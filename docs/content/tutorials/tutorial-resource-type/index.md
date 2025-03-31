---
type: docs
title: "Tutorial: Create a new resource type in Radius"
linkTitle: "Create resource type"
description: "Learn how to define and deploy a new resource type in your Radius application"
weight: 200
categories: ["resource-types"]
---

This tutorial will teach you the following:

1. Define and add a new resource type in Radius
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

Radius supports a set of built-in resource types such as containers, gateways and secrets out of the box that you can use in your applications. The definitions of these resource types are managed by Radius. To create a new resource type in Radius, you need to define the schema for the resource type and add the resource type to Radius.

In this step we will define the schema for the postgreSQL resource type in `yaml` and add the resource type to Radius.

Here is the schema for the postgreSQL resource type

    {{% rad file="snippets/postgreSQL.yaml" embed=true %}}

    ```bash
    rad resource-type create postgreSQLDatabase -f postgreSQL.yaml
    ```
The resource type `MyCompany.Resources/postgreSQLDatabase` is created in Radius.

## Step 3 : Register a Recipe for the new resource type
    
In this step, we will publish a Recipe for the postgreSQLDatabase resource type and register the Recipe to an environment in Radius.

    ```bash
    rad bicep publish --file postgreSQL.bicep --target br:ghcr.io/mycompany/recipes/postgreSQL:1.0
    ```
 The Recipe for the postgreSQLDatabase is published to the registry 

Now register the postgreSQL Recipe to the environment in Radius

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

---
type: docs
title: "Add a database to the website tutorial app"
linkTitle: "Add a database connector"
description: "Connect a MongoDB to the website tutorial application using a connector and deploy to a Radius environment"
slug: "database"
weight: 3000
---

So far you have not yet configured a database, so the todo items you enter will be stored in memory inside the application. If the website restarts then all of your data will be lost!

In this step you will learn how to add a database and connect to it from the application.

We'll discuss app.bicep changes and then provide the full, updated file before deployment.

## Connectors

A [connector]({{< ref connector-schema >}}) provides an infrastructure abstraction for an API, allowing the backing resource type to be swapped out without changing the way the consuming resource is defined. In this example, first a developer uses a Kubernetes resource (MongoDB) as the app's database when deploying to their dev environment. Later, the infrastructure admin uses a Azure resource (Azure CosmosDB) as the app's database when deploying to production.

<img src="mongo-connector.png" width=450px alt="Diagram of a mongo connector" /><br />

To learn more about connectors visit the [concepts docs]({{< ref appmodel-concept >}}

## Add database connector

In this step, you will add the mongo container to deploy and test the application in your environment.

Update your Bicep file to match the following to add a Mongo database connector backed by a mongo container to your application:

{{< rad file="snippets/db-container.bicep" embed=true marker="//MONGO CONNECTOR" >}}


### Connect to `db` from `frontend`

Once the connector is referenced, you can connect to it by referencing the `db` component from within the `frontend` resource the [`connections`]({{< ref appmodel-concept >}}) section:

{{< rad file="snippets/app-container.bicep" embed=true marker="//CONTAINER" replace-key-dots="//IMAGE" replace-value-dots="container: {...}" >}}

[Connections]({{< ref appmodel-concept >}}) are used to configure relationships between two components. The `db` is of kind `mongo.com/MongoDB`, which supports the MongoDB protocol. This declares the *intention* from the `frontend` container to communicate with the `db` resource.

Now that you have created a connection called `itemstore`, environment variables with connection information will be injected into the `frontend` container. The container reads the database connection string from an environment variable named `CONNECTION_ITEMSTORE_CONNECTIONSTRING`.

## Update Bicep file

Make sure your Bicep file matches the following:

{{< rad file="snippets/app-container.bicep" embed=true >}}

## Deploy application with database

1. In a terminal window deploy the Bicep file:

   ```sh
   rad deploy app.bicep
   ```

   This may take a few minutes to create the database. On completion, you will see the following resources:

     ```sh
   Deployment In Progress:

     Completed       Application                Applications.Core/applications
     Completed       Container                  Applications.Core/containers
     Completed       frontend-route             Applications.Core/httpRoutes
     Completed       gateway                    Applications.Core/gateways
     Completed       mongo.com.MongoDatabase    db

   Deployment Complete 
   ```
   Just like before, a public endpoint will be available through the gateway.

   ```sh
   Public Endpoints:
      Gateway            frontend-gateway       IP-ADDRESS
   ```

1. To test your application, navigate to the public endpoint that was printed at the end of the deployment. You should see a page like:

   <img src="todoapp-withdb.png" width="400" alt="screenshot of the todo application with a database">

   If your page matches, then it means that the container is able to communicate with the database. Just like before, you can test the features of the todo app. Add a task or two. Now your data is being stored in an actual database.

## Handoff
This step closely relates to how the enterprises do hand-offs between different personas involved in the deployment. As a developer you have tested the application with a mongo container and would like to handoff the deployment to the infra-admin for deployments to other environments. The infra-admin can now set up a Radius environment with Azure cloud provider configured and can use th same app bicep template to provision an Azure resource via the connector. This ensures that you are able to port your application to different environments with minimal rewrites.

<br> {{< button text="Previous step: Author app definition" page="webapp-initial-deployment" newline="false">}} {{< button text="Next step: Swap connector resource" page="webapp-swap-connector-resource" >}}

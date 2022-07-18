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

A [Mongo database connector]({{< ref mongodb >}}) resource provides an abstraction over the Mongo API, allowing the backing resource to be swapped out without any changes to the consuming resource and code. This helps in separating the concerns of a developer from the infrastructure admin. A developer can use a kubernetes resource to back the connector to build and deploy an application in their developer environment where as the infrastructure-admin can setup a Azure resource to back the connector for production deployments

<img src="mongo-connector.png" width=450px alt="Diagram of a mongo connector" /><br />

 To learn more about connectors visit the [concepts docs]({{< ref connections-model >}})

## Add database connector

In this step, as a developer you will be adding the mongo container to deploy and test the application in your environment before handing off to the infrastructure admin team to carry out the deployment on a production environment which will covered in the next part of the tutorial. 

Update your Bicep file to match the following to add a Mongo database connector backed by a mongo container to your application:

{{< rad file="snippets/db-container.bicep" embed=true marker="//MONGO CONNECTOR" >}}


### Connect to `db` from `frontend`

Once the connector is referenced, you can connect to it by referencing the `db` component from within the `frontend` resource the [`connections`]({{< ref connections-model >}}) section:

{{< rad file="snippets/app-container.bicep" embed=true marker="//CONTAINER" replace-key-dots="//IMAGE" replace-value-dots="container: {...}" >}}

[Connections]({{< ref connections-model >}}) are used to configure relationships between two components. The `db` is of kind `mongo.com/MongoDB`, which supports the MongoDB protocol. This declares the *intention* from the `frontend` container to communicate with the `db` resource.

Now that you have created a connection called `itemstore`, environment variables with connection information will be injected into the `frontend` container. The container reads the database connection string from an environment variable named `CONNECTION_ITEMSTORE_CONNECTIONSTRING`.

<!--A manual dependency from `frontend` to `dbStarter` need to be added, pending an update the the Radius app model in an upcoming release. This ensures the Mongo database starter is deployed before `frontend` is deployed.-->

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
   Resources:
      Application              todoapp
      Container                frontend
      HttpRoute                frontend-route
      Gateway                  frontend-gateway
      mongo.com.MongoDatabase  db
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
As a developer you have tested the application with a mongo container and would like to handoff deployment to the infra-admin for deploymnet to other environments. You can use the same app.bicep for handoff by commenting out the mongo container resource. The infra-admin can now set up a Radius environment with Azure cloud provider configured and provision an Azure resource to back the connector. This ensures that you are able to port your application to different environments with minimal rewrites.

## Cleanup

{{% alert title="Delete application" color="warning" %}} If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) {{% /alert %}}

<br> {{< button text="Next step: Add a database to the app" page="webapp-swap-connector-resource" >}} {{< button text="Previous step: Author app definition" page="webapp-initial-deployment" >}}
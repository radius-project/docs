---
type: docs
title: "Add a database to the website tutorial app"
linkTitle: "Add a database"
description: "Connect a MongoDB to the website tutorial application using a connector"
slug: "database"
weight: 3000
---

So far you have not yet configured a database, so the todo items you enter will be stored in memory inside the application. If the website restarts then all of your data will be lost!

In this step you will learn how to add a database and connect to it from the application.

We'll discuss todo.bicep changes and then provide the full, updated file before deployment.

## Connectors

A [Mongo database connector]({{< ref mongodb >}}) resource provides an abstraction over the Mongo API, allowing the backing resource to be swapped out without any changes to the consuming resource and code.

<img src="mongo-connector.png" width=450px alt="Diagram of a mongo connector" /><br />

To learn more about connectors visit the [concepts docs]({{< ref connections-model >}})

## Add db starter

[Starter templates]({{< ref starter-templates >}}) are available to easily add a MongoDB connector to your application using Bicep modules. Update your Bicep file to match the following to add a Mongo database connector to your application:

{{< tabs "Mongo container" "Azure CosmosDB" >}}

{{< codetab >}}
{{< rad file="snippets/starter-container.bicep" embed=true marker="//STARTER" >}}
{{< /codetab >}}

{{< codetab >}}
This option is currently only available for Azure environments.

{{< rad file="snippets/starter-azure.bicep" embed=true marker="//STARTER" >}}
{{< /codetab >}}

{{< /tabs >}}

### Reference new connector

A starter deploys a MongoDB resource (container or CosmosDB), as well as a connector. Currently, the connector must be manually referenced in your application. To reference the deployed connector, use Bicep's `existing` keyword and add the following resource:

{{< rad file="snippets/starter-azure.bicep" embed=true marker="//APP" replace-key-dots="//CONTAINER" replace-value-dots="..." >}}

This manual step will be removed in a future release.

### Connect to `db` from `frontend`

Once the connector is referenced, you can connect to it by referencing the `db` component from within the `frontend` resource the [`connections`]({{< ref connections-model >}}) section:

{{< rad file="snippets/starter-azure.bicep" embed=true marker="//CONTAINER" replace-key-dots="//IMAGE" replace-value-dots="container: {...}" >}}

[Connections]({{< ref connections-model >}}) are used to configure relationships between two components. The `db` is of kind `mongo.com/MongoDB`, which supports the MongoDB protocol. This declares the *intention* from the `frontend` container to communicate with the `db` resource.

Now that you have created a connection called `itemstore`, environment variables with connection information will be injected into the `frontend` container. The container reads the database connection string from an environment variable named `CONNECTION_ITEMSTORE_CONNECTIONSTRING`.

A manual dependency from `frontend` to `dbStarter` need to be added, pending an update the the Radius app model in an upcoming release. This ensures the Mongo database starter is deployed before `frontend` is deployed.

## Update Bicep file

Make sure your Bicep file matches the following:

{{< tabs "Mongo container" "Azure CosmosDB" >}}

{{< codetab >}}
{{< rad file="snippets/app-container.bicep" embed=true >}}
{{< /codetab >}}

{{< codetab >}}
{{< rad file="snippets/app-azure.bicep" embed=true >}}
{{< /codetab >}}

{{< /tabs >}}

## Deploy application with database

{{% alert title="Known issue: Azure deployments" color="warning" %}}
There is a known issue where deployments to Azure will fail with a "NotFound" error for templates containing starters. This is being addressed in an upcoming release. As a workaround submit the deployment a second time. The second deployment should succeed.
{{% /alert %}}

1. In a terminal window deploy the Bicep file:

   ```sh
   rad deploy todo.bicep
   ```

   This may take a few minutes to create the database. On completion, you will see the following resources:

   ```sh
   Resources:
      Application              todoapp
      Container                frontend
      HttpRoute                frontend-route
      mongo.com.MongoDatabase  db
   ```

   Just like before, a public endpoint will be available through the gateway in the `frontend-route` resource.

   ```sh
   Public Endpoints:
      HttpRoute            frontend-route       IP-ADDRESS
   ```

1. To test your application, navigate to the public endpoint that was printed at the end of the deployment. You should see a page like:

   <img src="todoapp-withdb.png" width="400" alt="screenshot of the todo application with a database">

   If your page matches, then it means that the container is able to communicate with the database. Just like before, you can test the features of the todo app. Add a task or two. Now your data is being stored in an actual database.

## Cleanup

{{% alert title="Delete application" color="warning" %}} If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) to prevent additional charges in your Azure subscription. {{% /alert %}}

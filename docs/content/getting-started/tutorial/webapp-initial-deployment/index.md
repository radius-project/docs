---
type: docs
title: "Deploy the application with the frontend service and database"
linkTitle: "Deploy initial app"
description: "Define the initial application definition"
weight: 2000
slug: "frontend"
---

As a developer, you define the building blocks of your application. In this step, you will create the application template with the services required by the frontend of the application.

## Define a Radius application in a .bicep file

Radius uses the [Bicep language]({{< ref bicep >}}) as its file-format and structure. In this tutorial you will define an app named `todoapp` that will contain the container and MongoDB connector resources, all described in Bicep.

You can clone our [samples repo](https://github.com/project-radius/samples) which contains the source code of tutorial application and the bicep templates. It contains three bicep files

1. app.bicep - Contains the app definition 
1. mongo-container.bicep - Contains the definition for deploying mongo container
1. azure-cosmosdb.bicep - Contains the definition for Azure cosmosdb

Lets dig into the `app.bicep` to understand the components. Below is the definition to add a Radius application

{{< rad file="snippets/app.bicep" embed=true marker="//APPBASE" >}}

The environment property depicts the environment that was initialized in the previous step for the app to land on. Currently the environment property is auto-injected by Radius when the application is deployed.

The location property defines where to deploy a resource within the targeted platform. It is currently a required property that we expect to remove in a future release. See [Resource Schema]({{< ref resource-schema >}}) for more info.

## Container component

Next lets look into the definition for the website's frontend. 

Radius captures the relationships and intentions behind an application, which simplifies deployment and management. The `frontend` and `frontend-route` resources in your Bicep file will contain everything needed for the website frontend to run and expose a port to the internet.

The **`frontend`** [container]({{< ref container >}}) resource specifies:

- `container image`: The container image to run. This is where your website's front end code lives
- `ports`: The port to expose on the container, along with the [HttpRoute]({{< ref httproute >}}) that will be used to access the container

{{< rad file="snippets/app.bicep" embed=true marker="//CONTAINER" >}}

The **`gateway`** [Gateway]({{< ref gateway >}}) resource specifies:

- `routes`: The routes handled by this gateway. Here, we specify that `'/'` should map to `frontend-route`, which is provided by the 'frontend' container.

{{< rad file="snippets/app.bicep" embed=true marker="//GATEWAY" >}}

## Connectors

A [connector]({{< ref connector-schema >}}) provides an infrastructure abstraction for an API, allowing the backing resource type to be swapped out without changing the way the consuming resource is defined. In this example, first a developer uses a Kubernetes resource (MongoDB) as the app's database when deploying to their dev environment. Later, the infrastructure admin uses a Azure resource (Azure CosmosDB) as the app's database when deploying to production.

<img src="mongo-connector.png" width=450px alt="Diagram of a mongo connector" /><br />

To learn more about connectors visit the [concepts docs]({{< ref appmodel-concept >}}

## Add database connector

In this step, you will add the mongo container to deploy and test the application in your environment.

Update your Bicep file to match the following to add a Mongo database connector backed by a mongo container to your application:

{{< rad file="snippets/app.bicep" embed=true marker="//DATABASE" >}}


### Connect to `db` from `frontend`

Once the `db` connector is defined, you can reference it in the [`connections`]({{< ref appmodel-concept >}}) section of the `frontend` resource:

{{< rad file="snippets/app.bicep" embed=true marker="//CONTAINER" >}}


[Connections]({{< ref appmodel-concept >}}) are used to configure relationships between two components. The `db` is of kind `mongo.com/MongoDB`, which supports the MongoDB protocol. This declares the *intention* from the `frontend` container to communicate with the `db` resource.

Now that you have created a connection called `itemstore`, environment variables with connection information will be injected into the `frontend` container. The container reads the database connection string from an environment variable named `CONNECTION_ITEMSTORE_CONNECTIONSTRING`.


_______________________
## Update Bicep file

Your bicep file should look like below 

{{< rad file="snippets/app.bicep" embed=true >}}





## Deploy the application

Now you are ready to deploy the application for the first time.

1. Make sure you have an [Radius environment initialized]({{< ref webapp-initialize-environment >}}).

2. Deploy to your Radius environment via the rad CLI:

   ```sh
   rad deploy ./app.bicep
   ```

   This will deploy the application into your environment and launch the container resource for the frontend website. You should see the following resources deployed at the end of `rad deploy`:

   ```sh
   Deployment In Progress:

     Completed       Application                Applications.Core/applications
     Completed       Container                  Applications.Core/containers
     Completed       frontend-route             Applications.Core/httpRoutes
     Completed       gateway                    Applications.Core/gateways
     Completed       mongo.com.MongoDatabase    db

   Deployment Complete 
   ```

   Also, a public endpoint will be available to your application since it contains a [Gateway]({{< ref gateway >}}) resource.

   ```sh
   Public Endpoints:
      Gateway           frontend-gateway      IP-ADDRESS
   ```

3. To test your application, navigate to the public endpoint that was printed at the end of the deployment.

   <img src="todoapp-nodb.png" width="400" alt="screenshot of the todo application with no database">

   If the page you see matches the screenshot, that means the container is running as expected.

You can play around with the application's features:

- Add a todo item
- Mark a todo item as complete
- Delete a todo item


## Handoff
This step closely relates to how the enterprises do hand-offs between different personas involved in the deployment. As a developer you have tested the application with a mongo container and would like to handoff the deployment to the infra-admin for deployments to other environments. The infra-admin can now set up a Radius environment with Azure cloud provider configured and can use th same app bicep template to provision an Azure resource via the connector. This ensures that you are able to port your application to different environments with minimal rewrites.

<br> {{< button text="Previous step: Initialize an environment" page="webapp-initialize-environment" newline="false" >}} {{< button text="Next step: Swap connector resource" page="webapp-swap-connector-resource" >}}

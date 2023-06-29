---
type: docs
title: "Quickstart: Dapr Microservices"
linkTitle: "Dapr microservices"
description: "Learn Radius by authoring templates and deploying a Dapr application"
weight: 300
no_list: true
slug: "dapr"
categories: "Quickstart"
tags : ["Dapr"]
---

This quickstart will teach you:

- How to use Radius to deploy a Dapr microservices sample application for an online shop
- How [Dapr and Radius]({{< ref dapr-resources >}}) seamlessly work together
- To see more details of the app and access the source code, visit the `quickstarts/dapr` directory in the [samples repo](https://github.com/project-radius/samples)

## Prerequisites

- [Radius CLI]({{< ref "getting-started" >}})
- [Radius environment]({{< ref "environments-concept" >}})
- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/)
- [Installation of Dapr](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-deploy/) 
- [Visual Studio Code](https://code.visualstudio.com/) (recommended)
  - The [Radius VSCode extension]({{< ref "getting-started" >}}) is highly recommended to provide syntax highlighting, completion, and linting.
  - Although not recommended, you can also complete this quickstart with any basic text editor.

## Step 1: Define an application

Begin by creating a new file named `dapr.bicep` with a Radius application:

{{< rad file="snippets/1-dapr-backend.bicep" embed=true marker="//APP" >}}

## Step 2: Add and deploy `backend` container

1. Next you'll add a `backend` [container]({{< ref container >}}): 

{{< rad file="snippets/1-dapr-backend.bicep" embed=true marker="//BACKEND" >}}

> The image `radius.azurecr.io/quickstarts/dapr-backend:edge` is where your application's backend code lives.

<br>

2. Deploy to your Radius environment to launch the container resource for the backend website:

   ```sh
   rad deploy dapr.bicep
   ```

1. Confirm that your Radius application was deployed:

   ```sh
   rad resource list containers --application dapr-quickstart
   ```

   You should see your `backend` resource:

   ```
   RESOURCE   TYPE
   backend   Applications.Core/containers
   ```

1. To test your `dapr-quickstart` deployment so far, open a local tunnel to your application:

   ```sh
   rad resource expose containers backend --application dapr-quickstart --port 3000
   ```

1. Visit the URL [http://localhost:3000/order](http://localhost:3000/order) in your browser. You should see the following message which indicates that the container is running as expected:

   ```json
   {"message":"The container is running, but Dapr has not been configured."}
   ```

1. When you are done testing press `CTRL+C` to terminate the port-forward.

## Step 3: Add Dapr extension and route

1. Modify your `backend` resource to add a [Dapr `extension`]({{< ref dapr-extension >}}) that describes the Dapr configuration:

{{< rad file="snippets/2-dapr-route.bicep" embed=true marker="//BACKEND" replace-key-container="//CONTAINER" replace-value-container="container: {...}">}}

2. Add a [Dapr HTTP route]({{< ref dapr-schema >}}) resource to enable other services to invoke `backend` through Dapr service invocation:

{{< rad file="snippets/2-dapr-route.bicep" embed=true marker="//ROUTE_BACK">}}

3. Update the `orders` port definition in `backend` to provide the route:

{{< rad file="snippets/3-dapr-redis.bicep" embed=true marker="//BACKEND" replace-key-extensions="//EXTENSIONS" replace-value-extensions="extensions: [...]">}}

## Step 4: Add a Redis state store container

Add Redis container configured with [Dapr state store]({{< ref "dapr-resources#building-blocks" >}}):

{{< rad file="snippets/3-dapr-redis.bicep" embed=true marker="//REDIS">}}

## Step 5: Connect `backend` to the Dapr Redis state store

1. Add a [`connection`]({{< ref "appmodel-concept" >}}) in `backend` to connect it with `statestore`:

{{< rad file="snippets/4-dapr-connection.bicep" embed=true marker="//BACKEND" replace-key-container="//CONTAINER" replace-value-container="container: {...}" replace-key-extensions="//EXTENSIONS" replace-value-extensions="extensions: [...]">}}

## Step 6. Deploy the Dapr-enabled `backend` application:

1. Re-deploy the application to include the Dapr state store:

   ```sh
   rad deploy dapr.bicep
   ```

1. You can confirm all the resources were deployed by running:

   ```sh
   rad resource list containers --application dapr-quickstart
   ```

   and:

   ```sh
   rad resource list daprstatestores --application dapr-quickstart
   ```

   You should see both `backend` and `statestore` components in your `dapr-quickstart` application. :

   ```
    RESOURCE      TYPE
    backend       applications.core/containers
   ```

   ```
    RESOURCE      TYPE
    orders        applications.link/daprstatestores
   ```

1. To test the Dapr state store, open a local tunnel on port 3000:

   ```sh
   rad resource expose containers backend --application dapr-quickstart --port 3000
   ```

1. Visit the the URL [http://localhost:3000/order](http://localhost:3000/order) in your browser. You should see the following message, which indicates that the `backend` container is able to communicate with the Dapr state store:

   ```json
   {"message":"no orders yet"}
   ```

1. Press CTRL+C to terminate the port-forward.

## Step 7: Add `frontend` container

1. Now you'll add a `frontend` [container]({{< ref container >}}) which will serve as the application's frontend:

{{< rad file="snippets/5-dapr-frontend.bicep" embed=true marker="//FRONTEND" >}}

> The `radius.azurecr.io/quickstarts/dapr-frontend:edge` image is where your application's backend code lives. 

> The `backendRoute.id` connection declares the intention for `frontend` to communicate with `backend` through the `backendRoute` Dapr HTTP Route.

> The `dapr.io/Sidecar` extension configures Dapr on the container, which is used to invoke the backend.

<br>

2. Add an [HttpRoute]({{< ref httproute >}}) and [Gateway]({{< ref gateway >}}) to expose the `frontend` container on a public endpoint:

{{< rad file="snippets/5-dapr-frontend.bicep" embed=true marker="//ROUTE_FRONT">}}

## Step 8. Deploy your application

<!-- 1. Confirm that your complete `dapr.bicep` file is as follows:

{{< rad file="snippets/5-dapr.bicep" embed=true >}} -->

1. Deploy the application to your environment:

   ```sh
   rad deploy dapr.bicep
   ```

1. Confirm that your Radius application was deployed:

   ```sh
   rad resource list containers --application dapr-quickstart
   ```

    You should see your `backend` and `frontend` resources:

      ```sh
      RESOURCE   TYPE
      backend    Applications.Core/containers
      frontend   Applications.Core/containers
      ```

## Step 8. Test your application

1. Fetch the public endpoint that has been made available to your application automatically by the [`Gateway`]({{< ref "gateway#hostname-generation">}}) you had added in previous steps:

   ```sh
   rad app status -a dapr-quickstart
   ```

   ```sh
   APPLICATION      RESOURCES
   dapr-quickstart  6

   GATEWAY   ENDPOINT
   gateway   <YOUR_PUBLIC_ENDPOINT>
   ```

1. Navigate to the endpoint in your browser to view the application:

   <img src="frontend.png" alt="Screenshot of frontend application" width=500 >

## Cleanup

1. Run `rad app delete` to cleanup your Radius application, container, and link:

   ```bash
   rad app delete -a dapr-quickstart
   ```

1. Delete the Redis Kubernetes resources:

   ```bash
   kubectl delete statefulset,service redis
   ```

## Next steps

- If you'd like to try another tutorial with your existing environment, go back to the [Radius quickstarts]({{< ref quickstarts >}}) page.
- Related links for Dapr:
  - [Dapr documentation](https://docs.dapr.io/)
  - [Dapr quickstarts](https://github.com/dapr/quickstarts/tree/v1.0.0/hello-world)

<br>{{< button text="Try another quickstart" page="quickstarts" >}}

<!-- ## TODO

1. Port-forward the container to your machine with [`rad resource expose`]({{< ref rad_resource_expose >}}):

   ```sh
   rad resource expose containers backend --application dapr-quickstart --port 3000
   ```

1. Visit [http://localhost:3000/order](http://localhost:3000/order) in your browser. You should see the following message:

   ```json
   {"message":"The container is running, but Dapr has not been configured."}
   ```

1. When you are done testing press `CTRL+C` to terminate the port-forward. -->
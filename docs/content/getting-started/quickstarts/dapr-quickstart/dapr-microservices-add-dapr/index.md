---
type: docs
title: "Add Dapr sidecars and a Dapr statestore to the app"
linkTitle: "Add Dapr"
slug: "add-dapr"
description: "How to enable Dapr sidecars and connect a Dapr state store to the tutorial application"
weight: 3000
---

Currently, the data you send to `backend` will be stored in memory inside the application. If the website restarts then all of your data will be lost!

In this step you will learn how to add a state store database and connect to it from the application with Dapr.

## Add a Dapr extension

A [Dapr extension]({{< ref dapr-extension >}}) on the `backend` resource can be used to describe the Dapr configuration:

{{< rad file="snippets/extension.bicep" embed=true marker="//SAMPLE" replace-key-container="//CONTAINER" replace-value-container="container: {...}" >}}

The `extensions` section is used to configure cross-cutting behaviors of components. Since Dapr is not part of the standard definition of a container, it can be added via a extension. Extensions have a `kind` so that they can be strongly typed.

## Add Dapr Invoke Route

In order for other services to invoke `backend` through Dapr service invocation, a [Dapr Route]({{< ref dapr-http >}}) is required.

Add a [Dapr HTTP route]({{< ref dapr-http >}}) resource to the app, and update the `orders` port definition to provide route:

{{< rad file="snippets/invoke.bicep" embed=true marker="//SAMPLE" replace-key-extensions="//EXTENSIONS" replace-value-extensions="extensions: [...]" >}}

## Add Dapr statestore

Now that the backend is configured with Dapr, we need to define a state store to save information about orders.

You can choose between a Redis container or Azure Table Storage

{{< tabs "Redis Container" "Azure Table Storage" >}}

{{< codetab >}}

{{< rad file="snippets/statestore.bicep" embed=true marker="//SAMPLE" >}}
{{< /codetab >}}

{{< codetab >}}
{{< rad file="snippets/statestore-azure.bicep" embed=true marker="//SAMPLE" >}}
{{< /codetab >}}

{{< /tabs >}}

## Reference statestore from `backend`

Radius captures both logical relationships and related operational details. Examples of this include: wiring up connection strings, granting permissions, or restarting components when a dependency changes.

The [`connections` property]({{< ref "appmodel-concept" >}}) is used to configure relationships between from a service to another resource.

Add a [`connection`]({{< ref "appmodel-concept" >}}) from `backend` to the `orders` state store. This declares the _intention_ from the `backend` container to communicate with the `statestore` resource

{{< rad file="snippets/connection.bicep" embed=true marker="//BACKEND" replace-key-container="//CONTAINER" replace-value-container="container: {...}" replace-key-extensions="//EXTENSIONS" replace-value-extensions="extensions: [...]" >}}

### Injected settings from connections

Adding a connection to the state store also [configures environment variables]({{< ref "dapr-statestore#provided-data" >}}) inside the the `statestore` component.

With the connection name of `statestore` and a statestore name of `orders`, Project Radius will inject information related to the state store using the environment variable `CONNECTION_ORDERS_STATESTORENAME`. The application code inside `backend` uses this environment variable to access the state store name and avoid hardcoding.

```js
const stateStoreName = process.env.CONNECTION_ORDERS_STATESTORENAME;
```

## Deploy application with Dapr

1. Make sure your `dapr.bicep` file matches the full tutorial file:

   - Redis state store: {{< rad file="snippets/dapr.bicep" download=true >}}
   - Azure storage state store: {{< rad file="snippets/dapr-azure.bicep" download=true >}}

1. Now you are ready to re-deploy the application, including the Dapr state store. Switch to the command-line and run:

   ```sh
   rad deploy dapr.bicep
   ```

   If you are using the Azure storage Dapr state store starter, this may take a couple minutes as the storage account is deployed.

1. You can confirm all the resources were deployed by running:

   ```sh
   rad resource list --application dapr-quickstart
   ```

   You should see both `backend` and `statestore` components in your `dapr-quickstart` application. Example output:

   ```sh
    RESOURCE      TYPE                         PROVISIONING_STATE  HEALTH_STATE
    orders        dapr.io.StateStore           Provisioned         Healthy
    backend       Container                    Provisioned         Healthy
   ```

1. To test out the state store, open a local tunnel on port 3000 again:

   ```sh
   rad resource expose containers backend --application dapr-quickstart --port 3000
   ```

1. Visit the the URL [http://localhost:3000/order](http://localhost:3000/order) in your browser. You should see the following message:

   ```json
   {"message":"no orders yet"}
   ```

   If your message matches, then the container is able to communicate with the state store.

1. Press CTRL+C to terminate the port-forward.

<br>{{< button text="Next: Add an frontend component to the app" page="dapr-microservices-add-ui.md" >}}

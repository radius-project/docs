---
type: docs
title: "Deploy the website tutorial frontend"
linkTitle: "Deploy frontend"
description: "Deploy the website tutorial frontend in a container"
weight: 2000
slug: "frontend"
---

## Define a Radius application in a .bicep file

Radius uses the [Bicep language]({{< ref bicep >}}) as its file-format and structure. In this tutorial you will define an app named `webapp` that will contain the container and MongoDB connector resources, all described in Bicep.

Create a new file named `todo.bicep` and paste the following:

{{< rad file="snippets/empty-app.bicep" embed=true >}}

## Add a container component

Next you'll add resources for the website's frontend.

Radius captures the relationships and intentions behind an application, which simplifies deployment and management. The `frontend` and `todo-route` resources in your Bicep file will contain everything needed for the website frontend to run and expose a port to the internet.

The **`frontend`** [container]({{< ref container >}}) resource specifies:

- `container image`: The container image to run. This is where your website's front end code lives
- `ports`: The port to expose on the container, along with the [HTTP route]({{< ref http-route >}}) that will be used to access the container

The **`todo-route`** [HTTP Route]({{< ref http-route >}}) resource specifies:

- `hostname`: The hostname to expose to the internet. `*` means that all hostnames will be accepted.

Update your Bicep file to match the full application definition:

{{< rad file="snippets/container-app.bicep" embed=true >}}

## Deploy the application

Now you are ready to deploy the application for the first time.

1. Make sure you have an [Radius environment initialized]({{< ref create-environment >}}).
   - For Azure environments run `az login` to make sure your token is refreshed.
   - For Kubernetes environments make sure your `kubectl`  context is set to your cluster.

1. Deploy to your Radius environment via the rad CLI:

   ```sh
   rad deploy ./todo.bicep
   ```

   This will deploy the application into your environment and launch the container resource for the frontend website. You should see the following resources deployed at the end of `rad deploy`:

   ```sh
   Resources:
      Application          todoapp
      Container            frontend
      HttpRoute            frontend-route
   ```

   Also, a public endpoint will be available to your application as we specified a gateway in the `frontend-route` resource.

   ```sh
   Public Endpoints:
      HttpRoute            frontend-route      IP-ADDRESS
   ```

1. To test your application, navigate to the public endpoint that was printed at the end of the deployment.

   {{% alert title="⚠️ Local environment endpoint" color="warning" %}}
   If using a local environment, navigate to the IP address provided by `rad env status`. The address printed at deploy time currently points to the wrong endpoint.
   {{% /alert %}}

   <img src="todoapp-nodb.png" width="400" alt="screenshot of the todo application with no database">

   If the page you see matches the screenshot, that means the container is running as expected.

   You can play around with the application's features features:
   - Add a todo item
   - Mark a todo item as complete
   - Delete a todo item

<br>{{< button text="Next: Add a database to the app" page="webapp-add-database" >}}

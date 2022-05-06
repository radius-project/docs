---
type: docs
title: "Add a frontend UI to the app"
linkTitle: "Add frontend"
slug: "add-frontend"
description: "How to add a frontend user interface to the tutorial application"
weight: 4000
---

To complete the application, you'll add another component for the frontend user interface.

Again, we'll discuss changes to your Bicep file and then provide the full, updated file before deployment.

## Add `frontend` container and `frontend-route` HttpRoute

Another container resource is used to specify a few properties about the order generator:

- **container image**: `radius.azurecr.io/daprtutorial-frontend` is a Docker image the container will run.
- **connections**: `daprBackend.id` declares the intention for `frontend` to communicate with `backend` through the `daprBackend` Dapr HTTP Route.
- **traits**: `dapr.io/Sidecar` configures Dapr on the container.

Additionally, a [Gateway]({{< ref gateway >}}) and an [HttpRoute]({{< ref httproute >}}) are configured to expose the `frontend` container on a public endpoint.

{{< rad file="snippets/frontend.bicep" marker="//FRONTEND" embed=true >}}

As before with connections, the `frontend` component is using an environment variable to get information about the the `backend` Dapr route. This avoids hardcoding.

```C#
var appId = Environment.GetEnvironmentVariable("CONNECTION_BACKEND_APPID");
services.AddSingleton<HttpClient>(DaprClient.CreateInvokeHttpClient(appId));
```
  
## Deploy application

1. Make sure your Bicep file matches the full tutorial file:

   - Redis state store: {{< rad file="./snippets/dapr.bicep" download=true >}}
   - Azure table storage state store: {{< rad file="./snippets/dapr-azure.bicep" download=true >}}

1. Switch to the command line and run:

   ```sh
   rad deploy dapr.bicep
   ```

   Now that we added a `Gateway` and an `HttpRoute`, a public endpoint will be available to your application.

   ```sh
   Public Endpoints:
      Gateway            frontend-gateway           IP-ADDRESS
   ```

   Navigate to the endpoint to view the application:

   <img src="frontend.png" alt="Screenshot of frontend application" width=500 >

You have completed this tutorial!

## Cleanup

{{% alert title="Delete your environment" color="warning" %}}
If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) to **prevent additional charges in your Azure subscription**.
{{% /alert %}}

## Next steps

- If you'd like to try another tutorial with your existing environment, go back to the [Radius tutorials]({{< ref tutorial >}}) page. 
- Related links for Dapr:
  - [Dapr documentation](https://docs.dapr.io/)
  - [Dapr quickstarts](https://github.com/dapr/quickstarts/tree/v1.0.0/hello-world)

<br>{{< button text="Try another tutorial" page="tutorial" >}}

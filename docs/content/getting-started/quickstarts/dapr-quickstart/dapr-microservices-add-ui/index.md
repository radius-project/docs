---
type: docs
title: "Add a frontend UI to the app"
linkTitle: "Add frontend"
slug: "add-frontend"
description: "How to add a frontend user interface to the tutorial application"
weight: 4000
---

To complete the application, you'll add another component for the frontend user interface.

## Add `frontend` container

Another container resource is used to specify a few properties about the order generator:

- **container image**: `radius.azurecr.io/daprtutorial-frontend:latest` is a Docker image the container will run.
- **connections**: `backendRoute.id` declares the intention for `frontend` to communicate with `backend` through the `backendRoute` Dapr HTTP Route.
- **extensions**: `dapr.io/Sidecar` configures Dapr on the container, which is used to invoke the backend.

{{< rad file="snippets/frontend.bicep" marker="//FRONTEND" embed=true >}}

As before with connections, the `frontend` component is using an environment variable to get information about the the `backend` Dapr route. This avoids hardcoding.

```C#
var appId = Environment.GetEnvironmentVariable("CONNECTION_BACKEND_APPID");
services.AddSingleton<HttpClient>(DaprClient.CreateInvokeHttpClient(appId));
```

## Add Http Route and Gateway

Additionally, a [Gateway]({{< ref gateway >}}) and an [HttpRoute]({{< ref httproute >}}) are configured to expose the `frontend` container on a public endpoint.

{{< rad file="snippets/frontend.bicep" marker="//ROUTES" embed=true >}}
  
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
    gateway         Applications.Core/gateways http://gateway.dapr-quickstart.<IP>.nip.io
   ```

   Navigate to the endpoint to view the application:

   <img src="frontend.png" alt="Screenshot of frontend application" width=500 >

You have completed this tutorial!

## Cleanup

{{% alert title="Delete your environment" color="warning" %}}
If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}).
{{% /alert %}}

## Next steps

- If you'd like to try another tutorial with your existing environment, go back to the [Radius quickstarts]({{< ref quickstarts >}}) page.
- Related links for Dapr:
  - [Dapr documentation](https://docs.dapr.io/)
  - [Dapr quickstarts](https://github.com/dapr/quickstarts/tree/v1.0.0/hello-world)

<br>{{< button text="Try another quickstart" page="quickstarts" >}}

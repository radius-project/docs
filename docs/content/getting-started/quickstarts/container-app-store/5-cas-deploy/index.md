---
type: docs
title: "Deploy Container App Store Microservice application"
linkTitle: "Deploy app"
slug: "deploy"
description: "Learn how to deploy the Container App Store Microservice application to a Radius environment"
weight: 500
---

## Initialize Azure environment

Create a new Azure environment, specifying your subscription and resource group:

```sh
rad env init azure -i
```
<!-- TODO: update to 'rad env init kubernetes' in this whole sample app -->

## Deploy application to Azure

Using the [`rad deploy`]({{< ref rad_deploy >}}) command, deploy the Container App Store Microservice application to your environment:

```sh
rad deploy
```

The deployed resources, along with gateway IP address, will be output to the console upon a successful deployment.

{{% alert title="Container registry" color="warning" %}}
Make sure to update the `docker.image` values within your `rad.yaml` file with a container registry that you are able to push to. By default this is set to `MYREGISTRY`, which will throw an error when you try to deploy.
{{% /alert %}}

## Visit Container App Store Microservice

Now that Container App Store Microservice is deployed, you can visit the application via the IP address output above.

<img src="container-app-store-microservice.png" alt="Screenshot of the Container App Store Microservice application" width=600 >

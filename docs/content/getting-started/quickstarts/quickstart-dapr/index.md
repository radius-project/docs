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

For more details on the app and access to the source code, visit the `quickstarts/dapr` directory in the [samples repo](https://github.com/project-radius/samples). _For access to the project-radius GitHub org, please complete and submit [this form](https://aka.ms/ProjectRadius/GitHubAccess)._

## Prerequisites

- [Kubernetes cluster]({{< ref "supported-clusters" >}})
- [Radius CLI]({{< ref "getting-started" >}})
- [Radius environment]({{< ref "operations/environments/overview" >}})
- [Dapr installed on your Kubernetes cluster](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-deploy/)
- [Visual Studio Code](https://code.visualstudio.com/) (recommended)
  - The [Radius VSCode extension]({{< ref "getting-started" >}}) is highly recommended to provide syntax highlighting, completion, and linting
  - Although not recommended, you can also complete this quickstart with any basic text editor

## Step 1: Define the application, `backend` container, and Dapr state store

Begin by creating a new file named `dapr.bicep` with a Radius application that consists of a `backend` container and Dapr state store with Redis:

{{< rad file="snippets/dapr.bicep" embed=true marker="//BACKEND" >}}

## Step 2: Deploy the `backend` application

1. Deploy the application's `backend` container and Dapr state store:

   ```sh
   rad run dapr.bicep
   ```

1. You can confirm all the resources were deployed by looking for `dapr`, `backend`, and `statestore` resources in the console logs:
   ```
   Deployment Complete

   Resources:
    dapr            Applications.Core/applications
    backend         Applications.Core/containers
    statestore      Applications.Link/daprStateStores
   ```

1. The `rad run` command automatically sets up port forwarding. Visit the the URL [http://localhost:3000/order](http://localhost:3000/order) in your browser. You should see the following message, which confirms the container is able to communicate with the state store:

   ```
   {"message":"no orders yet"}
   ```

1. Press CTRL+C to terminate the port-forward.

1. Confirm that the Dapr Redis statestore was successfully created:

   ```sh
   dapr components -k -A
   ```

   You should see the following output:

   ```
   NAMESPACE      NAME         TYPE          VERSION  SCOPES  CREATED               AGE  
   default-dapr   statestore   state.redis   v1               2023-07-21 16:04.27   21m  
   ```

## Step 3: Define the `frontend` container

Add a `frontend` [container]({{< ref container >}}) which will serve as the application's user interface.

{{< rad file="snippets/dapr.bicep" embed=true marker="//FRONTEND" >}}

## Step 4. Deploy and run the `frontend` application

1. Use Radius to deploy and run the application with a single command:

   ```sh
   rad run dapr.bicep
   ```

1. Your console should output a series deployment logs, which you may check to confirm the `frontend` container was successfully deployed:

   ```
   Deployment Complete

   Resources:
      dapr            Applications.Core/applications
      backend         Applications.Core/containers
      frontend        Applications.Core/containers
      statestore      Applications.Link/daprStateStores
   ```

## Step 5. Test your application

In your browser, navigate to the endpoint (e.g. [http://localhost:8080](http://localhost:8080)) to view and interact with your application:

   <img src="frontend.png" alt="Screenshot of frontend application" width=500 >

## Cleanup

1. Press CTRL+C to terminate the `rad run` log console

1. Run `rad app delete` to cleanup your Radius application, container, and link:

   ```bash
   rad app delete -a dapr
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

<br>

{{< button text="Try another quickstart" page="quickstarts" >}}
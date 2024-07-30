---
type: docs
title: "How-To: Add a Dapr building block"
linkTitle: "Add a building block"
description: "Learn how to add a Dapr building block to a Radius Application"
weight: 300
categories: "How-To"
tags: ["Dapr"]
---

This how-to guide will provide an overview of how to:

- Leverage a [Dapr building block](https://docs.dapr.io/developing-applications/building-blocks/) in your Radius Application

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})
- [Radius local-dev Recipes]({{< ref howto-dev-recipes >}})
- [Dapr installed on your Kubernetes cluster](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-deploy/)

## Step 1: Start with a container and a Dapr sidecar

Begin by creating a file named `app.bicep` with a defined Radius container and a Dapr sidecar, if you need a in-depth walkthrough see the ['How-To: Add a Dapr sidecar to a container' guide]({{< ref how-to-dapr-sidecar >}}):

{{< rad file="./snippets/app-sidecar.bicep" embed=true >}}

## Step 2: Add a Dapr state store resource

Now add a Dapr state store resource, which models a [Dapr state store component](https://docs.dapr.io/developing-applications/building-blocks/state-management/state-management-overview/). The underlying infrastructure and Dapr component configuration are deployed via a [`local-dev` Recipe]({{< ref "guides/recipes/overview##use-lightweight-local-dev-recipes" >}}), which leverages a lightweight Redis container:

{{< rad file="./snippets/app-statestore.bicep" embed=true marker="//STATESTORE" >}}

> Visit the [Radius Recipe repo](https://github.com/radius-project/recipes/blob/main/local-dev/statestores.bicep) to learn more about `local-dev` Recipes and view the Dapr State Store Recipe used in this guide.

## Step 3: Add a connection from the container resource to the Dapr state store resource

Update your container resource with a connection to the Dapr state store. This will inject important connection information (the component name) into the container's environment variables:

{{< rad file="./snippets/app-statestore.bicep" embed=true marker="//CONTAINER" >}}
## Step 3: Deploy the application

Run your application with the `rad` CLI:

```bash
rad run ./app.bicep -a demo
```

Your console output should look similar to:

```
Building ./app.bicep...
Deploying template './app.bicep' for application 'demo' and environment 'default' from workspace 'default'...

Deployment In Progress... 

Completed            statestore      Applications.Dapr/stateStores
...                  demo            Applications.Core/containers

Deployment Complete

Resources:
    demo            Applications.Core/containers
    statestore      Applications.Dapr/stateStores

Starting log stream...
```

Open [http://localhost:3000](http://localhost:3000) to view the Radius demo container. Which should contain the following connection information:

{{< image src="app-statestore.png" alt="Screenshot of the demo Redis connection" width=700px >}}
## Step 4: Verify the Dapr statestore

Run the command below to see all the pods running in your Kubernetes cluster:

```bash
dapr components --namespace "default-demo" -k
```

The console output should similar to:

```
NAMESPACE     NAME        TYPE         VERSION  SCOPES  CREATED              AGE  
default-demo  statestore  state.redis  v1               2024-02-19 17:13.20  2m   
```

## Done

You've successfully deployed a Radius container with a Dapr sidecar along with a Dapr State Store. With the combination of Radius + Dapr, both your application's code and it's definition are now platform neutral.

## Cleanup

To delete your app, run the [rad app delete]({{< ref rad_application_delete >}}) command to cleanup the app and its resources, including the Recipe resources:

```bash
rad app delete -a demo
```

## Further reading

- [Dapr building blocks](https://docs.dapr.io/concepts/building-blocks-concept/)
- [Dapr resource schemas]({{< ref dapr-schema >}})


---
type: docs
title: "How-To: Add a Dapr building block"
linkTitle: "Add a Dapr building block"
description: "Learn how to add a Dapr building block to a Radius Application"
weight: 300
categories: "How-To"
tags: ["Dapr"]
---

This how-to guide will provide an overview of how to:

- Leverage a [Dapr building block](https://docs.dapr.io/developing-applications/building-blocks/) in your Radius Application

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})
- [Setup a supported Kubernetes cluster](https://docs.radapp.io/guides/operations/kubernetes/overview/#supported-clusters)
- [Dapr installed on your Kubernetes cluster](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-deploy/)

## Step 1: Start with a container with a Dapr sidecar

Begin by creating a file named `app.bicep` with a defined Radius container and a Dapr sidecar, if you need a in-depth walkthrough see the ['How-To: Add a Dapr sidecar to a container' guide]({{< ref how-to-dapr-sidecar >}}):

{{< rad file="./snippets/app-sidecar.bicep" embed=true >}}

## Step 2: Add a Dapr state store resource

Now add a Dapr state store resource, which models a [Dapr state store component](https://docs.dapr.io/developing-applications/building-blocks/state-management/state-management-overview/):

{{< rad file="./snippets/app-statestore.bicep" embed=true marker="//STATESTORE" >}}

## Step 3: Add a connection from the container resource to the Dapr state store resource

Update your container resource with a connection to the Dapr state store. This will inject important connection information (the component name) into the container's environment variables:

{{< rad file="./snippets/app-statestore.bicep" embed=true marker="//CONTAINER" >}}

> Note this guide leverages the Dapr state store [Radius Recipe]({{< ref "/guides/recipes/overview" >}}), the template configurations can be found in the [Radius Recipe repo](https://github.com/radius-project/recipes/tree/main).

## Step 3: Deploy the application

Deploy your application with the `rad` CLI:

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
I'd add a step here to open the sample container in your browser to see the injected environment variables from Dapr and to save/get some todo items using the statestore.
## Step 4: Verify the Dapr statestore

Run the command below to see all the pods running in your Kubernetes cluster:

```bash
dapr components -k
```

The console output should similar to:

```
⚠  In future releases, this command will only query the "default" namespace by default. Please use the --namespace flag for a specific namespace, or the --all-namespaces (-A) flag for all namespaces.
NAMESPACE     NAME        TYPE         VERSION  SCOPES  CREATED              AGE  
default-demo  statestore  state.redis  v1               2024-02-19 17:13.20  2m   
```

## Done

You've successfully deployed a Radius container with a Dapr sidecar and a Dapr statestore in the form of a Redis Cache!

## Cleanup

To delete your app, run the [rad app delete]({{< ref rad_application_delete >}}) command to cleanup the app and its resources, including the Recipe resources:

```bash
rad app delete -a demo
```

## Further reading

- [Dapr state management](https://docs.dapr.io/developing-applications/building-blocks/state-management/)
- [Dapr state store resource schema]({{< ref dapr-statestore >}})


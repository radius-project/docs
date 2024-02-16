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

- [Supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-kubernetes-clusters" >}})
- [rad CLI]({{< ref getting-started >}})
- [Dapr CLI](https://docs.dapr.io/getting-started/install-dapr-cli/)
- [Radius initialized with `rad init`]({{< ref howto-environment >}})
- [Dapr initialized with `dapr init -k`](https://docs.dapr.io/getting-started/install-dapr-selfhost/)

## Step 1: Start with a container with a Dapr sidecar

Begin by creating a file named `app.bicep` with a defined Radius container and a Dapr sidecar, if you need a in-depth walkthrough see the ['How-To: Add a Dapr sidecar to a container' guide]({{< ref how-to-dapr-sidecar >}}):

{{< rad file="../how-to-dapr-sidecar/snippets/app-sidecar.bicep" embed=true >}}

## Step 2: Add a Dapr state store resource

Now add a Dapr state store resource, which models a [Dapr state store component](https://docs.dapr.io/developing-applications/building-blocks/state-management/state-management-overview/):

{{< rad file="./snippets/app-statestore.bicep" embed=true marker="//STATESTORE" >}}

## Step 3: Add a connection from the container resource to the Dapr state store resource

Update your container resource with a connection to the Dapr state store. This will inject important connection information (the component name) into the container's environment variables:

{{< rad file="./snippets/app-statestore.bicep" embed=true marker="//CONTAINER" >}}

## Step 3: Deploy the application

Deploy your application with the `rad` CLI:

```bash
rad run ./app.bicep -a demo
```

Your console output should look similar to:

```bash
Building app.bicep...
Deploying template 'app.bicep' for application 'demo' and environment 'default' from workspace 'default'...

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

Run `kubectl get pods -n default-demo` to see all the pods running in your Kubernetes cluster:

```bash
kubectl get pods -n default-demo
```

The console output should similar to:

```bash
NAME                                 READY   STATUS    RESTARTS      AGE
redis-r5tcrra3d7uh6-7679cd55-j4sxj   2/2     Running   6 (18m ago)   25h
demo-5f69fff66c-jtdwz                2/2     Running   0             10m
```

## Done

You've successfully deployed a Radius container with a Dapr sidecar and a Dapr statestore in the form of a Redis Cache!

## Cleanup

Run the following command to delete your app, including the container and the state store:

```bash
rad app delete -a demo
```

## Further reading

- [Dapr state management](https://docs.dapr.io/developing-applications/building-blocks/state-management/)
- [Dapr state store resource schema]({{< ref dapr-statestore >}})


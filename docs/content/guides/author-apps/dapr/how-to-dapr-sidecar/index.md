---
type: docs
title: "How-To: Add a Dapr sidecar to a container"
linkTitle: "Add a Dapr sidecar"
description: "Learn how to add a Dapr sidecar to a Radius container"
weight: 200
categories: "How-To"
tags: ["Dapr"]
---

This how-to guide will provide an overview of how to:

- Leverage a [Dapr sidecar](https://docs.dapr.io/concepts/dapr-services/sidecar/) with your Radius Application

## Prerequisites

- [Supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-kubernetes-clusters" >}})
- [rad CLI]({{< ref getting-started >}})
- [Dapr CLI](https://docs.dapr.io/getting-started/install-dapr-cli/)
- [Radius initialized with `rad init`]({{< ref howto-environment >}})
- [Dapr initialized with `dapr init -k`](https://docs.dapr.io/getting-started/install-dapr-selfhost/)

## Step 1: Start with a container

Begin by creating a file named `app.bicep` with a Radius [container]({{< ref "guides/author-apps/containers" >}}):

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 2: Add a Dapr sidecar extension

Now add the Dapr sidecar extension, which enabled Dapr and adds a Dapr sidecar:

{{< rad file="snippets/app-sidecar.bicep" embed=true marker="//CONTAINER" >}}

## Step 3: Deploy the app

Deploy your application:

```bash
rad deploy ./app.bicep -a demo
```

Your console output should look similar to:

```
Building ./app.bicep...
Deploying template './app.bicep' for application 'demo' and environment 'default' from workspace 'default'...
Deployment In Progress... 
...                  demo           Applications.Core/containers
Deployment Complete
Resources:
   demo           Applications.Core/containers
```

## Step 4: Verify the Dapr sidecar

Run `dapr list -k` to list all Dapr pods in your Kubernetes cluster:

```bash
dapr list -k
```


The console output should look similar to:

```
NAMESPACE      APP ID    APP PORT   AGE  CREATED              
default-demo   demo      3000       29s  2023-11-30 21:52.59
```

## Done

You've successfully deployed a Radius container with a Dapr sidecar! You can now interact with Dapr building blocks and the Dapr API from your container.


## Cleanup

Run the following command to [delete]({{< ref "guides/deploy-apps/howto-delete" >}}) your app and container:
   
   ```bash
   rad app delete -a demo
   ```

## Further reading

- [Radius Dapr tutorial]({{< ref "tutorials/tutorial-dapr" >}})
- [Dapr in Radius containers]({{< ref "guides/author-apps/containers/overview#kubernetes" >}})
- [Dapr sidecar schema]({{< ref "reference/resource-schema/dapr-schema/dapr-extension" >}})
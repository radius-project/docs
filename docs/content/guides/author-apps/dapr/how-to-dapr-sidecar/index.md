---
type: docs
title: "How-To: Add a Dapr sidecar to Radius"
linkTitle: "Add a Dapr sidecar to Radius"
description: "Easily leverage a Dapr sidecar blocks in your application for code and infrastructure portability"
weight: 100
categories: "How-To"
tags: ["Dapr"]
---

This how-to guide will provide an overview of how to:

- Leverage a [Dapr sidecar](https://docs.dapr.io/concepts/dapr-services/sidecar/) with your Radius Application

## Prerequisites

- [rad CLI]({{< ref getting-started >}})
- [Radius initialized with `rad init`]({{< ref howto-environment >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Dapr](https://docs.dapr.io/getting-started/install-dapr-cli/)

## Step 1: Define a container

Begin by creating a file named `app.bicep` with a Radius [container]({{< ref "guides/author-apps/containers" >}})

## Step 2: Define the Dapr sidecar extension

Make sure your current Dapr sidecar process is running inside a Kubernetes cluster:

    ```
    daprd --app-id myapp
    ```

You'll need the following information `appId`, `appPort` and any additional `config` properties can be defined inside of your Radius container definition.

{{< rad file="snippets/app-sidecar.bicep" embed=true >}}

## Step 3: Deploy the Radius Application

1. Deploy and run your app:

   ```bash
   rad deploy ./app.bicep -a demo
   ```

   Your console output should look similar to:

   ```
   Building ./app.bicep...
   Deploying template './app.bicep' for application 'demo' and environment 'default' from workspace 'default'...

   Deployment In Progress... 

   ...                  backend         Applications.Core/containers

   Deployment Complete

   Resources:
      backend         Applications.Core/containers
   ```

You've now deployed a Radius container with an extension connection to a Dapr sidecar!

## Cleanup

Run the following command to [delete]({{< ref "guides/deploy-apps/howto-delete" >}}) your app and container:
   
   ```bash
   rad app delete -a demo
   ```

## Further reading

- [Radius Dapr tutorial]({{< ref "tutorials/tutorial-dapr" >}})
- [Dapr in Radius containers]({{< ref "guides/author-apps/containers/overview#kubernetes" >}})
- [Dapr sidecar schema]({{< ref "reference/resource-schema/dapr-schema/extension/" >}})
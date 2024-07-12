---
type: docs
title: "How To: Configure a gateway for routing internet traffic"
linkTitle: "Gateways"
description: "Learn how to expose a service to the internet via a gateway"
weight: 300
slug: 'gateways'
categories: "How-To"
---

This guide will walk you through how to setup a gateway for routing internet traffic to a service.

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension and Bicep configuration file]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})

## Step 1: Define a container

Begin by defining the service you wish to expose to the internet in a new file named `app.bicep`. This example uses the Radius demo container:

{{< rad file="snippets/app.bicep" embed=true marker="//FRONTEND" >}}

## Step 2: Add a gateway

Next, add a gateway to `app.bicep`, routing traffic to the root path ("/") to the frontend container. Note that when a hostname is not specified one is generated automatically.

{{< rad file="snippets/app.bicep" embed=true marker="//GATEWAY" >}}

## Step 3: Deploy the app

Deploy the application with [`rad deploy`]({{< ref "rad_run" >}}):

```bash
rad deploy app.bicep -a gatewaydemo
```

The gateway endpoint will be printed at the end of the deployment:

```
Building app.bicep...
   Deploying template './app.bicep' for application 'gatewaydemo' and environment 'default' from workspace 'default'...

   Deployment In Progress...

   Completed            gateway         Applications.Core/gateways
   Completed            frontend        Applications.Core/containers

   Deployment Complete

   Resources:
      gateway         Applications.Core/gateways
      frontend        Applications.Core/containers

    Public endpoint http://1.1.1.1.nip.io/
```

## Step 4: Interact with the application

Visit the endpoint to interact with the demo Radius container:

{{< image src="demo-screenshot.png" alt="Screenshot of the demo application" width="500px" >}}

## Done

Cleanup the application with ['rad app delete']({{< ref rad_application_delete >}}):

```bash
rad app delete gatewaydemo -y
```

## Further reading

- [Networking overview]({{< ref "/guides/author-apps/networking/overview" >}})
- [Gateway reference]({{< ref "/reference/resource-schema/core-schema/gateway" >}})

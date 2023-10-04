---
type: docs
title: "How-To: Connect to dependencies"
linkTitle: "Connect to dependencies"
description: "Learn how to connect to dependencies in your application via connections"
weight: 200
categories: "How-To"
tags: ["containers"]
---

This how-to guide will teach how to connect to your dependencies via [connections]({{< ref "guides/author-apps/containers#connections" >}})

## Prerequisites

- [Radius CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-the-radius-control-plane-and-the-radius-environment" >}})

## Step 1: Model an app and container

Create a new file named `app.bicep` and add an application and a [container]({{< ref "guides/author-apps/containers" >}}):

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 2: Add a Mongo database as a dependency

Next, add to `app.bicep` a [Mongo database]({{< ref "portable-resources#overview" >}}), leveraging the default "dev" Recipe:

{{< rad file="snippets/app-mongodb.bicep" embed=true marker="//DB" >}}


## Step 3: Connect to the Mongo database

Connections from a container to a resource result in environment variables for connection information automatically being set on the container. Update your container definition to add a connection to the new Mongo database:

{{< rad file="snippets/app-mongodb.bicep" embed=true marker="//CONTAINER" >}}

## Step 4: Deploy your app

1. Deploy your application to your environment:

   ```bash
   rad deploy ./app.bicep
   ```
1. Port-forward the container to your machine:

    ```bash
    rad resource expose containers mycontainer -a myapp --port 5000
    ```
1. Visit [localhost:5000](http://localhost:5000) in your browser. You should see the following page, now showing injected environment variables:

   <img src="./connections.png" alt="Screenshot of the app printing all the environment variables" width=1000px />
   
## Cleanup

Run `rad app delete` to cleanup your Radius application, container, and link:

```bash
rad app delete -a myapp
```

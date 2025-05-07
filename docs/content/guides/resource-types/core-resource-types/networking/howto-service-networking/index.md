---
type: docs
title: "How To: Service to service networking"
linkTitle: "Service networking"
description: "Learn how your Radius services can communicate with each other"
weight: 200
slug: 'service-networking'
categories: "How-To"
---

This guide will show you how two services can communicate with each other. In this example, we will have a frontend container service that communicates with a backend container service.

{{< image src="overview.png" alt="Diagram of the frontend talking to the backend over HTTP port 80" width="400px" >}}

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})

## Step 1: Define the services

First, define the containers in a file named `app.bicep`. We will define two services: `frontend` and `backend`:

{{< rad file="snippets/1-app.bicep" embed=true markdownConfig="{linenos=table}" >}}

Note the frontend container doesn't yet have a connection to the backend container. We will add that in the next step.

## Step 2: Add a connection

With the services defined, we can now add the connection between them. Add a connection to `frontend`:

{{< rad file="snippets/2-app.bicep" embed=true marker="//FRONTEND" markdownConfig="{linenos=table,hl_lines=[\"14-18\"],linenostart=5}" >}}

## Step 3: Deploy the application

Deploy the application using the `rad deploy` command:

```bash
rad run app.bicep -a networking-demo
```

You should see the application deploy successfully and the log stream start:

```
Building app.bicep...
Deploying template 'app.bicep' for application 'networking-demo' and environment 'default' from workspace 'default'...

Deployment In Progress...

Completed            backend         Applications.Core/containers
Completed            frontend        Applications.Core/containers

Deployment Complete

Resources:
    backend         Applications.Core/containers
    frontend        Applications.Core/containers

Starting log stream...
```

## Step 4: Test the connection

Visit [http://localhost:3000](http://localhost:3000) in your browser. You should see a connection to the backend container, along with the environment variables that have automatically been set on the frontend container:

{{< image src="backend-connection.png" alt="Screenshot of the demo container showing the backend connections" width="600px" >}}

## Done

You have successfully added a connection between two containers. Make sure to delete your application to clean up the containers:

```bash
rad app delete networking-demo -y
```

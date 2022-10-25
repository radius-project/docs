---
type: docs
title: "Project Radius Tutorial"
linkTitle: "Tutorial"
description: "Walk through an in-depth example to learn about Project Radius"
weight: 100
no_list: true
---

## Steps

This tutorial will teach you how to deploy a "Rad-ified" website. You will learn:

{{< cardpane width=70% >}}
{{< card header="**1. Setup an environment**" footer="Deploy a [Radius environment]({{< ref environments >}}) to your Kubernetes cluster" >}}
<img src="illustration-tools.png" alt="Illustration of tooling" /><br />
{{< /card >}}
{{< card header="**2. Model an application**" footer="Leverage a [Radius application]({{< ref appmodel-concept >}}) to model, deploy, and manage your app" >}}
<img src="illustration-appmodel.png" width=90% alt="Illustration of app model" /><br />
{{< /card >}}
{{< card header="**3. Achieve infrastructure portability**"  footer="Leverage [Radius connectors]({{< ref connectors >}}) to easily deploy across platforms and clouds">}}
<img src="illustration-deploy.png" alt="Illustration of deploying app" /><br />
{{< /card >}}
{{< /cardpane >}}

## Application overview

You will be deploying an application, `todoapp`, with the following resources:

<img src="diagram-app.png" width=900px alt="Diagram of the tutorial application">

### `frontend` container

The example website is a single-page-application (SPA) with a Node.JS backend running in a [container]({{< ref container >}}). The SPA sends HTTP requests to the Node.JS backend to read and store todo items.

The website listens on port 3000 for HTTP requests.

The website uses the MongoDB protocol to read and store data in a database. The website reads the environment variable `CONNECTION_ITEMSTORE_CONNECTIONSTRING` to discover the database connection string. If the connection string is not set the website will store the todo items in memory and not persist them.

### `frontend-route` HttpRoute

An [HttpRoute]({{< ref httproute >}}) is used to define communication to the container app `frontend`.

### `gateway` Gateway

In order for users to connect to `todoapp` over the internet, a [Gateway]({{< ref gateway >}}) is used to define the appropriate route paths.

### `db` Connector

The database is provided by a [MongoDB connector]({{< ref mongodb >}}). You can choose between a MongoDB container or an Azure CosmosDB w/ Mongo API to back the connector.

## The Radius mindset

Deployment often involves different teams working together, separating their responsibilities. For example, a developer might build the app definition with services, while the infrastructure administrator might set up the environment and the infrastructure. In this tutorial you will build the app from the perspective of a developer and an infrastructure administrator.

As you progress, keep in mind the following benefits that the Radius application abstraction provides:

- Relationships between resources are fully specified with protocols and other strongly-typed information
- Connectors provide abstraction and portability across local and cloud environments
- Separation of concerns for the different personas involved in the deployment

<br>{{< button text="Begin the Tutorial" page="1-tutorial-environment" size="btn-lg" >}}

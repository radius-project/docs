---
type: docs
title: "Dapr microservices tutorial app overview"
linkTitle: "App overview"
slug: "overview"
description: "Overview of the Dapr microservices tutorial application"
weight: 1000
---

In this tutorial you will be deploying an online store where you can order items:

<img src="./store.png" alt="A screenshot of the store application" width=500 />

## Resources

This Radius application will have three [resouces]({{< ref resources-model.md >}}):

- A UI for users to place orders written with .NET Blazor (`frontend`)
- A backend order processing microservice written in Node.JS (`backend`)
- A Dapr state store used to store the orders (`statestore`)

### `frontend` container

The user-facing UI app (`frontend`) offers a portal for users to place orders. Upon creating an order, `frontend` uses [Dapr service invocation](https://docs.dapr.io/developing-applications/building-blocks/service-invocation/service-invocation-overview/) to send requests to `nodeapp`.

The `frontend` container is configured with a [Dapr sidecar trait]({{< ref dapr-trait >}}) to add the sidecar container.

<img src="./frontend.png" alt="A diagram of the complete application" width=400 />

### `backend` container

The order processing microservice (`backend`) accepts HTTP requests to create or display orders. It accepts HTTP requests on two endpoints: `GET /order` and `POST /neworder`.

The `backend` container is configured with a [Dapr sidecar trait]({{< ref dapr-trait >}}) to add the sidecar container, along with a [Dapr Route](#routes) to model Dapr communication.

<img src="./backend.png" alt="A diagram of the backend order processing service" width=600 />

### `statestore` Dapr state store

The [Dapr state store]({{< ref dapr-statestore >}}) resource (`statestore`) stores information about orders. It could be any compatible [Dapr state store](https://docs.dapr.io/developing-applications/building-blocks/state-management/state-management-overview/).

The Dapr component configuration is automatically generated for the statestore based on the values provided in the app model.

<img src="./statestore.png" alt="A diagram of the Dapr state store" width=400 />

## Routes

Radius offers communication between services via [Routes]({{< ref "connections-model#routes" >}}).

### Dapr service invocation

In this tutorial we will be using a [`dapr.io.InvokeHttpRoute`]({{< ref dapr-http >}}) resource to model communication from `frontend` to `backend`. This allows `frontend` to use Dapr service invocation to interact with `backend`.

<img src="./invoke.png" alt="A diagram of the Dapr service invocation" width=500 />

## Summary

In this tutorial, you will learn how Project Radius offers:

- Compute services, such as a container, to model your running code
- Relationships between resources that are fully specified with protocols and other strongly-typed information
- Connector and Route resources for [Dapr building blocks]({{< ref dapr >}})
- Automatically generated Dapr component configuration

<br>{{< button text="Next: Deploy the application backend" page="dapr-microservices-initial-deployment.md" >}}

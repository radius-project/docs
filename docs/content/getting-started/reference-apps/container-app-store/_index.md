---
type: docs
title: "Container App Store Microservice sample"
linkTitle: "Container App Store"
description: "Learn how to model and deploy multiple microservices with Radius and Dapr"
weight: 200
---

## Background

This reference application originally comes from the official Azure Github repo [Container App Store Microservice](https://github.com/Azure-Samples/container-apps-store-api-microservice) and contains microservices written in Python, Go, and NodeJS. It uses Dapr to communicate between services.

### Architecture

<img src="container-app-store-radius.png" alt="Architecture diagram of container app store on Radius" width=900 ><br >

This is a sample microservice solution to showcase how Radius can be incorporated into container applications. It will create a store microservice which calls into an order service and an inventory service. Dapr is used to secure communication and calls between services, and a mongoDB is created alongside the microservices.

There are three main microservices in the solution:

**Store API (node-app)**

The `node-app` is an express.js API that exposes three endpoints. `/` returns the primary index > page, `/order` returns details on an order (retrieved from the order service), and `/inventory` returns details on an inventory item (retrieved from the inventory service).

**Order Service (python-app)**

The `python-app` is a Python flask app that retrieves and stores the state of orders. It uses Dapr state management to store the state of the orders. When deployed, Dapr is configured to point to a mongoDB to back the state.

**Inventory Service (go-app)**

The `go-app` is a Go mux app that retrieves and stores the state of inventory. For this sample, the mux app just returns a static value.

## Adding Radius

Adding Project Radius to the container app store application allows teams to:

- Define the 3 microservices and backing infrastructure as a single application
- Easily manage configuration and credentials between infrastructure and services, all within the app model
- Simplify deployment with Bicep and Azure Resource Manager (ARM)

{{< button text="View container app store reference app in samples" githubRepo="samples" githubPath="reference-apps/container-app-store" color="success" size="btn-lg" >}}

*Visit the [GitHub docs]({{< ref github >}}) if you need access to the organization*

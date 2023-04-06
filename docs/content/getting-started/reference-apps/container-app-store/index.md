---
type: docs
title: "Container App Store Microservice sample"
linkTitle: "Container App Store"
description: "Learn how to model and deploy multiple microservices with Radius and Dapr"
weight: 200
---

{{% alert title="Preview" color="info" %}}
The following sample is a preview of how microservices and Dapr can be deployed with Radius. As we introduce additional features to Radius we will incorporate them into this demo.
{{% /alert %}}

## Background

This reference application originally comes from the official Azure Github repo [Container App Store Microservice](https://github.com/Azure-Samples/container-apps-store-api-microservice) and contains microservices written in Python, Go, and NodeJS. It uses Dapr to communicate between services.

### Architecture

<img src="container-app-store-radius.png" alt="Architecture diagram of container app store on Radius" width=900 ><br >

This is a sample microservice solution to showcase how Radius can be incorporated into container applications. It will create a store microservice which will need to call into an order service and an inventory service. Dapr is used to secure communication and calls between services, and a mongoDB are created alongside the microservices.

There are three main microservices in the solution:

**Store API (node-app)**

The node-app is an express.js API that exposes three endpoints. / will return the primary index > page, /order will return details on an order (retrieved from the order service), and /inventory > will return details on an inventory item (retrieved from the inventory service).

**Order Service (python-app)**

The python-app is a Python flask app that will retrieve and store the state of orders. It uses Dapr state management to store the state of the orders. When deployed in Container Apps, Dapr is configured to point to a mongoDB to back the state.

**Inventory Service (go-app)**

The go-app is a Go mux app that will retrieve and store the state of inventory. For this sample, the mux app just returns back a static value.

## Deployment today

There are two options for [deploying the Container App Store Microservice](https://github.com/Azure-Samples/container-apps-store-api-microservice#deploy-and-run) without Radius: GitHub Actions or the Azure CLI.

## Adding Radius

Adding Project Radius to the container app store application allows teams to:

- Define the 3 microservices and backing infrastructure as a single application
- Easily manage configuration and credentials between infrastructure and services, all within the app model
- Simplify deployment with Bicep and Azure Resource Manager (ARM)

{{< button text="View container app store reference app in samples" githubRepo="samples" githubPath="reference-apps/container-app-store" color="success" size="btn-lg" >}}

*Visit the [GitHub docs]({{< ref github >}}) if you need access to the organization*

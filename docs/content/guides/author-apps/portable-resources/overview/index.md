---
type: docs
title: "Overview: Portable Resources"
linkTitle: "Overview"
description: "Add portable resources to your Radius Application for infrastructure portability"
weight: 600
categories: "Overview"
tags: ["portability"]
---

## Overview

Portable resources provide **abstraction** and **portability** to Radius Applications. This allows development teams to depend on high level resource types and APIs, and let infra teams swap out the underlying resource and configuration.

<img src="./portable-resources.png" alt="Diagram of portable resources connecting to Azure CosmosDB, AWS MongoDB, and a MongoDB Docker container" width=700px />

## Available resources

The following portable resources are available to use within your application:

- [`Applications.Core/extenders`]({{< ref api-extenders >}})
- [`Applications.Datastores/mongoDatabases`]({{< ref api-mongodatabases >}})
- [`Applications.Datastores/redisCaches`]({{< ref api-rediscaches >}})
- [`Applications.Datastores/sqlDatabases`]({{< ref api-sqldatabases >}})
- [`Applications.Dapr/pubSubBrokers`]({{< ref api-pubsubbrokers >}})
- [`Applications.Dapr/secretStores`]({{< ref "/reference/api/applications.dapr/api-secretstores" >}})
- [`Applications.Dapr/stateStores`]({{< ref api-statestores >}})
- [`Applications.Messaging/rabbitmqQueues`]({{< ref api-rabbitmqqueues >}})

## Reference

Refer to the [API reference docs]({{< ref api >}}) to learn more about the Radius API and the available portable resources plus their schema
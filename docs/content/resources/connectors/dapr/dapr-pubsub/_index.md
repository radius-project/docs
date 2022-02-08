---
type: docs
title: "Dapr Pub/Sub resource"
linkTitle: "Pub/Sub Topic"
description: "Learn how to use Dapr Pub/Sub resources in Radius"
weight: 300
slug: "pubsub"
---

## Overview

A `dapr.io/PubSubTopic` resource represents a [Dapr pub/sub](https://docs.dapr.io/developing-applications/building-blocks/pubsub/pubsub-overview/) topic.

This resource will automatically create and deploy the Dapr component spec for the specified kind.

{{< rad file="snippets/dapr-pubsub-servicebus.bicep" embed=true marker="//SAMPLE" >}}

| Property | Description | Example |
|----------|-------------|---------|
| name | The name of the pub/sub | `my-pubsub` |
| properties | Properties of the pub/sub | See [Properties](#properties) below |

### Properties

| Property | Description | Example |
|----------|-------------|---------|
| kind | The kind of the underlying pub/sub resource. See [Available Dapr components](#available-dapr-components) for more information. | `pubsub.azure.servicebus`
| resource | The ID of the mesage broker, if a non-generic `kind` is used. | `namespace::topic.id`
| type | The Dapr component type. Used when kind is `generic`. | `pubsub.kafka` |
| metadata | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-pubsub/) | `brokers: kafkaRoute.properties.url` |
| version | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-pubsub/) for available versions. | `v1` |

## Avilable Dapr components

The following resources can act as a `dapr.io.PubSubTopic` kinds:

| kind | Resource |
|------|----------|
| `state.azure.servicebus` | [Azure Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview)
| `generic` | [Any Dapr pub/sub component](https://docs.dapr.io/reference/components-reference/supported-pubsub/)

### Azure Service Bus Topic

An Azure Service Bus Topic can be used as a Dapr Pub/Sub message broker. Simply provide the topic ID to the Dapr Pub/Sub resources, and the Dapr component spec will automatically be generated and deployed:

{{< rad file="snippets/dapr-pubsub-servicebus.bicep" embed=true marker="//SAMPLE" >}}

### Generic

A generic pub/sub lets you manually specify the metadata of a Dapr pub/sub broker. When `kind` is set to `generic`, you can specify `type`, `metadata`, and `version` to create a Dapr component spec. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-pubsub/).

{{< rad file="snippets/dapr-pubsub-kafka.bicep" embed=true marker="//SAMPLE" >}}

## Starter

You can get up and running quickly with a Dapr Pub/Sub topic by using a [starter]({{< ref starter-templates >}}):

{{< rad file="snippets/starter.bicep" embed=true >}}

### Container

The Dapr Pub/Sub container starter uses a Redis container and can run on any Radius platform.

```
br:radius.azurecr.io/starters/dapr/pubsub:latest
```

#### Input parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the PubSub Topic | Yes | - |
| pubSubName | The name of the PubSub Topic | No | `deployment().name` (module name) |

#### Output parameters

| Parameter | Description | Type |
|----------|-------------|------|
| pubSub | The PubSub Topic resource | `radius.dev/Application/dapr.io.PubSubTopic@v1alpha3` |

### Microsoft Azure

The Dapr Pub/Sub Azure Service Bus starter uses an Azure Service Bus Topic and can run only on Azure.

```txt
br:radius.azurecr.io/starters/dapr/pubsub-azure-servicebus:latest
```

### Input parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the PubSub Topic | Yes | - |
| pubSubName | The name of the PubSub Topic | No | `deployment().name` (module name) |
| serviceBusName | The name of the underlying Azure Service Bus namespace | No | `'servicebus-${uniqueString(resourceGroup().id, deployment().name)}'` |
| queueName | The name of the underlying Azure Service Bus queue | No | `'dapr'` |
| location | The Azure region to deploy the Azure Service Bus | No | `resourceGroup().location` |

### Output parameters

| Parameter | Description | Type |
|-----------|-------------|------|
| pubSub | The PubSub Topic resource | `radius.dev/Application/dapr.io.PubSubTopic@v1alpha3` |

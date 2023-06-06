---
type: docs
title: "Dapr Pub/Sub resource"
linkTitle: "Publish/subscribe"
description: "Learn how to use Dapr Pub/Sub in Radius"
weight: 300
slug: "pubsub"
---

## Overview

A `Applications.Link/daprPubSubBrokers` resource represents a [Dapr pub/sub](https://docs.dapr.io/developing-applications/building-blocks/pubsub/pubsub-overview/) topic.

This resource will automatically create and deploy the Dapr component spec for the specified kind.

{{< rad file="snippets/dapr-pubsub-servicebus.bicep" embed=true marker="//SAMPLE" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of the pub/sub. Names must contain at most 63 characters, contain only lowercase alphanumeric characters, '-', or '.', start with an alphanumeric character, and end with an alphanumeric character. | `my-pubsub` |
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| application | n | The ID of the application resource this resource belongs to. | `app.id`
| environment | y | The ID of the environment resource this resource belongs to. | `env.id`
| resourceProvisioning | n | Specifies how the underlying service/resource is provisioned and managed. Options are to provision automatically via 'recipe' or provision manually via 'manual'. Selection determines which set of fields to additionally require. | `manual`
| [recipe](#recipe)  | n | The recipe to deploy. | `pubsub.id`
| [resources](#resources)  | n | An array of IDs of the underlying resources for the link, in this case could contain the ID of the message broker resource, if a non-generic `kind` is used. | [See below](#resources)
| type | n | The Dapr component type. Used when resourceProvisioning is `manual`. | `pubsub.kafka` |
| metadata | n | Metadata for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-pubsub/) | `brokers: kafkaRoute.properties.url` |
| version | n | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-pubsub/) for available versions. | `v1` |
| componentName | n | _(read-only)_ The name of the Dapr component that is generated and applied to the underlying system. Used by the Dapr SDKs or APIs to access the Dapr component. | `myapp-mypubsub` |

## Resource backed Link

The following resources can be used to automatically generate the Link:

- [Azure Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview).

### Azure Service Bus Topic

An Azure Service Bus Topic can be used as a Dapr Pub/Sub message broker. Simply specify the namespace ID as the `resource` value, and the Dapr component spec will automatically be generated and deployed:

{{< rad file="snippets/dapr-pubsub-servicebus.bicep" embed=true marker="//SAMPLE" >}}

## Value backed Link

You can also manually specify the metadata of a Dapr PubSub. When `resourceProvisioning` is set to `manual`, you can specify `type`, `metadata`, and `version` to create a Dapr component spec. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-pubsub/).

{{< rad file="snippets/dapr-pubsub-kafka.bicep" embed=true marker="//SAMPLE" >}}

## Injected values

Connections from [Radius services]({{< ref container >}}) to [links]({{< ref links-resources >}}) by default inject the following values into the environment of the service:

| Key | Value |
|-----|-------|
| `CONNECTION_<CONNECTIONNAME>_COMPONENTNAME` | `properties.componentName` |

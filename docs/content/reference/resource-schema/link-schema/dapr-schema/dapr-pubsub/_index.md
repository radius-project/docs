---
type: docs
title: "Dapr Pub/Sub resource"
linkTitle: "Publish/subscribe"
description: "Learn how to use Dapr Pub/Sub in Radius"
weight: 300
slug: "pubsub"
---

## Overview

An `Applications.Link/daprPubSubBrokers` resource represents a [Dapr pub/sub](https://docs.dapr.io/developing-applications/building-blocks/pubsub/pubsub-overview/) message broker.

## Resource format

{{< tabs Recipe Manual >}}

{{< codetab >}}

{{< rad file="snippets/dapr-pubsub-recipe.bicep" embed=true marker="//SAMPLE" >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/dapr-pubsub-manual.bicep" embed=true marker="//SAMPLE" >}}

{{< /codetab >}}

{{< /tabs >}}

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
| [resourceProvisioning](#resource-provisioning) | n | Specifies how the underlying service/resource is provisioned and managed. Options are to provision automatically via 'recipe' or provision manually via 'manual'. Selection determines which set of fields to additionally require. Defaults to 'recipe'. | `manual`
| [recipe](#recipe) | n | Configuration for the Recipe which will deploy the backing infrastructure. | [See below](#recipe)
| [resources](#resources) | n | An array of resources which underlay this resource. For example, an Azure Service Bus namespace ID if the Dapr Pub/Sub resource is leveraging Service Bus. | [See below](#resources)
| type | n | The Dapr component type. Set only when resourceProvisioning is 'manual'. | `pubsub.kafka` |
| metadata | n | Metadata object for the Dapr component. Schema must match [Dapr component](https://docs.dapr.io/reference/components-reference/supported-pubsub/). Set only when resourceProvisioning is 'manual'. | `{ brokers: kafkaRoute.properties.url }` |
| version | n | The version of the Dapr component. See [Dapr components](https://docs.dapr.io/reference/components-reference/supported-pubsub/) for available versions. Set only when resourceProvisioning is 'manual'. | `v1` |
| componentName | n | _(read-only)_ The name of the Dapr component that is generated and applied to the underlying system. Used by the Dapr SDKs or APIs to access the Dapr component. | `mypubsub` |

#### Recipe

| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| name | n | Specifies the name of the Recipe that should be deployed. If not set, the name defaults to `default`. | `name: 'azure-prod'`
| parameters | n | An object that contains a list of parameters to set on the Recipe. | `{ size: 'large' }`

#### Resources

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| id | n | Resource ID of the supporting resource. | `account.id`

## Resource provisioning

### Provision with a Recipe

[Recipes]({{< ref "/author-apps/recipes" >}}) automate infrastructure provisioning using approved templates.

You can specify a Recipe name that is registered in the environment or omit the name and use the "default" Recipe.

Parameters can also optionally be specified for the Recipe.

### Provision manually

If you want to manually manage your infrastructure provisioning outside of Recipes, you can set `resourceProvisioning` to `'manual'` and specify `type`, `metadata`, and `version` for the Dapr component. These values must match the schema of the intended [Dapr component](https://docs.dapr.io/reference/components-reference/supported-pubsub/).

## Environment variables for connections

Other Radius resources, such as [containers]({{< ref "container" >}}), may connect to a Dapr pub/sub resource via [connections]({{< ref "application-graph#connections-and-injected-values" >}}). When a connection to Dapr pub/sub named, for example, `myconnection` is declared, Radius injects values into environment variables that are then used to access the connected Dapr pub/sub resource:

| Environment variable | Example(s) |
|----------------------|------------|
| CONNECTION_MYCONNECTION_COMPONENTNAME | `mypubsub` |
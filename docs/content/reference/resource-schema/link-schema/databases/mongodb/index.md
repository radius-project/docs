---
type: docs
title: "MongoDB database link"
linkTitle: "MongoDB"
description: "Learn how to use a MongoDB link in your application"
categories: "Reference"
---

The `mongodb.com/MongoDatabase` link is a [portable link]({{< ref links-resources >}}) which represents a Mongo Database.

## Resource format

{{< tabs Recipe Values >}}

{{< codetab >}}

{{< rad file="snippets/mongo-recipe.bicep" embed=true marker="//MONGO" >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/mongo-values.bicep" embed=true marker="//MONGO" >}}

{{< /codetab >}}

{{< /tabs >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. | `mongo`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| application | n | The ID of the application resource this resource belongs to. | `app.id`
| environment | y | The ID of the environment resource this resource belongs to. | `env.id`
| resourceProvisioning | n | Specifies how the underlying service/resource is provisioned and managed. Options are to provision automatically via 'recipe' or provision manually via 'manual'. Selection determines which set of fields to additionally require. | `manual`
| [recipe](#recipe)  | n | Configuration for the Recipe which will deploy the backing infrastructure. | [See below](#recipe)
| [resources](#resources)  | n | An array of resources which underlay this resource. For example, an Azure CosmosDB database ID if the Mongo resource is leveraging CosmosDB. | [See below](#resources)
| host | n | The MongoDB host name. | `mongo.hello.com`
| port | n | The MongoDB port. | `4242`
| [secrets](#secrets) | n | Secrets used when building the link from values. | [See below](#secrets)

## Recipe infrastructure provisioning

[Recipes]({{< recipes >}}) automate infrastructure provisioning using approved templates.
When no Recipe configuration is set Radius will use the default Recipe in the environment.
Otherwise, a Recipe name and parameters can optionally be set.

### Secrets

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| connectionString | n | The connection string for the MongoDb. Write only. | `'https://mymongo.cluster.svc.local,password=*****,....'`
| username | n | The username for the MongoDb. Write only. | `'myusername'`
| password | n | The password for the Redis cache. Write only. | `'mypassword'`

## Methods

The following methods are available on the Redis link:

| Method | Description |
|--------|-------------|
| connectionString() | Get the connection string for the MongoDb. |
| username() | Get the username for the MongoDb. |
| password() | Get the password for the MongoDb. |

## Connections

[Services]({{< ref container >}}) can define [connections]({{< ref appmodel-concept >}}) to links using the `connections` property. This allows the service to access properties of the link and contributes to to visualization and health experiences.

### Environment variables

Connections to the MongoDatabase link result in the following environment variables being set on your service:

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-CONNECTIONSTRING` | The connection string for the MongoDB. |

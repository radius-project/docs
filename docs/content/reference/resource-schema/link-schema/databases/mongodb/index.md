---
type: docs
title: "MongoDB database link"
linkTitle: "MongoDB"
description: "Learn how to use a MongoDB link in your application"
---

The `mongodb.com/MongoDatabase` link is a [portable link]({{< ref links >}}) which can be deployed to any platform Radius supports.

## Resource format

{{< tabs Resource Values >}}

{{< codetab >}}
{{< rad file="snippets/mongo-resource.bicep" embed=true marker="//MONGO" >}}
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
| resource  | n | The ID of the underlying resource for the link. Used when building the link from a resource. | `cosmosDatabase.id`
| host | n | The MongoDB host name. | `mongo.hello.com`
| port | n | The MongoDB port. | `4242`
| [secrets](#secrets) | n | Secrets used when building the link from values. | [See below](#secrets)

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

## Supported resources

The following resources are supported when building the link from a resource using the `resource` property:

- [Azure CosmosDB API for MongoDB](https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb-introduction)

## Connections

[Services]({{< ref container >}}) can define [connections]({{< ref appmodel-concept >}}) to links using the `connections` property. This allows the service to access properties of the link and contributes to to visualization and health experiences.

### Environment variables

Connections to the MongoDatabase link result in the following environment variables being set on your service:

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-CONNECTIONSTRING` | The connection string for the MongoDB. |

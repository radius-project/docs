---
type: docs
title: "MongoDB database connector"
linkTitle: "MongoDB"
description: "Learn how to use a MongoDB connector in your application"
---

The `mongodb.com/MongoDatabase` connector is a [portable connector]({{< ref connectors >}}) which can be deployed to any platform Radius supports.

## Supported resources

- [MongoDB container](https://hub.docker.com/_/mongo/)
- [Azure CosmosDB API for MongoDB](https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb-introduction)

## Resource format

### Properties

A `resource` or set of `secrets` must be set to configure a MongoDB connector. Azure resources use `resource`, where properties and secrets are automatically generated from the Azure resource. Other workloads must manually configure `secrets`.

| Property | Description | Example |
|----------|-------------|---------|
| resource | The ID of a CosmosDB with Mongo API database to use for this connector. | `account::mongodb.id`
| secrets  | Configuration used to manually specify a Mongo container or other service providing a MongoDB. | See [secrets](#secrets) below.

#### Secrets

Secrets are used when defining a MongoDB connector with a non-Azure Mongo service, such as a container.

| Property | Description | Example |
|----------|-------------|---------|
| connectionString | The connection string to the MongoDB. Recommended to use parameters and variables to craft. | `mongodb://${userName}:${password}@${container.spec.hostname}:...`
| username | The username to use when connecting to the MongoDB. | `admin`
| password | The password to use when connecting to the MongoDB. | `password`

### Provided data

#### Functions

Secrets must be accessed via Bicep functions to ensure they're not leaked or logged.

| Bicep function | Description | Example |
|----------------|-------------|---------|
| `connectionString()` | Returns the connection string for the MongoDB. | `mongodb.connectionString()` |
| `username()` | Returns the username for the MongoDB. | `mongodb.username()` |
| `password()` | Returns the password for the MongoDB. | `mongodb.password()` |

## Connections

[Services]({{< ref services >}}) can define [connections]({{< ref appmodel-concept >}}) to connectors using the `connections` property. This allows the service to access properties of the connector and contributes to to visualization and health experiences.

### Environment variables

Connections to the MongoDatabase connector result in the following environment variables being set on your service:

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-CONNECTIONSTRING` | The connection string for the MongoDB. |

## Starter

You can get up and running quickly with a Mongo Database by using a starter:

{{% alert title="Known issue: dependsOn" color="warning" %}}
Any service that consumes the `existing` resource will need to manually add a `dependsOn` reference to the starter module. This requirement will be removed in an upcoming release. See the [webapp tutorial]({{< ref webapp-add-database >}}) for an example.
{{% /alert %}}

### Container

The module `'br:radius.azurecr.io/starters/mongo:latest'` deploys Mongo container and outputs a `mongo.com.MongoDatabase` resource.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter.bicep" embed=true >}}

#### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the Mongo Database | Yes | - |
| dbName | The name for your Mongo Database connector | Yes | - |
| username | The username for your Mongo Database | No | `'admin'` |
| password | The password for your Mongo Database | No | `newGuid()` |

### Azure CosmosDB

The module `'br:radius.azurecr.io/starters/mongo-azure:latest'` deploys Mongo container and outputs a `mongo.com.MongoDatabase` resource.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter-azure.bicep" embed=true >}}

### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the Mongo Database | Yes | - |
| dbName | The name for your Mongo Database connector | Yes | - |
| accountName | The name for your Azure CosmosDB | No | `'cosmos-${uniqueString(resourceGroup().id, deployment().name)}'` |
| location | The Azure region to deploy the Azure CosmosDB | No | `resourceGroup().location` |
| dbThroughput | The throughput for your Azure CosmosDB | No | `400` |

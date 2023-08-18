---
type: docs
title: "MongoDB database link"
linkTitle: "MongoDB"
description: "Learn how to use a MongoDB link in your application"
---

## Overview

The `mongodb.com/MongoDatabase` link is a [portable link]({{< ref portable-resources >}}) which represents a Mongo Database.

## Resource format

{{< tabs Recipe Manual >}}

{{< codetab >}}

{{< rad file="snippets/mongo-recipe.bicep" embed=true marker="//MONGO" >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/mongo-manual.bicep" embed=true marker="//MONGO" >}}

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
| [resourceProvisioning](#resource-provisioning) | n | Specifies how the underlying service/resource is provisioned and managed. Options are to provision automatically via 'recipe' or provision manually via 'manual'. Selection determines which set of fields to additionally require. Defaults to 'recipe'. | `manual`
| [recipe](#recipe) | n | Configuration for the Recipe which will deploy the backing infrastructure. | [See below](#recipe)
| [resources](#resources) | n | An array of resources which underlay this resource. For example, an Azure CosmosDB database ID if the MongoDB resource is leveraging CosmosDB. | [See below](#resources)
| database | n | Database name of the target MongoDB | `mongodb-prod`
| host | n | The MongoDB host name. | `mongodb0.example.com`
| port | n | The MongoDB port. | `4242`
| username | n | The username for the MongoDB. | `'myusername'`
| [secrets](#secrets) | n | Secrets used when building the link from values. | [See below](#secrets)

#### Recipe

| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| name | n | Specifies the name of the Recipe that should be deployed. If not set, the name defaults to `default`. | `name: 'azure-prod'`
| parameters | n | An object that contains a list of parameters to set on the Recipe. | `{ size: 'large' }`

#### Resources

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| id | n | Resource ID of the supporting resource. | `account.id`

#### Secrets

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| connectionString | n | The connection string for the MongoDb. Write only. | `mongodb://myDBReader:D1fficultP%40ssw0rd@mongodb0.example.com:4242/?authSource=admin`
| password | n | The password for the MongoDB. Write only. | `mypassword`

### Methods

The following methods are available on the MongoDB link:

| Method | Description |
|--------|-------------|
| connectionString() | Get the connection string for the MongoDb. |
| username() | Get the username for the MongoDB. |
| password() | Get the password for the MongoDB. |

## Resource provisioning

### Provision with a Recipe

[Recipes]({{< ref "/recipes/overview" >}}) automate infrastructure provisioning using approved templates.
You can specify a Recipe name that is registered in the environment or omit the name and use the "default" Recipe.

Parameters can also optionally be specified for the Recipe.

### Provision manually

If you want to manually manage your infrastructure provisioning outside of Recipes, you can set `resourceProvisioning` to `'manual'` and provide all necessary parameters and values in order for Radius to be able to deploy/connect to the desired infrastructure.

## Environment variables for connections

Other Radius resources, such as [containers]({{< ref "/author-apps/containers" >}}), may connect to a MongoDB resource via [connections]({{< ref "application-graph#connections-and-injected-values" >}}). When a connection to MongoDB named, for example, `myconnection` is declared, Radius injects values into environment variables that are then used to access the connected MongoDB resource:

| Environment variable | Example(s) |
|----------------------|------------|
| CONNECTION_MYCONNECTION_HOST | `mongodb0.example.com` |
| CONNECTION_MYCONNECTION_PORT | `4242` |
| CONNECTION_MYCONNECTION_DATABASE | `mongodb-prod` |
| CONNECTION_MYCONNECTION_USERNAME | `myusername` |
| CONNECTION_MYCONNECTION_PASSWORD | `mypassword` |
| CONNECTION_MYCONNECTION_CONNECTIONSTRING | `mongodb://myDBReader:D1fficultP%40ssw0rd@mongodb0.example.com:4242/?authSource=admin` |
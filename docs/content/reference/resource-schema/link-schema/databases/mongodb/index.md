---
type: docs
title: "MongoDB database link"
linkTitle: "MongoDB"
description: "Learn how to use a MongoDB link in your application"
categories: "Reference"
---

## Overview

The `mongodb.com/MongoDatabase` link is a [portable link]({{< ref links-resources >}}) which represents a Mongo Database.

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
| [resourceProvisioning](#resource-provisioniong) | n | Specifies how the underlying service/resource is provisioned and managed. Options are to provision automatically via 'recipe' or provision manually via 'manual'. Selection determines which set of fields to additionally require. | `manual`
| [recipe](#recipe) | n | Configuration for the Recipe which will deploy the backing infrastructure. | [See below](#recipe)
| resources | n | An array of resources which underlay this resource. For example, an Azure CosmosDB database ID if the MongoDB resource is leveraging CosmosDB. | `[ { id: cosmosDB.id } ]`
| host | n | The MongoDB host name. | `mongo.hello.com`
| port | n | The MongoDB port. | `4242`
| [secrets](#secrets) | n | Secrets used when building the link from values. | [See below](#secrets)

#### Recipe

##### Default

```bicep
resource db 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    application: app.id
  }
}
```

##### Explicit

```bicep
resource db 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    application: app.id
    recipe: {
      // Name a specific Recipe to use
      name: 'azure-cosmosdb'
      // Set optional/required parameters (specific to the Recipe)
      parameters: {
        size: 'large'
      }
    }
  }
}
```

#### Secrets

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| connectionString | n | The connection string for the MongoDb. Write only. | `'https://mymongo.cluster.svc.local,password=*****,....'`
| username | n | The username for the MongoDB. Write only. | `'myusername'`
| password | n | The password for the MongoDB. Write only. | `'mypassword'`

### Methods

The following methods are available on the MongoDB link:

| Method | Description |
|--------|-------------|
| connectionString() | Get the connection string for the MongoDb. |
| username() | Get the username for the MongoDB. |
| password() | Get the password for the MongoDB. |


## Resource provisioniong

### Provision with Recipes

[Recipes]({{< ref recipes-overview>}}) automate infrastructure provisioning using approved templates.
When no Recipe configuration is set Radius will use the Recipe registered as the **default** in the environment for the given resource. Otherwise, a Recipe name and parameters can optionally be set.

### Provision with manual

If you want to manually manage your infrastructure provisioning outside of Recipes, you can set `resourceProvisioning` to `'manual'` and provide all necessary parameters and values in order for Radius to be able to deploy/connect to the desired infrastructure.
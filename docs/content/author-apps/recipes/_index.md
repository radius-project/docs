---
type: docs
title: "Radius Recipes"
linkTitle: "Recipes"
description: "Use Recipes for infrastructure deployment in your Radius application"
weight: 300
---

## Overview

Recipes enable a **separation of concerns** between infrastructure teams and developers by allowing for a **automated infrastructure deployment** that doesn't require developers to have infrastructure resource expertise. This abstraction is enabled by utilizing [Links]({{< ref links-concept >}}) as the connection to a Recipe.


<img src="dev-guide-recipes.png" alt="Diagram of showing a 'Dev' and 'Prod' Radius environment containing multiple templates and linking back to a Radius application with a Link" width=700px />

## Recipe capabilities

### Select any Recipe connected to your Radius environment

When a Recipe is created it contains a unique **name** identifier that enables discovery and usability throughout your Radius environment.

```bicep
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview'= {
  name: 'mylink'
  properties: {
    mode: 'recipe'
    recipe: {
      name: '<RECIPE-NAME-EXAMPLE>'
    }
  }
}
```
##### Identify all available  Recipes in your environment

List Recipes within an environment with [**rad recipe list**]({{< ref rad_recipe_list >}})

### Customize Recipes with parameters

Authors of a Recipe can allow for resource configuration parameters inside of a Recipe which allows for user customizability when initializing a Link.

```bicep
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview'= {
  name: 'mylink'
  properties: {
    mode: 'recipe'
    recipe: {
      name: 'prod'
      parameters: {
        location: 'global'
        minimumTlsVersion: '1.2'
      }
    }
  }
}
```

## Rad CLI commands

For a reference to all Recipe related CLI commands, please visit [**rad recipe**]({{< ref rad_recipe >}}).


## Authoring Recipes
{{% alert title="Warning" color="warning" %}}
Recipes are a work-in-progress and currently only support [Redis Cache Links]({{< ref redis >}})
{{% /alert %}}


To learn more about how to create your own custom Recipe visit the administrative Recipe guide.


## Example

{{% alert title="Prerequisite" color="info" %}}
Follow the administrative Recipe guide for information on how to add a Recipe to your Radius environment.
{{% /alert %}}

<h4>Create a Redis Link</h4>

```bicep
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview'= {
  name: 'mylink'
  properties: {
    mode: 'recipe'
    recipe: {
      name: 'prod'
      parameters: {
        location: 'global'
        minimumTlsVersion: '1.2'
      }
    }
  }
}
```

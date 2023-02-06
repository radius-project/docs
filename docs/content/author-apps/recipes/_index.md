---
type: docs
title: "Radius Recipes"
linkTitle: "Recipes"
description: "Use Recipes for infrastructure deployment in your Radius application"
weight: 300
---

## Overview

Recipes enable a **separation of concerns** between infrastructure teams and developers by allowing for a **automated infrastructure deployment** that doesn't require developers to have infrastructure resource expertise.

## Recipe capabilities

### Select any Recipes in your Radius environment

You can use any Recipes integrated into your Radius environment by  identifying them by name when defining a Link.


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
##### Find your Recipes

List Recipes within an environment with [**rad recipe list**]({{< ref rad_recipe_list >}})

### Customize Recipes with parameters

You can customize Recipes by passing resource configuration parameters inside your Link.

```bicep
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview'= {
  name: 'mylink'
  properties: {
    mode: 'recipe'
    recipe: {
      name: '<RECIPE-NAME-EXAMPLE>'
      parameters: {
        location: 'global'
        minimumTlsVersion: '1.2'
      }
    }
  }
}
```

## Supported resources

- `Applications.Link/redisCaches`

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

## Further Reading

- For a reference to all Recipe related CLI commands, please visit [**rad recipe**]({{< ref rad_recipe >}}).
- To learn more about how to create your own custom Recipe visit the administrative Recipe guide.

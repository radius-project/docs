---
type: docs
title: "Radius Recipes"
linkTitle: "Recipes"
description: "Automate infrastructure deployment for your resources with Radius recipes"
weight: 300
---

## Overview

Recipes enable a **separation of concerns** between infrastructure teams and developers by **automating infrastructure deployment**. Developers select the resource they want in their app (_Mongo Database, Redis Cache, Dapr State Store, etc._), and infrastructure teams codify how these resources should be deployed and configured (_lightweight containers, Azure resources, AWS resources, etc._). When a developer deploys their application and its resources, Recipes deploy the backing infrastructure and bind it to the developer's resources.

## Recipe capabilities

### Select the Recipe that meets your needs

Recipes can be used in any environment, from dev to prod. Simply specify `mode: 'recipe'` in your [Link resource](https://docs.radapp.dev/author-apps/links/), and select the Recipe you want to run:


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
Use [**rad recipe list**]({{< ref rad_recipe_list >}}) to view the Recipes available to you in your environment.

### Customize Recipes with parameters

Recipes can be customized with parameters, allowing developers to fine-tune infrastructure to meet their specific needs:

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

We currently support the following resources for Recipes. Support for additional resources is actively being worked on.

- `Applications.Link/redisCaches`


## Further Reading

- For a reference to all Recipe related CLI commands, please visit [**rad recipe**]({{< ref rad_recipe >}}).
- To learn more about how to create your own custom Recipe visit the administrative Recipe guide.

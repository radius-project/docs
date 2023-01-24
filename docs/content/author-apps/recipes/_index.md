---
type: docs
title: "Radius Recipes"
linkTitle: "Recipes"
description: "Leverage abstraction, portability and control in your Radius application with Recipes"
weight: 300
---

## Overview

Recipes are templates stored in container registries that can be deployed by [Links]({{< ref links-concept >}}). They leverage the **abstraction** and **portability** that Links provide Radius applications in order to allow for a separation of concerns between infra teams and developers. This allows for infra teams to define and configure resources in templates and allow for developers to deploy those resources without complexity.

<img src="recipes.png" alt="Diagram of a container registry containing multiple templates and linking back to a Radius application with a Link" width=700px />

### Example

The following examples show how a **link** can deploy a Recipe, which in deploys a Redis cache.

<h4>Recipe Template</h4>

In this example the following Recipe template is stored in a container registry:

{{< rad file="snippets/recipe-template.bicep" embed=true>}}

<h4>Link</h4>

A Redis link can be configured with parameters that are enabled by the infra team in each Recipe when needed:

{{< rad file="snippets/redis-container.bicep" embed=true >}}


## Recipe Guides

Check out the Radius Recipes quickstart docs to learn how to leverage links and Recipes in your application:

<!-- {{< button text="Link resources" page="link-schema" >}} -->

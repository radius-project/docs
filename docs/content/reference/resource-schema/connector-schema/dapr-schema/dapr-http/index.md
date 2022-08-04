---
type: docs
title: "Dapr Service Invocation HTTP Route"
linkTitle: "Service invocation"
description: "Learn how to use Dapr's HTTP API in Radius"
weight: 150
slug: "http"
---

## Overview

`Applications.Connector/daprInvokeHttpRoutes` defines Dapr Service Invocation communication through the HTTP API between two or more [services]({{< ref container >}}).

## Resource format

A Dapr HTTP Route is defined as a resource within your Application, defined at the same level as the resources providing and consuming the Dapr HTTP API communication.

{{< rad file="snippets/http.bicep" embed=true marker="//ROUTE" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. | `backend-route`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Property | Description | Example |
|----------|-------------|-------------|
| application | The ID of the application resource this resource belongs to. | `app.id`
| environment | The ID of the environment resource this resource belongs to. | `env.id`
| appId    | The appId of the providing resource | `backend` |

## Example: Container

### Providing container

Once a Dapr service invocation Route is defined, you can provide it from a [container]({{< ref container >}}) by using the `provides` property:

{{< rad file="snippets/http.bicep" embed=true marker="//BACKEND" >}}
{{< rad file="snippets/http.bicep" embed=true marker="//ROUTE" >}}

### Consuming container

To consume a Dapr service invocation Route, you can use the `connections` property:

{{< rad file="snippets/http.bicep" embed=true marker="//FRONTEND" >}}

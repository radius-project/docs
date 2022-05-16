---
type: docs
title: "HTTP Route"
linkTitle: "HTTP Route"
description: "Learn how to define HTTP communication with an HTTP Route"
weight: 400
---

## Resource format

{{< rad file="snippets/httproute.bicep" embed=true marker="//HTTPROUTE" >}}

The following top-level information is available:

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your HttpRoute. Used to provide status and visualize the resource. | `'web'`

## Provided Data

The following data is available for use from the consuming service:

### Properties

| Property | Description | Example |
|----------|-------------|-------------|
| host | The hostname of the HTTP endpoint | `example.com` |
| port | The port of the HTTP endpoint | `80` |
| scheme | The scheme of the HTTP endpoint | `http` |
| url | The full URL of the HTTP endpoint | `http://example.com:80` |

## Service compatibility

| Service | Azure | Kubernetes |
|-----------|:-----:|:----------:|
| [`Container`]({{< ref container >}}) | ✅ | ✅ |

## Example

The following example shows two containers, one providing an HttpRoute and the other consuming it:

### Providing container

Once an HttpRoute is defined, you can provide it from a [container]({{< ref container >}}) by using the `provides` property:

{{< rad file="snippets/httproute.bicep" embed=true marker="//BACKEND" >}}

### Consuming container

To consume an HttpRoute, you can use the `connections` property:

{{< rad file="snippets/httproute.bicep" embed=true marker="//FRONTEND" >}}

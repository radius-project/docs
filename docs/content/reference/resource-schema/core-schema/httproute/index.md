---
type: docs
title: "HTTP Route"
linkTitle: "HTTP Route"
description: "Learn how to define HTTP communication with an HTTP Route"
weight: 400
---

## Resource format

{{< rad file="snippets/httproute.bicep" embed=true marker="//HTTPROUTE" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your HttpRoute. Used to provide status and visualize the resource. | `'web'`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Property | Description | Example |
|----------|-------------|-------------|
| application | The ID of the application resource this resource belongs to. | `app.id`
| hostname | The internal hostname accepting traffic for the HTTP Route. Read only. | `example.com` |
| port | The port number for the HTTP Route. Defaults to 80. Read only. | `80` |
| scheme | The scheme used for traffic. Read only. | `http` |
| url | A stable URL that that can be used to route traffic to a resource. Read only. | `http://example.com:80` |

## Example

The following example shows two containers, one providing an HttpRoute and the other consuming it:

### Providing container

Once an HttpRoute is defined, you can provide it from a [container]({{< ref container >}}) by using the `provides` property:

{{< rad file="snippets/httproute.bicep" embed=true marker="//BACKEND" >}}

### Consuming container

To consume an HttpRoute, you can use the `connections` property:

{{< rad file="snippets/httproute.bicep" embed=true marker="//FRONTEND" >}}

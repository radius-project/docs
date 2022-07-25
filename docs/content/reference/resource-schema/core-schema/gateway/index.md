---
type: docs
title: "Gateway"
linkTitle: "Gateway"
description: "Learn how to route requests to different resources"
weight: 401
---

## Resource format

{{< rad file="snippets/gateway.bicep" embed=true marker="//GATEWAY" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your Gateway. | `'gateway'`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| application | y | The ID of the application resource this resource belongs to. | `app.id`
| [hostname](#hostname) | n | The hostname information for this gateway. | [See below](#hostname)
| [routes](#routes) | y | The routes attached to this gateway. | [See below](#routes)

#### Routes

You can define a list of routes, each representing a connection to a service. Specifying a route opens the destination [HTTP Route]({{< ref httproute >}}) to the internet.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| path | y | The path to match the incoming request path on. | `'/service'`
| destination | y | The [HttpRoute]({{< ref httproute >}}) to direct traffic to when the path is matched. | `route.id`

#### Hostname

You can define hostname information for how to access your application. See [below](#hostname-generation) for more information.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| prefix | n | A custom DNS prefix for the generated hostname. | `'prefix'`
| fullyQualifiedHostname | n | A fully-qualified domain name to use for the gateway. | `'myapp.mydomain.com'`

## Hostname Generation

There are three options for defining hostnames:

1. Omit the `hostname` property, and Radius will generate the hostname for you with the format: `gatewayname.appname.PUBLIC_HOSTNAME_OR_IP.nip.io`.
1. Declare `hostname.prefix`, and Radius will generate the hostname based on your chosen prefix: `prefix.appname.PUBLIC_HOSTNAME_OR_IP.nip.io`.
1. Declare `hostname.fullyQualifiedHostname`, and Radius will use your fully-qualified domain name as the hostname: `myapp.mydomain.com`. Note that you must map the public IP of the platform your app is running on to the chosen hostname. If you provide this property as well as `prefix`, this property will take precedence.

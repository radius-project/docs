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
| path | y* | The path to match the incoming request path on. Not required when `tls.sslPassthrough` is set to `'true'`. | `'/service'`
| destination | y | The [HttpRoute]({{< ref httproute >}}) to direct traffic to when the path is matched. | `route.id`
| replacePrefix | n | The prefix to replace in the incoming request path that is sent to the destination route. | `'/'`

#### Hostname

You can define hostname information for how to access your application. See [below](#hostname-generation) for more information.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| prefix | n | A custom DNS prefix for the generated hostname. | `'prefix'`
| fullyQualifiedHostname | n | A fully-qualified domain name to use for the gateway. | `'myapp.mydomain.com'`

#### TLS

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| sslPassthrough | n | Configures the gateway to passthrough encrypted SSL traffic to an HTTP route and container. Requires a single route to be set with no 'path' defined (just destination). With sslPassthrough set to `true`, the gateway can only support SNI routing. Path based routing cannot be supported. Defaults to 'false'. | `true`
| hostname | n | The hostname for TLS termination. | `'hostname.radapp.dev'`
| certificateFrom | n | The Radius SecretStore resource ID that holds the TLS certificate data for TLS termination. | `secretstore.id`
| minimumProtocolVersion | n | The minimum TLS protocol to support for TLS termination. | `'1.2'`

Note that SSL passthrough and TLS termination functionality are mutually exclusive.

## Hostname Generation

There are three options for defining hostnames:

1. Omit the `hostname` property, and Radius will generate the hostname for you with the format: `gatewayname.appname.PUBLIC_HOSTNAME_OR_IP.nip.io`.
1. Declare `hostname.prefix`, and Radius will generate the hostname based on your chosen prefix: `prefix.appname.PUBLIC_HOSTNAME_OR_IP.nip.io`.
1. Declare `hostname.fullyQualifiedHostname`, and Radius will use your fully-qualified domain name as the hostname: `myapp.mydomain.com`. Note that you must map the public IP of the platform your app is running on to the chosen hostname. If you provide this property as well as `prefix`, this property will take precedence.

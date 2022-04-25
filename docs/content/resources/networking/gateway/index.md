---
type: docs
title: "Gateway"
linkTitle: "Gateway"
description: "Learn how to route requests to different resources."
weight: 200
---

## Overview

`Gateway` defines how requests are routed to different resources, and also provides the ability to expose traffic to the internet. Conceptually, gateways allow you to have a single point of entry for  traffic in your application, whether it be internal or external traffic.

A `Gateway` in Radius is split into two main pieces: the `Gateway` resource itself, which defines which routes to direct traffic to, and `Route`(s) which define the rules for routing traffic to different resources.

## Hostname Generation

Since the gateway is the 'entry point' of the application, you can provide hostname information to manage how you and your users access your application. This is managed within the [properties.hostname](#hostname) field in the Gateway spec. There are three options for defining hostnames:

1. Omit the `hostname` property, and Radius will generate the hostname for you: `gatewayname.appname.PUBLIC_HOSTNAME_OR_IP.nip.io`.
2. Declare `hostname.prefix`, and Radius will generate the hostname based on your chosen prefix: `prefix.appname.PUBLIC_HOSTNAME_OR_IP.nip.io`.
3. Declare `hostname.fullyQualifiedHostname`, and Radius will use your fully-qualified domain name as the hostname: `myapp.mydomain.com`. Note that for this to work, you must map the public IP of the platform your app is running on to the chosen hostname. If you provide this property as well as `prefix`, this property will take precedence.

## Resource format

A Gateway is defined as a resource within your Application, defined at the same level as the resources providing and consuming the HTTP communication.

{{< rad file="snippets/gateway.bicep" embed=true marker="//GATEWAY" >}}

The following top-level information is available:

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your Gateway. Used to provide status and visualize the resource. | `'gateway'`

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| hostname | n | The hostname information for this gateway.  |  [See below](#hostname)

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| routes | y | The routes attached to this gateway.  |  [See below](#routes)

#### Routes

You can define a list of routes, each representing a connection to a service.
Routes can only be publicly accessible when declared in this list.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| path | y | The path to match the incoming request path on. | `'/service'`
| destination | y | The HttpRoute to route to. | `route.id`

#### Hostname

You can define hostname information, which will determine how to access your application.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| prefix | n | Specify a prefix for the generated hostname. | `'prefix'`
| fullyQualifieHostname | n | specify a fully-qualified domain name. | `'myapp.mydomain.com'`

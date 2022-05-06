---
type: docs
title: "Gateway"
linkTitle: "Gateway"
description: "Learn how to route requests to different resources"
weight: 401
---

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
| listeners | y | The bindings that your gateway should listen to. |  [See below](#listeners)

#### Listeners

You can define multiple listeners, each with a different port and protocol.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| port | y | The port to listen on. | `80`
| protocol | y | The protocol to use for traffic on this binding. | `'HTTP'`


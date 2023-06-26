---
type: docs
title: "Dapr Sidecar Extension"
linkTitle: "Dapr extension"
description: "Learn how to add a Dapr sidecar with a Dapr extension"
weight: 100
slug: "extension"
categories: "Schema"
---

## Overview

The `daprSidecar` extensions adds and configures a [Dapr](https://dapr.io) sidecar to your application.

## Extension format

In this example a [container]({{< ref container >}}) adds a Dapr extension to add a Dapr sidecar:

{{< rad file="snippets/dapr.bicep" embed=true marker="//SAMPLE" replace-key-run="//CONTAINER" replace-value-run="container: {...}" >}}

### Properties

| Property | Required | Description | Example |
|----------|:--------:|-------------|---------|
| kind | y | The kind of extension. | `dapr`
| appId | n | The appId of the Dapr sidecar. | `backend` |
| appPort | n | The port your service exposes to Dapr | `3500`
| config | n | The configuration to use for the Dapr sidecar |

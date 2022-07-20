---
type: docs
title: "Dapr Sidecar Extension"
linkTitle: "Dapr Extension"
description: "Learn how to add a Dapr sidecar with a Dapr extension"
weight: 100
slug: "extension"
---

## Overview

The `dapr.io/Sidecar` extensions adds and configures a Dapr sidecar to your application.

## Exntension format

In this example, a [container]({{< ref container >}}) adds a Dapr extension to add a Dapr sidecar:

{{< rad file="snippets/dapr.bicep" embed=true marker="//SAMPLE" replace-key-run="//CONTAINER" replace-value-run="container: {...}" >}}

### Properties

| Property | Required | Description | Example |
|----------|:--------:|-------------|---------|
| appId | n | The appId of the Dapr sidecar. Will use the value of an attached [Route]({{< ref dapr-http >}}) if present. | `backend` |
| appPort | n | The port your service exposes to Dapr | `3500`
| provides | n | The [Dapr Route]({{< ref dapr-http >}}) provided by the Extension | `daprHttp.id`

## Service compatibility

| Service | Azure | Kubernetes |
|-----------|:-----:|:----------:|
| [`Container`]({{< ref container >}}) | ✅ | ✅ |

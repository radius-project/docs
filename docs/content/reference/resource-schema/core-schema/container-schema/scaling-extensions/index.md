---
type: docs
title: "Scaling Extension"
linkTitle: "Scaling Extension"
description: "Learn how to add a scaling Extension to your  service"
weight: 100
---

## Overview

The `manualScaling` extension configures the number of replicas of a compute instance (such as a container) to run.

## Extension format

In this example, a [container service]({{< ref container >}}) adds a manual scaling extension to set the number of container replicas.

{{< rad file="snippets/manual.bicep" embed=true marker="//SAMPLE" replace-key-run="//CONTAINER" replace-value-run="container: {...}" >}}

### Properties

| Property | Required | Description | Example |
|----------|:--------:|-------------|---------|
| kind | y | The kind of extension. | `manualScaling`
| replicas | Y | The number of replicas to run | `5` |

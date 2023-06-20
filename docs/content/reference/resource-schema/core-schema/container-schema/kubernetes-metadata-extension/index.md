---
type: docs
title: "Kubernetes Metadata Extension"
linkTitle: "Kubernetes Metadata Extension"
description: "Learn how to add a Kubernetes Metadata Extension to your  service"
weight: 110
---
## Overview

The [Kubernetes Metadata extension]({{< ref "/operations/platforms/kubernetes/kubernetes-metadata">}}) enables you set and cascade Kubernetes metadata such as labels and Annotations on all the Kubernetes resources defined with in your Radius application 

## Extension format

In this example, a [container service]({{< ref container >}}) adds a Kubernetes Metadata extension to set the app metadata as labels and annotations.

{{< rad file="snippets/manual.bicep" embed=true marker="//CONTAINER" >}}

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of extension being used. Must be 'kubernetesMetadata' | 'kubernetesMetadata' |
| [labels](#labels)| n | The Kubernetes labels to be set on the application and its resources | [See below](#labels)|
| [annotations](#annotations) | n | The Kubernetes annotations to set on your application and its resources  | [See below](#annotations)|

#### labels

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| label key | y | The key and value of the label to be set on the application and its resources.| `team.name:frontend` |

#### annotations

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| annotation key | y | The key and value of the annotation to be set on the application and its resources.| `app.io/port:8081` |

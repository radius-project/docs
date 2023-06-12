---
type: docs
title: "Radius Application"
linkTitle: "Application"
description: "Learn how to model your application and its services in Radius "
weight: 100
categories: "How-To"
tags: ["application"]
---
## Overview

An [application]({{< ref appmodel-concept >}}) is the parent resource that contains all of your services and relationships. It is the top-level resource in your Bicep file.
{{< rad file="snippets/blank.bicep" embed=true >}}

## Resource schema

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `frontend`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| environment | y | The ID of the environment resource this container belongs to. | `env.id`
| [extensions](#extensions) | n | List of extensions on the container. | [See below](#extensions)

#### Extensions

Extensions allow you to customize how resources are generated or customized as part of deployment.

##### kubernetesNamespace

The Kubernetes namespace extension allows you to customize how all of the resources within your application generate Kubernetes resources. See the [Kubernetes mapping guide]({{< ref kubernetes-mapping >}}) for more information on namespace mapping behavior.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of extension being used. Must be 'kubernetesNamespace' | 'kubernetesNamespace' |
| namespace | y | The namespace where all application-scoped resources generate Kubernetes objects. | 'default' |

---
type: docs
title: "Application reference"
linkTitle: "Application"
description: "Learn how to define an application"
weight: 100
---

## Resource format

{{< rad file="snippets/app.bicep" embed=true marker="//APP" >}}

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

The Kubernetes namespace extension allows you to customize how all of the resources within your application generate Kubernetes resources. See the [Kubernetes mapping guide]({{< ref "/guides/operations/kubernetes/overview#resource-mapping" >}}) for more information on namespace mapping behavior.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of extension being used. Must be 'kubernetesNamespace' | `kubernetesNamespace` |
| namespace | y | The namespace where all application-scoped resources generate Kubernetes objects. | `default` |

##### kubernetesMetadata

The [Kubernetes Metadata extension]({{< ref "guides/operations/kubernetes/kubernetes-metadata">}}) enables you set and cascade Kubernetes metadata such as labels and Annotations on all the Kubernetes resources defined with in your Radius application. For examples, please refer to the extension overview page.

###### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of extension being used. Must be 'kubernetesMetadata' | `kubernetesMetadata` |
| [labels](#labels)| n | The Kubernetes labels to be set on the application and its resources | [See below](#labels)|
| [annotations](#annotations) | n | The Kubernetes annotations to set on your application and its resources  | [See below](#annotations)|

###### labels

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| user defined label key | y | The key and value of the label to be set on the application and its resources.|`'team.name': 'frontend'`

###### annotations

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| user defined annotation key | y | The key and value of the annotation to be set on the application and its resources.| `'app.io/port': '8081'` |

---
type: docs
title: "Environment"
linkTitle: "Environment"
description: "Learn how to define an environment"
weight: 000
---

## Resource format

{{< rad file="snippets/environment.bicep" embed=true marker="//ENV" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `frontend`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| [compute](#compute) | y | Container runtime configuration. | [See below](#compute)
| [recipes](#recipes) | n | Recipes registered to the environment | [See below](#recipes)

### compute

Details on what to run and how to run it are defined in the `container` property:

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of container runtime to use. Only option is `'kubernetes'` | `'kubernetes'`
| namespace | y | The Kubernetes namespace to render application resources into | `'default'`
| resourceId | n | The resource ID of the AKS cluster to render application resources into. Only required for Azure environments | `aksCluster.id`
| identity | n | The cluster identity configuration | [See below](#identity) |

### identity

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of identity. 'azure.com.workload' is currently only supported. | `'azure.com.workload'` |
| oidcIssuer | n | The [OIDC issuer URL](https://azure.github.io/azure-workload-identity/docs/installation/self-managed-clusters/oidc-issuer.html) for your Kubernetes cluster. | `'{IssuerURL}/.well-known/openid-configuration'` |

### recipes

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| \<resource-type\> | y | The type of resource to register Recipes for. | `'Applications.Datastores/redisCaches'`
| recipes | y | The list of Recipes registered to a given resource type | [See below](#recipe-properties)

#### recipe properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| \<recipe-name\> | y | The name of the Recipe. Must be unique within the resource-type. | `myrecipe`
| templateKind | y | Format of the template provided by the recipe. Allowed values: bicep | `'bicep'`
| templatePath | y | The path to the Recipe contents. For Bicep Recipes this is a Bicep module registry address. | `'mycr.ghcr.io/recipes/myrecipe:1.0'`
| parameters | n | A list of parameters to set on the Recipe for every Recipe usage and deployment. Can be overridden by the resource calling the Recipe. | `capacity: 1`

### extensions

Extensions allow you to customize how resources are generated or customized as part of deployment.

#### kubernetesMetadata

The [Kubernetes Metadata extension]({{< ref "guides/operations/kubernetes/kubernetes-metadata">}}) enables you set and cascade Kubernetes metadata such as labels and Annotations on all the Kubernetes resources defined with in your Radius Application. For examples, please refer to the extension overview page.

##### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of extension being used. Must be 'kubernetesMetadata' | `kubernetesMetadata` |
| [labels](#labels) | n | The Kubernetes labels to be set on the application and its resources | [See below](#labels)|
| [annotations](#annotations) | n | The Kubernetes annotations to set on your application and its resources | [See below](#annotations)|

##### labels

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| user defined label key | y | The key and value of the label to be set on the application and its resources.|`'team.name': 'frontend'`

##### annotations

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| user defined annotation key | y | The key and value of the annotation to be set on the application and its resources.| `'app.io/port': '8081'` |

## Further reading

- [Radius Environments]({{< ref "/guides/deploy-apps/environments/overview" >}})

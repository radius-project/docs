---
type: docs
title: "How-To: Author a Radius Recipe"
linkTitle: "How-To: Author a Radius Recipe"
weight: 20
description: "How-To: Author a Radius Recipe"
categories: ["How-To"]
tags: ["Recipes"]
---

This guide will show you how to use your infrastructure as code language to author and publish a custom Recipe template, letting you define how infrastructure should be deployed and configured within your environment.

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Radius initialized with `rad init`](https://docs.radapp.dev/getting-started/)

### Step 1: Select an Infrastructure as Code language

Below is a list of all the current IaC Radius Recipes support for templating.

| Infrastructure as Code Languages | Recipe Support |
|---------------------| ------------|
| [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/) | ✅ |
| [Terraform](https://developer.hashicorp.com/terraform/docs) | ✅ |

### Step 2: Author a Recipe template

Recipes need to be generalized templates, as multiple resources can run each Recipe. The resources inside of a Recipe cannot interfere or overwrite each other. To make sure you don't accidentally overwrite or corrupt your infrastructure, you will want to make sure **each resource in your Recipe contains unique names**.

Additionally, every time an application is deployed, Recipes are re-evaluated and re-deployed. Because IaC languages like Bicep are idempotent, if there are no changes to the template, then nothing is changed. To make sure Recipes can be re-run, **each resource needs a repeatable name that is the same every time it is deployed**.

To make naming easy, a `context` parameter is automatically injected into your template. It contains information about the backing resource which you can use to generate unique and repeatable names. For example, you can use `context.resource.id` to generate a unique and repeatable name:


{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

{{< rad file="snippets/recipe.bicep" embed=true marker="//RESOURCE" >}}

{{% /codetab %}}

{{% codetab %}}

{{< rad file="snippets/recipe.tf" embed=true marker="//RESOURCE" lang="terraform" >}}

{{% /codetab %}}

{{< /tabs >}}


### Step 3: Add parameters for Recipe customization (optional)

You can optionally choose to add parameters to your Recipe to allow developers or operators to specify additional configuration. Parameters can be set both when a Recipe is added to an environment by an operator, or by a developer when the Recipe is called.

{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

You can create any [parameter type supported by Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/parameters):

{{< rad file="snippets/recipe-params.bicep" embed=true marker="//RESOURCE" >}}

{{% /codetab %}}

{{% codetab %}}

{{< rad file="snippets/recipe.tf" embed=true marker="//PARAM" lang="terraform" >}}

{{% /codetab %}}

{{< /tabs >}}


### Step 4: Output the target infrastructure

Once you have defined your backing infrastructure, you will need to output it from your IaC template so it can be "wired-up" to the resource that called the Recipe.

Define an object that matches the schema of the resource calling the Recipe. For example, for an `Application.Link/redisCaches` resource, a Recipe would output:

{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

Using the `values` output parameter, you can pass back information about your infrastructure.

When you output a `values` object, all of the individual properties will be directly mapped to the resource calling the Recipe. This allows you that most control over the resource being created within the application.

{{< rad file="snippets/recipe-params.bicep" embed=true marker="//OUTVALUES" >}}

_Note: Secure output parameters is in development. For now, you can use `#disable-next-line outputs-should-not-contain-secrets` to bypass the linter._

{{% /codetab %}}

{{% codetab %}}

{{< rad file="snippets/recipe.tf" embed=true marker="//OUTPUT" lang="terraform" >}}

{{% /codetab %}}

{{< /tabs >}}

#### Linking

You also need to make sure to **link** your infrastructure resources, so Radius can delete them later on when the resource is deleted.

Linking is done automatically for any new Azure or AWS resource ([_Kubernetes coming soon_]({{< ref "faq#why-do-i-need-to-manually-output-a-kubernetes-ucp-id-as-part-of-my-bicep-recipe" >}})) defined in a Recipe. Radius inspects [the output of the deployment](https://learn.microsoft.com/rest/api/resources/deployments/get#resourcereference) and links any created resources.

{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

[Bicep `existing`](https://learn.microsoft.com/azure/azure-resource-manager/bicep/existing-resource) resources are not currently linked as part of Recipe-enabled resources, meaning you won't see them in the definition of the resource and they aren't [deleted later on](#infrastructure-lifecycle), unlike new resources.

You can also manually link resources via the `values` output of a Recipe. This can be used for Kubernetes resources, [which aren't currently linked automatically]({{< ref "faq#why-do-i-need-to-manually-output-a-kubernetes-ucp-id-as-part-of-my-bicep-recipe" >}}). To link a resource to a Recipe-enabled resource, add its ID to an array of resource IDs:

```bicep
// ....resources defined above

output values object = {
  resources: [
    // ID via reference (Azure/AWS)
    resource1.id
    // ID via manual entry (Kubernetes)
    '/planes/kubernetes/local/namespaces/${deployment.metadata.namespace}/providers/apps/Deployment/${deployment.metadata.name}'
  ]
}
```

{{% /codetab %}}

{{% codetab %}}

//TODO TERRAFORM LINKING

{{% /codetab %}}

{{< /tabs >}}

### Step 5: Store your template

{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

Recipes leverage [Bicep registries](https://learn.microsoft.com/azure/azure-resource-manager/bicep/private-module-registry) for template storage. Once you've authored a Recipe, you can publish it to your preferred OCI-compliant registry.

For private registries, make sure the cloud provider configured in your Radius environment has pull permissions for your container registry.

Recipes can be published via the rad CLI:

```bash
rad bicep publish --file myrecipe.bicep --target br:myregistry.azurecr.io/recipes/myrecipe:v1
```

{{% /codetab %}}

{{% codetab %}}

Follow the [Terraform module publishing docs](https://developer.hashicorp.com/terraform/registry/modules/publish) to setup and publish a Terraform module to a Terraform registry.

{{% /codetab %}}

{{< /tabs >}}

### Step 6: Register your Recipe with your environment

Now that your Recipe template has been stored, you can add it your Radius environment to be used by developers. This allows you to mix-and-match templates for each of your environments such as dev, canary, and prod.

Recipes now support a default experience, where you can register a Recipe under the name `default` within an environment. Developers can then call the Recipe without specifying a name, and Radius will automatically use the `default` Recipe. If you want to register a Recipe that is not the default, you can specify a custom name.

Recipes can be added via the rad CLI or an environment Bicep definition:

{{< tabs "rad CLI" "Bicep environment" >}}

{{% codetab %}}

#### Bicep template

```bash
rad recipe register myrecipe --environment myenv --template-kind bicep --template-path myregistry.azurecr.io/recipes/myrecipe:v1 --link-type Applications.Link/redisCaches
```

#### Terraform template

The template path value should represent the source path found in your Terraform module registry.

```bash
rad recipe register myrecipe --environment myenv --template-kind terraform --template-path user/test/azure-redis --link-type Applications.Link/redisCaches
```

{{% /codetab %}}

{{% codetab %}}

{{< rad file="snippets/environment.bicep" embed=true >}}

{{% /codetab %}}

{{< /tabs >}}

### Done

You can now use your custom recipe in its accompanying resource. Visit the [Recipe developer guide]({{< ref "/recipes-section/overview" >}}) for more information.

## `context` parameter properties

In the following tables, "resource" refers to the resource "calling" the Recipe. For example, if you were to create a Recipe for an `Applications.Link/redisCaches` resource, the "resource" would be the instance of the redisCaches that is calling the Recipe.

| Key | Type | Description |
|-----|------|-------------|
| [`resource`](#resource) | object | An object containing information on the resource.
| [`application`](#application) | object | An object containing information on the application the resource belongs to.
| [`environment`](#environment) | object | An object containing information on the environment the resource belongs to.
| [`runtime`](#runtime) | object | An object containing information on the underlying runtime.

### resource

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The resource name of the application | `myredis`
| `id` | string | The ID of the resource | `/planes/radius/resourceGroups/myrg/Applications.Link/redisCaches/myredis`
| `type` | string | The type of the resource calling this recipe | `Applications.Link/redisCaches`

### application

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The resource name of the application | `myapp`
| `id` | string | The resource ID of the application | `/planes/radius/resourceGroups/myrg/Applications.Core/applications/myapp`

### environment

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `name` | string | The resource name of the environment | `myenv`
| `id` | string | The resource ID of the environment | `/planes/radius/resourceGroups/myrg/Applications.Core/environments/myenv`

### runtime

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| [`kubernetes`](#kubernetes) | object | An object with details of the underlying Kubernetes cluster, if configured on the environment

#### kubernetes

| Key | Type | Description | Example |
|-----|------|-------------|---------|
| `namespace` | string | Set to the application's namespace when the resource is application-scoped, and set to the environment's namespace when the resource is environment scoped.
| `environmentNamespace` | string | Set to the environment's namespace.

## Further reading

- [Recipes overview]({{< ref "/recipes-section/overview" >}})
- [`rad recipe CLI reference`]({{< ref rad_recipe >}})


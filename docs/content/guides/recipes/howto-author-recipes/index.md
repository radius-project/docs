---
type: docs
title: "How-To: Author a Radius Recipe"
linkTitle: "Author a Radius Recipe"
description: "Learn how to author and register a custom Recipe template to automate infrastructure provisioning"
weight: 500
categories: "How-To"
tags: ["recipes"]
---

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Radius initialized with `rad init`]({{< ref getting-started >}})

### Step 1: Author a Recipe template

Recipes need to be generalized templates, as multiple resources can run each Recipe. The resources inside of a Recipe cannot interfere or overwrite each other. To make sure you don't accidentally overwrite or corrupt your infrastructure, you will want to make sure **each resource in your Recipe contains unique names**.

Additionally, every time an application is deployed, Recipes are re-evaluated and re-deployed. Because IaC languages like Bicep are idempotent, if there are no changes to the template, then nothing is changed. To make sure Recipes can be re-run, **each resource needs a repeatable name that is the same every time it is deployed**.

To make naming easy, a `context` parameter is automatically injected into your template. It contains information about the backing resource which you can use to generate unique and repeatable names. For example, you can use `context.resource.id` to generate a unique and repeatable name:

{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

{{< rad file="snippets/redis-kubernetes.bicep" embed=true marker="//RESOURCE" >}}

{{% /codetab %}}

{{% codetab %}}

Add the `context` parameter to your `variable.tf` file:

{{< rad file="snippets/redis-kubernetes-variables.tf" embed=true marker="//CONTEXT" lang="terraform" >}}

Within `main.tf` use the `context` variable to name and configure your resources metadata as:

{{< rad file="snippets/redis-kubernetes-main.tf" embed=true marker="//RESOURCE" lang="terraform" >}}

{{% /codetab %}}

{{< /tabs >}}

You can reference the [`context` section below](#context-parameter-properties) for more information on available properties.

### Step 2: Add parameters for Recipe customization (optional)

You can optionally choose to add parameters to your Recipe to allow developers or operators to specify additional configuration. Parameters can be set both when a Recipe is added to an environment by an operator, or by a developer when the Recipe is called.

{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

You can create any [parameter type supported by Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/parameters):

{{< rad file="snippets/redis-kubernetes.bicep" embed=true marker="//PARAMETERS" >}}

{{% /codetab %}}

{{% codetab %}}

You can create any [variable type supported by Terraform](https://developer.hashicorp.com/terraform/language/values/variables):

{{< rad file="snippets/redis-kubernetes-variables.tf" embed=true marker="//PARAMETERS" lang="terraform" >}}

{{% /codetab %}}

{{< /tabs >}}

### Step 3: Output the required values

Once you have defined your backing infrastructure, you will need to output it from your IaC template so it can be "wired-up" to the resource that called the Recipe.

Radius Recipes require you to output a `result` object that contains the applicable data fields, secrets, and resource IDs.

When you output a `result` object, all of the individual properties will be directly mapped to the resource calling the Recipe. This allows you to have the most control over the resource being created within the application.

#### Resource definition

Simply define an object that matches the schema of the resource calling the Recipe.

You also need to make sure to **link** your infrastructure resources, so Radius can delete them later on when the resource is deleted.

Linking is done automatically for Bicep Recipes for any new Azure or AWS resource ([_Kubernetes coming soon_]({{< ref "faq#why-do-i-need-to-manually-output-a-kubernetes-ucp-id-as-part-of-my-bicep-recipe" >}})). Radius inspects [the output of the Bicep deployment](https://learn.microsoft.com/rest/api/resources/deployments/get#resourcereference) and links any created resources.

{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

[Bicep `existing`](https://learn.microsoft.com/azure/azure-resource-manager/bicep/existing-resource) resources are not currently linked as part of Recipe-enabled resources, meaning you won't see them in the definition of the resource and they aren't [deleted later on](#infrastructure-lifecycle), unlike new resources.

You can also manually link resources via the `result` output of a Recipe. This can be used for Kubernetes resources, [which aren't currently linked automatically]({{< ref "faq#why-do-i-need-to-manually-output-a-kubernetes-ucp-id-as-part-of-my-bicep-recipe" >}}). To link a resource to a Recipe-enabled resource, add its ID to an array of resource IDs:

{{< rad file="snippets/redis-kubernetes.bicep" embed=true marker="//OUTPUT" >}}

_Note: Secure output parameters is in development. For now, you can use `#disable-next-line outputs-should-not-contain-secrets` to bypass the linter._

{{% /codetab %}}

{{% codetab %}}

{{< rad file="snippets/redis-kubernetes-output.tf" embed=true lang="terraform" >}}

{{% /codetab %}}

{{< /tabs >}}

### Step 4: Store your template

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

### Step 5: Register your Recipe with your environment

Now that your Recipe template has been stored, you can add it your Radius environment to be used by developers. This allows you to mix-and-match templates for each of your environments such as dev, canary, and prod.

Recipes now support a default experience, where you can register a Recipe under the name `default` within an environment. Developers can then call the Recipe without specifying a name, and Radius will automatically use the `default` Recipe. If you want to register a Recipe that is not the default, you can specify a custom name.

Recipes can be added via the rad CLI or an environment Bicep definition:

{{< tabs "rad CLI - Bicep" "rad CLI - Terraform" "Bicep environment" >}}

{{% codetab %}}

```bash
rad recipe register myrecipe --environment myenv --template-kind bicep --template-path myregistry.azurecr.io/recipes/myrecipe:v1 --link-type Applications.Link/redisCaches
```

{{% /codetab %}}

{{% codetab %}}

The template path value should represent the source path found in your Terraform module registry.

```bash
rad recipe register myrecipe --environment myenv --link-type Applications.Link/redisCaches --template-kind terraform --template-path user/recipes/myrecipe --template-version "1.1.0"
```

{{% /codetab %}}

{{% codetab %}}

{{< rad file="snippets/environment.bicep" embed=true >}}

{{% /codetab %}}

{{< /tabs >}}

### Done

You can now use your custom Recipe with its accompanying resource. Visit the [Recipe developer guide]({{< ref "/guides/recipes/overview" >}}) for more information.

## Further reading

- [Recipes overview]({{< ref "/guides/recipes/overview" >}})
- [`rad recipe CLI reference`]({{< ref rad_recipe >}})

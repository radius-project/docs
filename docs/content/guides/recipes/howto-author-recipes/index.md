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

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Step 1: Author a Recipe template

Begin by creating your Bicep or Terraform template. Ensure that the resource name(s) are **unique** and **repeatable**, so they don't overlap when used by multiple applications.

> To make naming easy, a [`context` parameter]({{< ref context-schema >}}) is automatically injected into your template. It contains metadata about the backing app/environment which you can use to generate unique and repeatable names.

{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

Create `app.bicep` and use the `context` parameter for naming and namespace configuration:

{{< rad file="snippets/redis-kubernetes.bicep" embed=true marker="//RESOURCE" >}}

{{% /codetab %}}

{{% codetab %}}

Add the `context` parameter to your `variable.tf` file:

{{< rad file="snippets/redis-kubernetes-variables.tf" embed=true marker="//CONTEXT" lang="terraform" >}}

Ensure that your `main.tf` has:

- Defined `required_providers` for any providers you leverage in your module. This allows Radius to inject configuration and credentials.
- Utilizes the `context` parameter for naming and namespace configuration. This ensures your resources don't unintentionally collide with other uses of the Recipe.

{{< rad file="snippets/redis-kubernetes-main.tf" embed=true lang="terraform" >}}

{{% /codetab %}}

{{< /tabs >}}

### Step 2: Add parameters/variables for Recipe customization (optional)

You can optionally add parameters/variables to your Recipe to allow developers and/or operators to customize the Recipe for an application/environment. Parameters can be set both when a Recipe is added to an environment by an operator, or by a developer when the Recipe is called.

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

### Step 3: Output the result

Once you have defined your IaC template you will need to output a `result` object with the values, secrets, and resources that the target resource requires. This is how Radius "wires up" the Recipe.

The `result` object must include:
- **`values`**: The fields that the target resource requires. (_username, host, port, etc._)
- **`secrets`**: The fields that the target resource requires, but should be treated as secrets. (_password, connectionString, etc._)
- **`resources`**: The [UCP ID(s)]({{< ref "/concepts/technical/api#resource-ids" >}}) of the resources providing the backing service. Used by UCP to track dependencies and manage deletion.

{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

Resources are populated automatically for Bicep Recipes for any new Azure or AWS resource ([_Kubernetes coming soon_]({{< ref "faq#why-do-i-need-to-manually-output-a-kubernetes-ucp-id-as-part-of-my-bicep-recipe" >}})). For now, make sure to include the UCP ID of any Kubernetes resources your Recipe creates.

{{< rad file="snippets/redis-kubernetes.bicep" embed=true marker="//OUTPUT" >}}

{{% /codetab %}}

{{% codetab %}}

{{< rad file="snippets/redis-kubernetes-output.tf" embed=true lang="terraform" >}}

{{% /codetab %}}

{{< /tabs >}}

### Step 4: Store your template

{{< tabs "Bicep" "Terraform" >}}

{{% codetab %}}

Recipes leverage [Bicep registries](https://learn.microsoft.com/azure/azure-resource-manager/bicep/private-module-registry) for template storage. Once you've authored a Recipe, you can publish it to your preferred OCI-compliant registry with [`rad bicep publish`]({{< ref rad_bicep_publish >}}):

```bash
rad bicep publish --file myrecipe.bicep --target br:ghcr.io/USERNAME/recipes/myrecipe:1.1.0
```

{{% /codetab %}}

{{% codetab %}}

Follow the [Terraform module publishing docs](https://developer.hashicorp.com/terraform/registry/modules/publish) to setup and publish a Terraform module to a Terraform registry.

{{% /codetab %}}

{{< /tabs >}}

### Step 5: Register your Recipe with your environment

Now that your Recipe template has been stored, you can add it your Radius Environment to be used by developers. This allows you to mix-and-match templates for each of your environments such as dev, canary, and prod.

{{< tabs "rad CLI - Bicep" "rad CLI - Terraform" "Bicep environment" >}}

{{% codetab %}}

```bash
rad recipe register myrecipe --environment myenv --resource-type Applications.Datastores/redisCaches --template-kind bicep --template-path ghcr.io/USERNAME/recipes/myrecipe:1.1.0
```

{{% /codetab %}}

{{% codetab %}}

The template path value should represent the source path found in your Terraform module registry.

```bash
rad recipe register myrecipe --environment myenv --resource-type Applications.Datastores/redisCaches --template-kind terraform --template-path user/recipes/myrecipe --template-version "1.1.0"
```

{{% /codetab %}}

{{% codetab %}}

{{< rad file="snippets/environment.bicep" embed=true >}}

{{% /codetab %}}

{{< /tabs >}}

### Step 6 : Use the custom recipe in your application

You can now use your custom Recipe with its accompanying resource in your application. 

> Note that if your Recipe is registered with the name "default", you do not need to provide a Recipe name in your application, as it will automatically pick up the default Recipe.

{{< rad file="snippets/redis.bicep" embed=true marker="//REDIS" >}}

## Further reading

- [Recipes overview]({{< ref "/guides/recipes/overview" >}})
- [`rad recipe CLI reference`]({{< ref rad_recipe >}})

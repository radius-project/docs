---
type: docs
title: "How to create a custom recipe with Radius"
linkTitle: "Create custom Recipes"
description: "Learn how to use Terraform and Bicep recipes with Radius"
weight: 200
aliases:
  - /guides/recipes/
  - /guides/recipes/howto-author-recipes/
  - /tutorials/create-recipe/
---

A [recipe]({{< ref "/concepts/recipe-packs" >}}) is a Terraform module or Bicep template that defines how Radius provisions infrastructure for a Resource Type. You can use existing infrastructure-as-code with Radius by accepting the Radius `context` object and, when needed, returning a `result` object.

This guide shows you how to adapt a Terraform module or Bicep template to run as a Radius recipe. It focuses on using `context` to make Radius resource, application, Environment, runtime, connection, and cloud provider information available within the recipe. It also explains how to use `result` to return information to Radius. Adding the recipe to a Recipe Pack and assigning that Recipe Pack to an Environment are covered separately.

## Use community recipes as examples

The [`radius-project/resource-types-contrib`](https://github.com/radius-project/resource-types-contrib) repository is the community-maintained source for Resource Types and recipes that ship with Radius. Each Resource Type directory contains implementations for supported deployment targets, making the repository a useful source of complete Terraform and Bicep examples.

Before starting from an empty module, look for a Resource Type with similar infrastructure or provider requirements. You can adapt an existing recipe for your organization or follow the [contribution guide](https://github.com/radius-project/resource-types-contrib/blob/main/docs/contributing/contributing-resource-types-recipes.md) to propose a Resource Type and recipe for the community library.

## Step 1: Use the recipe context

Radius injects a `context` object every time it runs a recipe. Declaring `context` as an input enriches an existing Terraform module or Bicep template with information managed by Radius. Use that information to read resource properties and connections, generate stable resource names, select deployment details such as the Kubernetes namespace, and access configured cloud provider scopes.

Names should be both unique and repeatable: running the recipe again for the same Radius resource should target the same infrastructure, while two different Radius resources should not collide.

{{< tabs Terraform Bicep >}}

{{% codetab %}}

```terraform
variable "context" {
  description = "Radius-provided information about the resource and its Environment."
  type        = any
}

locals {
  resource_name = "redis-${substr(sha256(var.context.resource.id), 0, 8)}"
  namespace     = var.context.runtime.kubernetes.namespace
}
```

{{% /codetab %}}

{{% codetab %}}

```bicep
@description('Radius-provided information about the resource and its Environment.')
param context object

var resourceName = 'redis-${uniqueString(context.resource.id)}'
var namespace = context.runtime.kubernetes.namespace
```

{{% /codetab %}}

{{< /tabs >}}

The context also exposes application and Environment metadata, resource connections, and configured cloud provider scopes. See the [recipe context reference]({{< ref "/reference/recipes/context" >}}) for its complete schema and examples.

## Step 2: Declare providers and extensions

Create a Terraform module or Bicep template that provisions the infrastructure backing your Resource Type. Declare any providers or extensions required by that infrastructure.

{{< tabs Terraform Bicep >}}

{{% codetab %}}

Create a Terraform module with files such as `main.tf`, `variables.tf`, and `outputs.tf`. Declare every provider the module uses so Radius can supply the appropriate provider configuration when the recipe runs:

```terraform
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}
```

{{% /codetab %}}

{{% codetab %}}

Create a Bicep template such as `recipe.bicep`. For example, import the Kubernetes extension when the recipe deploys Kubernetes resources:

```bicep
extension kubernetes with {
  kubeConfig: ''
  namespace: context.runtime.kubernetes.namespace
}
```

The Kubernetes extension for Bicep requires the Kubernetes namespace to be set when adding the extension to the template. `context.runtime.kubernetes.namespace` is used. This parameter is sourced from the `properties.providers.kubernetes.namespace` on the `Radius.Core/environments` resource.

{{% /codetab %}}

{{< /tabs >}}

## Step 3: Add recipe parameters

Declare inputs for settings that should be configurable without changing the recipe source. These can include an image version, SKU, capacity, or other operational settings. Give parameters safe defaults when an appropriate default exists.

{{< tabs Terraform Bicep >}}

{{% codetab %}}

```terraform
variable "port" {
  description = "The port Redis listens on."
  type        = number
  default     = 6379
}
```

{{% /codetab %}}

{{% codetab %}}

```bicep
@description('The port Redis listens on.')
param port int = 6379
```

{{% /codetab %}}

{{< /tabs >}}

Use these inputs in the resources your module or template creates. Recipe Pack authors can later provide default values, and Environment authors can override them for a Resource Type.

## Step 4: Return the recipe result

After provisioning infrastructure, a recipe can return a special output named `result`. Use its three supported properties to report the outcome to Radius:

- `values` contains non-sensitive computed properties such as a host and port.
- `secrets` contains sensitive values such as credentials or connection strings.
- `resources` contains resource IDs that Radius should track and delete with the Radius resource.

The properties returned by the recipe should match the properties defined by the Resource Type. Radius automatically tracks Azure Resource Manager and UCP resources created by Bicep. Return IDs for resources Radius cannot discover automatically, including Kubernetes resources.

{{< tabs Terraform Bicep >}}

{{% codetab %}}

Terraform requires a `result` that contains secrets to be marked sensitive:

```terraform
output "result" {
  value = {
    values = {
      host = "${kubernetes_service.redis.metadata[0].name}.${kubernetes_service.redis.metadata[0].namespace}.svc.cluster.local"
      port = kubernetes_service.redis.spec[0].port[0].port
    }
    secrets = {
      password = random_password.redis.result
    }
    resources = [
      "/planes/kubernetes/local/namespaces/${kubernetes_service.redis.metadata[0].namespace}/providers/core/Service/${kubernetes_service.redis.metadata[0].name}"
    ]
  }
  sensitive = true
}
```

{{% /codetab %}}

{{% codetab %}}

```bicep
output result object = {
  values: {
    host: '${redisService.metadata.name}.${redisService.metadata.namespace}.svc.cluster.local'
    port: redisService.spec.ports[0].port
  }
  secrets: {
    #disable-next-line outputs-should-not-contain-secrets
    password: password
  }
  resources: [
    '/planes/kubernetes/local/namespaces/${redisService.metadata.namespace}/providers/core/Service/${redisService.metadata.name}'
  ]
}
```

{{% /codetab %}}

{{< /tabs >}}

The `result` output is optional when a recipe has no computed properties or secrets and creates only resources that Radius tracks automatically. See the [recipe result reference]({{< ref "/reference/recipes/result" >}}) for the complete contract and examples.

## Step 5: Validate the recipe

Format and validate the recipe before publishing it. Validation catches syntax errors and missing provider or extension declarations, but it cannot verify every value supplied through the Radius context.

{{< tabs Terraform Bicep >}}

{{% codetab %}}

Run Terraform formatting and validation from the module directory:

```bash
terraform fmt -check
terraform init -backend=false
terraform validate
```

{{% /codetab %}}

{{% codetab %}}

Compile the Bicep template:

```bash
bicep build recipe.bicep
```

{{% /codetab %}}

{{< /tabs >}}

## Step 6: Store the recipe

After validating the recipe, publish it to a source that the Radius control plane can reach. Use an immutable version and avoid references such as an unversioned branch or `latest` tag for production Recipe Packs.

{{< tabs Terraform Bicep >}}

{{% codetab %}}

Store a Terraform recipe in a Git repository or publish it as a module in a Terraform registry. A versioned Git module source can select a subdirectory and tag:

```text
git::https://github.com/my-org/recipes.git//redis/terraform?ref=v1.1.0
```

Follow the [Terraform module publishing guidance](https://developer.hashicorp.com/terraform/registry/modules/publish) when using a Terraform registry.

{{% /codetab %}}

{{% codetab %}}

Publish a Bicep recipe to an OCI-compliant registry with [`rad bicep publish`]({{< ref rad_bicep_publish >}}):

```bash
rad bicep publish \
  --file recipe.bicep \
  --target br:ghcr.io/my-org/recipes/redis:v1.1.0
```

{{% /codetab %}}

{{< /tabs >}}

If the recipe is stored in a private registry, configure the appropriate TerraformSettings or BicepSettings on the Environment. See [How to design and manage Environments]({{< ref "/management/environments#configure-terraformsettings-and-bicepsettings" >}}) for the available authentication and engine settings.

The Terraform module or Bicep artifact is now ready to be referenced from a Recipe Pack.

## Next steps

Now that you have created a new recipe, it must be added to a Recipe Pack which is assigned to an Environment.

{{< button text="Next step: How to manage Recipe Packs" page="/extensibility/recipe-packs" >}}

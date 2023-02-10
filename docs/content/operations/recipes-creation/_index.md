---
type: docs
title: "Author Custom Radius Recipes"
linkTitle: "Author Recipes"
description: "Learn how to author custom Recipe templates to automate infrastructure deployment"
weight: 30
---

Recipes enable a **separation of concerns** between infrastructure teams and developers by **automating infrastructure deployment**.

Learn more in the Recipes overview page:

{{< button page="recipes" text="Recipes overview" >}}

## Author a custom Recipe

This page will describe how to author and publish a custom Recipe template, letting you define how infrastructure should be deployed and configured within your environment.

### Select an Infrastructure as Code language

Today, Recipes only support the Bicep IaC language. Your custom Recipe template will begin with a new Bicep file, which will contain all of the resources you want to automatically deploy for each resource that runs the Recipe.

### Ensure your resource names are **unique** and **repeatable**

Recipes need to be generalized templates, as multiple resources can run each Recipe. The resources inside of a Recipe cannot interfere or overwrite each other. To make sure you don't accidentally overwrite or corrupt your infrastructure, you will want to make sure **each resource in your Recipe contains unique names**.

Additionally, every time an application is deployed, Recipes are re-evaluated and re-deployed. Because IaC languages like Bicep are idempotent, if there are no changes to the template, then nothing is changed. To make sure Recipes can be re-run, **each resource needs a repeatable name that is the same every time it is deployed**.

To make naming easy, a `context` parameter is automatically injected into your template. It contains information about the backing resource which you can use to generate unique and repeatable names.

For example, you can use `context.resource.id` to generate a unique and repeatable name:

{{< rad file="snippets/recipe-template-example.bicep" embed=true marker="//OUTPUT" >}}


### Add parameters for Recipe customization (optional)

You can optionally choose to add parameters to your Recipe to allow developers or operators to specify additional configuration. Parameters can be set both when a Recipe is added to an environment by an operator, or by a developer when the Recipe is called.

You can create any [parameter type supported by Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/parameters):

{{< rad file="snippets/recipe-template-example.bicep" embed=true marker="//CUSTOMPARAM" >}}


### Output the target infrastructure

Once you've defined your backing infrastructure, you'll need to output it from your IaC template so it can be "wired-up" to the resource that called the Recipe.

Recipes allow you to either specify `values` or `resource`:

{{< tabs Values Resource >}}

{{% codetab %}}
When you output a `values` object, all of the individual properties will be directly mapped to the resource calling the Recipe. This allows you that most control over the resource being created within the application.

Simply define an object that matches the schema of the resource calling the Recipe. For example, for an `Application.Link/redisCaches` resource, a Recipe would output:

{{< rad file="snippets/recipe-template-example.bicep" embed=true marker="//OUTPUT" >}}

{{% /codetab %}}
{{% codetab %}}

Some Radius resources, such as Links, may support automatically mapping infrastructure via a resource ID. Refer to the backing resource's documentation to know what infrastructure is supported.

For supported infrastructure and resources, you can simply output the resource ID as a string, and the properties will automatically configured. For example, `Applications.Link/redisCaches` supports auto-mapping of `Microsoft.Cache/redis`:

{{< rad file="snippets/recipe-template-example.bicep" embed=true marker="//RESOURCEOBJECT" >}}


{{% /codetab %}}
{{< /tabs >}}

If you specify both `values` and `resource`, `resource` will be used first and then `values` will override.

### Store your template in a Bicep registry

Recipes leverage [Bicep registries](https://learn.microsoft.com/azure/azure-resource-manager/bicep/private-module-registry) for template storage. Once you've authored a Recipe, you can publish it to your preferred OCI-compliant registry.

For private registries, make sure the cloud provider configured in your Radius environment has pull permissions for your container registry.

You can use the `az bicep publish` to easily publish your Recipe Bicep template:
```bash
az bicep publish --file myrecipe.bicep --target myregistry.azurecr.io/recipes/myrecipe:v1
```

### Register your Recipe with your environment

Now that your Recipe Bicep template has been stored within your Bicep registry, you can add it your Radius environment to be used by developers. This allows you to mix-and-match templates for each of your environments such as dev, canary, and prod.

Recipes can be added via the rad CLI, or via an environment Bicep definition:

{{< tabs "rad CLI" "Bicep environment" >}}

{{% codetab %}}
```bash
rad recipe register --name <NAME-OF-RECIPE> -e <ENV-NAME> -w <WORKSPACE-NAME> --template-path <PATH-TO-FILE-IN-REGISTRY> --link-type Applications.Link/<LINK-TYPE>
```
{{% /codetab %}}
{{% codetab %}}
{{< rad file="snippets/recipe-env-example.bicep" embed=true >}}

{{% /codetab %}}

{{< /tabs >}}

## Further reading

- Visit the Recipe developer guide for more information.
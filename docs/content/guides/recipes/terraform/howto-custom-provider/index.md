---
type: docs
title: "How-To: Configure custom Terraform Providers"
linkTitle: "Custom Terraform Providers"
description: "Learn how to setup your Radius Environment with custom Terraform Providers and deploy Recipes."
weight: 500
categories: "How-To"
aliases  : ["/guides/recipes/terraform/howto-custom-provider"]
tags: ["recipes", "terraform"]
---

This how-to guide will describe how to:

- Configure a custom [Terraform provider](https://registry.terraform.io/browse/providers) in a Radius Environment.
- Configure credentials to authenticate into the Terraform provider.
- Consume the Terraform modules from a custom Terraform provider and use it in a Terraform recipe.

In this example you're going to configure a [PostgreSQL Terraform provider](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs) in a Radius Environment and deploy a Recipe.

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Radius initialized with `rad init`]({{< ref howto-environment >}})
- [Recipes overview]({{< ref "/guides/recipes/overview" >}})

## Step 1: Define a secretStore resource for the custom provider

Configure a [Radius Secret Store]({{< ref "/guides/author-apps/secrets/overview" >}}) with any sensitive information needed as input configuration for the custom Terraform Provider. Define the namespace for the cluster that will contain your [Kubernetes Secret](https://kubernetes.io/docs/concepts/configuration/secret/) with the `resource` property. 

> While this example shows a Radius-managed secret store where Radius creates the underlying secrets infrastructure, you can also bring your own existing secrets. Refer to the [secrets documentation]({{< ref "/guides/author-apps/secrets/overview" >}}) for more information.

Create a Bicep file `env.bicep` with the secretStore resource:

{{< rad file="snippets/env.bicep" embed=true marker="//SECRETSTORE" >}}

> In this example, you're creating a secret with keys `username` and `password` as sensitive data required to authenticate into the Terraform Provider `cyrilgdn/postgresql`.

## Step 2: Configure Terraform Provider

`recipeConfig/terraform/providers` allows you to setup configurations for one or multiple Terraform Providers. For more information refer to the [Radius Environment schema]({{< ref environment-schema >}}) page.

In your `env.bicep` file add an Environment resource, along with Recipe configuration which leverages properties from the previously defined secret store. In this example you're also passing in `host` and `port` as environment variables to highlight use cases where, depending on provider configuration requirements, users can pass environment variables as plain text and as secret values in `envSecrets` block to the Terraform recipes runtime.

{{< rad file="snippets/env.bicep" embed=true marker="//ENV" >}}

## Step 3: Define a Terraform Recipe

Create a Terraform recipe which deploys a PostgreSQL database instance using custom Terraform provider `cyrilgdn/postgresql`.

{{< rad file="snippets/postgres.tf" embed=true marker="//ENV" >}}

## Step 4: Add a Terraform Recipe to the Environment

Update your Environment with the Terraform Recipe. 

{{< rad file="snippets/env-complete.bicep" embed=true marker="//ENV" markdownConfig="{linenos=table,hl_lines=[\"37-45\"],linenostart=30,lineNos=false}" >}}

## Step 5: Deploy your Radius Environment

Deploy your new Radius Environment passing in values for `username` and `password` needed to authenticate into the provider. The superuser for this PostgreSQL Recipe is `postgres` which is the expected input for `username`:

```bash
rad deploy ./env.bicep -p username=****** -p password=******
```

## Done

Your Radius Environment is now configured with a custom Terraform Provider which you can use to deploy Radius Terraform Recipes. For more information on Radius Recipes visit the [Recipes overview page]({{< ref "/guides/recipes/overview" >}}).

## Cleanup

You can delete the Radius Environment by running the following command:

```bash
rad env delete my-env
```

## Further reading

- [Recipes overview]({{< ref "/guides/recipes/overview" >}})
- [Radius Environments]({{< ref "/guides/deploy-apps/environments/overview" >}})
- [`rad recipe CLI reference`]({{< ref rad_recipe >}})
- [`rad env CLI reference`]({{< ref rad_env >}})
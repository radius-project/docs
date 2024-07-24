---
type: docs
title: "How-To: Configure custom Terraform Providers"
linkTitle: "Configure custom Terraform Providers"
description: "Learn how to setup your Radius environment to configure custom Terraform Providers and deploy recipes."
weight: 500
categories: "How-To"
aliases  : ["/guides/recipes/terraform/howto-custom-provider"]
tags: ["recipes", "terraform", "provider"]
---

This how-to guide will describe how to:

- Configure a custom Terraform Provider and use it in a Terraform recipe.
In this example we're going to configure a PostgreSQL Terraform provider in a Radius environment and deploy a recipe.    
Ref: [Documentation for cyrilgdn/postgresql provider](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs)

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Radius initialized with `rad init`]({{< ref howto-environment >}})


## Step 1: Define a secretStore resource and store any sensitive information needed for the custom provider. 

Configure a [Radius Secret Store]({{< ref "/guides/author-apps/secrets/overview" >}}) with any sensitive information needed as input configuration for the custom Terraform Provider. Define the namespace for the cluster that will contain your [Kubernetes Secret](https://kubernetes.io/docs/concepts/configuration/secret/) with the `resource` property. 

> While this example shows a Radius-managed secret store where Radius creates the underlying secrets infrastructure, you can also bring your own existing secrets. Refer to the [secrets documentation]({{< ref "/guides/author-apps/secrets/overview" >}}) for more information.

Create a Bicep file `env.bicep`, import Radius, and  define your resource:

{{< rad file="snippets/env.bicep" embed=true marker="//SECRETSTORE" >}}

> In this example, we're creating a secret with keys `username` and `password` as sensitive inputs required by the Terraform Provider `cyrilgdn/postgresql`.

## Step 2: Configure Terraform Provider configuration

`recipeConfig/terraform/providers` allows the user to setup configurations for one or multiple Terraform Providers. For more information refer to the [Radius Environment schema]({{< ref environment-schema >}}) page.

In your `env.bicep` file add an Environment resource, along with Recipe configuration which leverages the previously defined secret store for certain configuration fields.
In this example we're also passing in `host` as an environment variable to highlight use cases where, depending on provider configuration requirements, users can pass environment variables to the terraform runtime.

{{< rad file="snippets/env.bicep" embed=true marker="//ENV" >}}

## Step 3: Define Terraform Recipe

Create a Terraform recipe which deploys a postgreSQL database instance using custom Terraform provider `cyrilgdn/postgresql`  

{{< rad file="snippets/postgres.tf" embed=true marker="//ENV" >}}

## Step 4: Add a Terraform Recipe to Env

Update your Environment with a Terraform Recipe. 

{{< rad file="snippets/env-complete.bicep" embed=true marker="//ENV" markdownConfig="{linenos=table,hl_lines=[\"22-30\"],linenostart=30,lineNos=false}" >}}

## Step 5: Deploy your Radius Environment

Deploy your new Radius Environment:

```
rad deploy ./env.bicep -p username=****** -p password=******
```

## Done

Your Radius Environment is now ready to deploy your Radius Recipes that utilize resources associated with configured custom providers. For more information on Radius Recipes visit the [Recipes overview page]({{< ref "/guides/recipes/overview" >}}).

## Cleanup

You can delete a Radius Environment by running the following command:

```
rad env delete my-env
```

## Further reading

- [Recipes overview]({{< ref "/guides/recipes/overview" >}})
- [Radius Environments]({{< ref "/guides/deploy-apps/environments/overview" >}})
- [`rad recipe CLI reference`]({{< ref rad_recipe >}})
- [`rad env CLI reference`]({{< ref rad_env >}})
---
type: docs
title: "How-To: Pull Terraform modules from private git repositories"
linkTitle: "Private git repos"
description: "Learn how to setup your Radius environment to pull Terraform Recipe templates from a private git repository."
weight: 500
categories: "How-To"
tags: ["recipes", "terraform"]
---

This how-to guide will describe how to:

- Configure a Radius Environment to be able to pull Terraform Recipe templates from a private git repository.

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Step 1: Define a secret store resource

Begin by configuring a [Radius Secret Store]({{< ref secretstore >}}) with the personal access token or username + password you previously created, which has access to your private git repository.

Create a Bicep file `env.bicep` and define your resource:

{{< rad file="snippets/env.bicep" embed=true marker="//SECRETSTORE" >}}

> Note the property `pat` is a required property that refers to your personal access token, while `username` can be optional.

## Step 2: Define your Radius Recipe

Define your Radius Recipe, keep in mind that your `templatePath` should contain a `git::` prefix as per [Terraform requirements](https://developer.hashicorp.com/terraform/language/modules/sources#generic-git-repository).

{{< rad file="snippets/env.bicep" embed=true marker="//RECIPE" >}}


## Step 3: Define your Radius Recipe configurations

Radius provides a property `recipeConfig` which allows users to setup specific Git module sources for your Terraform Radius Recipes. Define this property in your Radius Environment resource, visit the [Radius Environment schema]({{< ref environment-schema >}}) page for more information.

{{< rad file="snippets/env.bicep" embed=true marker="//ENV" >}}

> Note the keys listed inside of the `pat` property should match your path name to the secret store.


## Step 4: Deploy your Radius Environment

Deploy your new Radius Environment:

```
rad deploy env.bicep
```

## Cleanup

You can delete a Radius Environment by running the following command:

```
rad env delete prod
```

## Further reading

- [Recipes overview]({{< ref "/guides/recipes/overview" >}})
- [Radius Environments]({{< ref "/guides/deploy-apps/environments/overview" >}})
- [`rad recipe CLI reference`]({{< ref rad_recipe >}})
- [`rad env CLI reference`]({{< ref rad_env >}})
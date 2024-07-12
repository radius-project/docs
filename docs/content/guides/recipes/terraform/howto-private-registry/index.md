---
type: docs
title: "How-To: Pull Terraform modules from private git repositories"
linkTitle: "Private git repos"
description: "Learn how to setup your Radius environment to pull Terraform Recipe templates from a private git repository."
weight: 500
categories: "How-To"
aliases  : ["/guides/recipes/terraform/howto-private-registry"]
tags: ["recipes", "terraform"]
---

This how-to guide will describe how to:

- Configure a Radius Environment to be able to pull Terraform Recipe templates from a private git repository.

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension and Bicep configuration file]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Radius initialized with `rad init`]({{< ref howto-environment >}})

## Step 1: Create a personal access token

Create a personal access token, this can be from [GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#about-personal-access-tokens), [GitLab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html), [Azure DevOps](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows), or any other Git platform.

The PAT should have access to read the files inside the specific private repository.

## Step 2: Define a secret store resource

Configure a [Radius Secret Store]({{< ref "/guides/author-apps/secrets/overview" >}}) with the personal access token or username + password you previously created, which has access to your private git repository. Define the namespace for the cluster that will contain your [Kubernetes Secret](https://kubernetes.io/docs/concepts/configuration/secret/) with the `resource` property. 

> While this example shows a Radius-managed secret store where Radius creates the underlying secrets infrastructure, you can also bring your own existing secrets. Refer to the [secrets documentation]({{< ref "/guides/author-apps/secrets/overview" >}}) for more information.

Create a Bicep file `env.bicep`, import Radius, and  define your resource:

{{< rad file="snippets/env.bicep" embed=true marker="//SECRETSTORE" >}}

> The property `pat` is required and refers to your personal access token or password, while `username` is optional and refers to a username, if your git platform requires one.

## Step 3: Configure Terraform Recipe git authentication

`recipeConfig` allows you to configure how Recipes should be setup and run. One available option is to specify git credentials for pulling Terraform Recipes from git sources. For more information refer to the [Radius Environment schema]({{< ref environment-schema >}}) page.

In your `env.bicep` file add an Environment resource, along with Recipe configuration which leverages the previously defined secret store for git authentication.

{{< rad file="snippets/env.bicep" embed=true marker="//ENV" >}}

## Step 4: Add a Terraform Recipe

Update your Environment with a Terraform Recipe, pointing to your private git repository. Note that your `templatePath` should contain a `git::` prefix, per the [Terraform module documentation](https://developer.hashicorp.com/terraform/language/modules/sources#generic-git-repository).

{{< rad file="snippets/env-complete.bicep" embed=true marker="//ENV" markdownConfig="{linenos=table,hl_lines=[\"22-30\"],linenostart=30,lineNos=false}" >}}

## Step 5: Deploy your Radius Environment

Deploy your new Radius Environment:

```
rad deploy ./env.bicep -p pat=******
```

## Done

Your Radius Environment is now ready to utilize your Radius Recipes stored inside your private registry. For more information on Radius Recipes visit the [Recipes overview page]({{< ref "/guides/recipes/overview" >}}).

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
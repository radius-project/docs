---
type: docs
title: "Overview: Terraform recipes"
linkTitle: "Overview"
description: "Add Terraform based Radius Recipes to your Radius Application"
weight: 100
categories: "Overview"
tags: ["recipes","Terraform"]
---

For a general explanation on Recipes as a concept visit the general [Recipes overview]({{< ref "/guides/recipes/overview" >}}) page.

## Capabilities

### Private Git repositories

Radius supports the use of Terraform modules from private Git repositories as templates for Radius Recipes from any Git platforms such as GitHub, Azure DevOps, Bitbucket, and Gitlab.

### Leverage any Terraform provider

Radius Recipes can leverage any Terraform provider allowing users to interact with and manage resources of any specific infrastructure platform or service, such as AWS, Azure, or Google Cloud.

## Further Reading

- [Author custom recipes]({{< ref howto-author-recipes >}})
- [Register a Recipe from a private registry]({{< ref "/guides/recipes/terraform/howto-private-registry" >}})
- [`rad recipe` CLI reference]({{< ref rad_recipe >}})
- [Recipes overview]({{< ref "/guides/recipes/overview" >}})

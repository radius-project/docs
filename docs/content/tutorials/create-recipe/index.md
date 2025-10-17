---
type: docs
title: "3. Create Recipes"
linkTitle: "3. Create Recipes"
description: "Author Bicep or Terraform Recipes implementing the Resource Type"
weight: 300
---
## Prerequisites

You will use either Bicep or Terraform to author Recipes that implement the Resource Type you created in Step 2 and hence need a location to store your Recipe:

  - **Terraform** configurations must be stored in a Git repository. Ideally for this tutorial the Git repository has anonymous access. If not, you will need to configure [Git authentication]({{< ref "guides/recipes/terraform/howto-private-registry" >}}).
  
  - **Bicep** templates must be stored in an OCI registry. As with Git, you must have anonymous access to the registry or configure [authentication]({{< ref "guides/recipes/howto-private-bicep-registry" >}}).

## Create a Recipe for the PostgreSQL resource type

[Recipes]({{< ref "/guides/recipes/overview" >}}) define how resource are deployed. Recipes can be either Terraform configurations or Bicep templates. Once the Terraform configuration or Bicep template has been published in a Git repo or OCI registry, it can be registered as a recipe in a Radius environment. 

{{< tabs Terraform Bicep >}}{{% codetab %}} 

Terraform configurations must be stored in a Git repository accessible by Radius. As discussed in the prerequisites, using a Git repository with anonymous access is easiest for this tutorial, otherwise you will need to configure [Git authentication]({{< ref "guides/recipes/terraform/howto-private-registry" >}}). Learn more about Recipes in this [How-to guide]({{< ref "/guides/recipes/howto-author-recipes" >}}). 

1. Create a new directory in your Git repository for the PostgreSQL Terraform module then create the `main.tf` file and add the following:

   {{% rad file="snippets/recipes/terraform/main.tf" embed=true %}}  

    <!--TODO: Replace with button to download like in the composite recipe tutorial. Save the full contents for the Recipe how-to which explains what all of this is.  -->

1. Register the Terraform configuration as a Recipe called `default`. Since Recipes are registered with Environments, use the  `default` environment created in the previous tutorial.

    ```bash
    rad recipe register default \
      --environment default \
      --resource-type Radius.Resources/postgreSQL \
      --template-kind terraform \
      --template-path git::<git-server-name>/<repository-name>.git//<directory>/<subdirectory>
    ```

    For example, if the `main.tf` file is in a GitHub repository named `recipes` in a directory called `/kubernetes/postgresql`, the command would look like this:
    
    ```bash 
      --template-path git::https://github.com/<github-user-name>/recipes.git//kubernetes/postgresql
    ```

    The output will be:

    ```
    Successfully linked recipe "default" to environment "default"
    ```

1. Verify the Recipe is registered using the [`rad recipe list`]({{< ref rad_recipe_list >}}) command. 

    ```bash
    rad recipe list
    ```

    ```
    $ rad recipe list
    RECIPE    TYPE                         TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
    ...
    default   Radius.Resources/postgreSQL  terraform                       git::https://github.com/<github-user-name>/recipes.git//kubernetes/postgres
    ```
    
{{% /codetab %}}
{{% codetab %}}

Bicep templates must be stored in an OCI registry accessible by Radius. As discussed in the prerequisites, using an OCI registry with anonymous access is easiest for this tutorial, otherwise you will need to configure [authentication]({{< ref "guides/recipes/howto-private-bicep-registry" >}}). Learn more about Recipes in this [How-to guide]({{< ref "/guides/recipes/howto-author-recipes" >}}).

1. Create a new file called `postgresql.bicep` and add the following:

   {{% rad file="snippets/recipes/bicep/postgresql.bicep" embed=true %}}

    <!--TODO: Replace with button to download like in the composite recipe tutorial. Save the full contents for the Recipe how-to which explains what all of this is.  -->

1. Publish the Recipe to the OCI registry. Make sure to replace `host` and `registry` with your container registry.

    ```bash
    rad bicep publish --file postgresql.bicep --target br:<host>/<registry>/postgresql:latest
    ```

    ```
    Successfully published Bicep file "postgresql.bicep" to "<host>/<registry>/postgresql:latest"
    ```

1. Register the Bicep template as a Recipe called `default`. Since Recipes are registered with Environments, use the  `default` environment created in the previous tutorial.

    ```bash
    rad recipe register default --environment default \
      --resource-type Radius.Resources/postgreSQL \
      --template-kind bicep \
      --template-path <host>/<registry>/postgresql:latest
    ```

    ```
    Successfully linked recipe "default" to environment "default"
    ```

1. Verify the Recipe is registered using the [`rad recipe list`]({{< ref rad_recipe_list >}}) command. You should see output similar to:

   ```bash
   rad recipe list
   ```

    ```
    $ rad recipe list
    RECIPE    TYPE                         TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
    ...
    default   Radius.Resources/postgreSQL  bicep                           <host>/<repository>/postgresql:latest
    ```

{{% /codetab %}}
{{< /tabs >}}

{{< button text="Next step: create-environment" page="create-environment" color="primary" >}}
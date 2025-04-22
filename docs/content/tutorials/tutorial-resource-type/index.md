---
type: docs
title: "Tutorial: Create a Resource Type in Radius"
linkTitle: "Create resource type"
description: "Learn how to define and deploy a resource type in your Radius application"
weight: 200
categories: ["resource-types"]
---

## Overview

Radius includes several built-in resource types which developers can use to build applications. These include core resource types such as containers, gateways, and secrets. You can also create your own resource types. This tutorial guides you through creating a PostgreSQL resource and deploying the sample Todo List application with PostgreSQL.

{{< image src="todolist.png" alt="Diagram of the Todo List with PostgreSQL" width=600px >}}

## Prerequisites

- [A Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview" >}}) to host Radius and the Todo List application. Make sure to follow the instructions under the [Supported Kubernetes clusters]({{< ref "/guides/operations/kubernetes/overview#supported-kubernetes-clusters" >}}). 
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- Setup a registry to publish and pull the Recipes
  - If you prefer Bicep as the language to author your Recipe, set up an [OCI-compliant container registry ](https://oras.land/docs/compatible_oci_registries/) with required permissions to publish and pull Recipes.
  - If you prefer Terraform as the language to author your Recipe, set up a [Terraform registry](https://developer.hashicorp.com/terraform/registry) with required permissions to publish and pull Recipes.
- The [Bicep extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}}) for VS Code is recommended for Bicep language support

## Step 1: Install Radius and initialize a new environment

1. Begin in a new directory for your application:

   ```bash
   mkdir todolist
   cd todolist
   ```

1. Initialize a new Radius environment:

   *Select 'No' when prompted to setup application in the current directory?*

   ```bash
   rad init
   ```

## Step 2: Create a PostgreSQL resource type in Radius

To create a PostgreSQL resource type in Radius, first create the resource type definition then add the resource type to Radius.

1. Create a new file called `postgreSQL.yaml` and add the following:

   {{% rad file="snippets/postgreSQL.yaml" lang=YAML embed=true %}}

    The PostgreSQL resource type definition includes:

    - `name`: The namespace of the resource type used to group resource types; must be in the form PrimaryName.SecondaryName
    - `types`: The resource type name
    - `apiVersions`: The version of the schema defined below; currently must be `2023-10-01-preview` 
    - `schema`: The schema defines the properties of the resource type.
        - `environment`: The Radius environment in which the resource type is deployed; this property is set by Radius when the resource is deployed
        - `application`: The application to which the resource belongs to
        - `status`: This is a read-only property that is set by the Recipe that includes connection information to the resource type.
    - `capabilities`: This specifies features of the resource type. The only available option is `SupportsRecipes` which indicates that the resource type can be deployed via a Recipe.
    <br></br>

1. Create the resource type using the [rad resource-type]({{< ref rad_resource-type_create >}}) command:

    ```bash
    rad resource-type create postgreSQL -f postgreSQL.yaml
    ```

## Step 3: Register a Recipe for the PostgreSQL resource type

[Recipes]({{< ref "/guides/recipes/overview" >}}) define how resource types are deployed. To deploy the PostgreSQL resource type, you must create a Bicep Template or a Terraform module and publish it to a registry. Then register the template or module as a Recipe in the Radius environment. 

  {{< tabs "Bicep" "Terraform" >}}{{% codetab %}} 

1. Create a new file called `postgreSQL.bicep` and add the following:

   {{% rad file="snippets/recipes/bicep/postgreSQL.bicep" embed=true %}}

1. Make sure your preferred OCI-compliant container is set up with appropriate permissions to publish and pull Recipes. For example, if you are using GitHub container registry, follow the instructions [here](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry). The easiest option to authenticate is to generate a Personal Access token (PAT) with read, write and delete access to the package. Follow this [how-to-guide]({{< ref "/guides/recipes/howto-private-bicep-registry" >}}) if you want to publish to a private registry.

1. Publish the Recipe to the container registry using the below command. Make sure to replace `host` and `repository` with your container registry.

    ```bash
    rad bicep publish --file postgreSQL.bicep --target br:<host>/<repository>/postgresql:latest
    ```
1. Register the Bicep template as the `default` Recipe in the `default` environment (the default environment was created when `rad init` was run)

    ```bash
    rad recipe register default --environment default --resource-type MyCompany.Resources/postgreSQL --template-kind bicep --template-path <host>/<repository>/postgresql:latest
    ```
1. Verify the Recipe is registered to the `default` environment

    ```bash
    rad recipe list
    ```
    You should see the Recipe for the PostgreSQL resource type listed in the output.

    ```bash
    RECIPE    TYPE                            TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
    default   MyCompany.Resources/postgreSQL  bicep                           <host>/<repository>/postgresql:latest
    ...
    ```
{{% /codetab %}}

{{% codetab %}}

1. Create a new file called `main.tf` and add the following:

   {{% rad file="snippets/recipes/terraform/main.tf" embed=true %}}
   
   Learn more about Authoring Terraform Modules as Recipes in this [how-to-guide]({{< ref "/guides/recipes/howto-author-recipes" >}}).
    
1. Follow the documentation on [Publish Bicep templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/publish-templates) to set up and publish the postgreSQL Bicep template to a container registry. If you want to pull Bicep templates from a private registry, follow the how-to-guide on [pulling Bicep templates from a private registry]({{< ref "/guides/recipes/bicep/howto-private-registry" >}}).

1. Follow the documentation on [Publish modules](https://developer.hashicorp.com/terraform/registry/modules/publish) to set up and publish the postgreSQL Terraform module to a Terraform registry. If you want to pull Terraform modules from a private registry, follow the how-to-guide on [pulling Terraform modules from a private registry](https://docs.radapp.io/guides/recipes/terraform/howto-private-registry/)

1. Register the Terraform module as the `default` Recipe in the `default` environment (the default environment was created when `rad init` was run)

    ```bash
    rad recipe register default --environment default --resource-type MyCompany.Resources/postgreSQL --template-kind terraform --template-path git::<path to your tf module>
```
1. Verify the Recipe is registered to the `default` environment

    ```bash
    rad recipe list
    ```
    You should see the Recipe for the PostgreSQL resource type listed in the output.

    ```bash
    RECIPE    TYPE                            TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
    default   MyCompany.Resources/postgreSQL  terraform                       git::<path to your tf module>
    ...
    ```
    {{% /codetab %}}
    {{< /tabs >}}

## Step 4: Generate a Bicep extension

For the rad CLI and VS Code to recognize the PostgreSQL resource type, a [Bicep extension](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-extension) must be generated and added to the [`bicepconfig.json`]({{< ref "/guides/tooling/bicepconfig/overview" >}}) file.

1. Generate the Bicep extension using the [rad bicep publish-extension]({{< ref rad_bicep_publish-extension >}}) command:

    ```bash
    rad bicep publish-extension -f postgreSQL.yaml --target ./mycompany.tgz
    ```
    The bicep extension `mycompany` is generated and saved to the `mycompany.tgz` file. 
    
1. Open the `bicepconfig.json` file and replace it with the below config.

    ```bash
    {
        "experimentalFeaturesEnabled": {
            "extensibility": true
        },
        "extensions": {
            "radius": "br:biceptypes.azurecr.io/radius:latest",
            "aws": "br:biceptypes.azurecr.io/aws:latest",
            "mycompany": "./mycompany.tgz"
        }
    }
    ```

## Step 5: Author the Todo List application with PostgreSQL

1. Create `app.bicep` and add the Todo List application.
    
    ```bicep
    extension radius
    ```
   {{% rad file="snippets/app.bicep" embed=true marker="//APP" %}}

1. Add the `mycompany` extension and the PostgreSQL resource type
   
    ```bicep
    extension mycompany
    ```
   {{% rad file="snippets/app.bicep" embed=true marker="//POSTGRESQL" %}}

1. Add the `demo` container definition along with the connection to the PostgreSQL resource type as environment variables. 

   {{% rad file="snippets/app.bicep" embed=true marker="//CONTAINER" %}}

   {{% alert title="Caution" color="warning" %}}
   In this example the POSTGRESQL_PASSWORD is stored as a cleartext property for demo purposes. In production environments, always use secrets to store and reference sensitive information like passwords.
   {{% /alert %}}

1. Your final `app.bicep` file should look like this:

   {{% rad file="snippets/app.bicep" embed=true %}}

## Step 5: Run the application

Run the application using `rad run`. The `rad run` command sets up port forwarding to the application. .

```sh
rad run app.bicep
```
Visit the application at [http://localhost:3000](http://localhost:3000).You should see the Radius Connections section with new environment variables added. The `demo` container now has connection information for PostgreSQL (`CONNECTION_POSTGRESQL_HOST`, `CONNECTION_POSTGRESQL_PORT`, etc.)

{{< image src=todolist_postgresql.png" alt="Todo List with PostgreSQL connection" width=800px >}}

## Step 6: Clean up

To clean up the resources created in this tutorial, run the following commands

1. Delete the application and all resources created by the application

    ```bash
    rad app delete -application todolist
    ```
2. Delete the environment

    ```bash
    rad env delete -environment default
    ```
3. Delete the PostgreSQL resource type

    ```bash
    rad resource-type delete MyCompany.Resources/postgreSQL
    ```
4. Uninstall Radius 

    ```bash
    rad uninstall kubernetes
    ```
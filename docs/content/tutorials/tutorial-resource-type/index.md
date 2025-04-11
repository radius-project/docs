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

- [A Kubernetes cluster to host Radius and the Todo List application]({{< ref "/guides/operations/kubernetes/overview" >}}) 
- An OCI-compliant container registry with permissions to publish and pull Recipes 
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- The [Bicep extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}}) for VS Code is recommended for Bicep language support

## Step 0: Set up a Kubernetes cluster and local container registry

If you do not have preferred way of creating a Kubernetes cluster or a container registry, create a [k3d](https://k3d.io/stable/) cluster with a local registry using the below command:

```bash
k3d cluster create <myclustername> --registry-create reciperegistry:51351
```

## Step 1: Install Radius and initialize a new environment

1. Make sure your cluster is set as your current-context

    ```bash
    kubectl config current-context
    ```

1. Begin in a new directory for your application:

   ```bash
   mkdir todolist
   cd todolist
   ```

1. Initialize a new Radius environment:

   *Select 'Yes' when prompted to setup application in the current directory?*

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

[Recipes]({{< ref "/guides/recipes/overview" >}}) define how resource types are deployed. To deploy the PostgreSQL resource type, you must create a Bicep template and publish it to an OCI registry. Then register the template as a Recipe in the Radius environment. 
 
1. Create a new file called `postgreSQL.bicep` and add the following:

   {{% rad file="snippets/recipes/bicep/postgreSQL.bicep" embed=true %}}

1. Publish the Recipe to an OCI-compliant container registry. 

   {{< tabs LocalRegistry ExternalRegistry >}}{{% codetab %}} 
The example below publishes to a local registry created with k3d in step 0.
    
```bash
rad bicep publish --file postgreSQL.bicep --target br:localhost:51351/recipes/postgres:latest --plain-http
```
    {{% /codetab %}}

    {{% codetab %}}

1. Make sure your preferred OCI-compliant container is set up with appropriate permissions to publish and pull Recipes. For example, if you are using GitHub container registry, follow the instructions [here](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry). The easiest option is to authenticate is to generate a Personal Access token (PAT) with read, write and delete access to the package. Follow this [how-to-guide]({{< ref "/guides/recipes/howto-private-bicep-registry" >}}) if you want to publish to a private registry

1. Publish the Recipe to the container using the below command. Make sure to replace `<username>` with your GitHub username.

    ```bash
    rad bicep publish --file postgreSQL.bicep --target br:<host>/<repository>/postgresql:latest
    ```
    {{% /codetab %}}
    {{< /tabs >}}

1. Register the Bicep template as the `default` Recipe in the `default` environment (the default environment was created when `rad init` was run)

    {{< tabs LocalRegistry ExternalRegistry >}}{{% codetab %}}
```bash
rad recipe register default --environment default --resource-type MyCompany.Resources/postgreSQL --template-kind bicep --template-path reciperegistry:5000/recipes/postgres:latest --plain-http
```
   {{% /codetab %}}
    {{% codetab %}}
```bash
rad recipe register default --environment default --resource-type MyCompany.Resources/postgreSQL --template-kind bicep --template-path <host>/<repository>/postgresql:latest
```
{{% /codetab %}}
    {{< /tabs >}}
1. Verify the Recipe is registered to the `default` environment

    ```bash
    rad recipe list
    ```
    You should see the Recipe for the PostgreSQL resource type listed in the output.

    ```bash
    RECIPE    TYPE                            TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
    default   MyCompany.Resources/postgreSQL  bicep                            ghcr.io/<username>/recipes/postgresql:1.0
    ...
    ```

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

## Step 5: Add a PostgreSQL database to the Todo List application

1. Open `app.bicep` and add the `mycompany` extension and the PostgreSQL resource type
   
    ```bicep
    extension mycompany
    ```
   {{% rad file="snippets/app.bicep" embed=true marker="//POSTGRESQL" %}}

1. Add the connection from your container to the PostgreSQL resource type as environment variables. Replace the `demo` container with the definition below

   {{% rad file="snippets/app.bicep" embed=true marker="//CONTAINER" %}}

   {{% alert title="Caution" color="warning" %}}
   In this example the POSTGRESQL_PASSWORD is stored as a cleartext property for demo purposes. In production environments, always use secrets to store and reference sensitive information like passwords.
   {{% /alert %}}

## Step 5: Run the application

Run the application using `rad run`. The `rad run` command sets up port forwarding to the application. Visit the application at [http://localhost:3000](http://localhost:3000).

```sh
rad run app.bicep
```

You should see the Radius Connections section with new environment variables added. The `demo` container now has connection information for PostgreSQL (`CONNECTION_POSTGRESQL_HOST`, `CONNECTION_POSTGRESQL_PORT`, etc.)

{{< image src=todolist_postgresql.png" alt="Todo List with PostgreSQL connection" width=800px >}}


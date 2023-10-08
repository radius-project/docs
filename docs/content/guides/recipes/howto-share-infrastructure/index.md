---
type: docs
title: "How-To: Share infrastructure between Recipes"
linkTitle: "Share infrastructure"
description: "Learn how to share infrastructure between Recipes"
weight: 600
categories: "How-To"
tags: ["recipes"]
---

Many cloud resources use a hierarchal resource model where capacity is defined as an "account", "server", or "cluster", and usage of that capacity is defined as a "database", "table", or similar. For example, one SQL server can support many SQL databases.

For Recipes it can be useful to share capacity between Recipes but create new instances in that capacity as part of the Recipe. (_each Recipe instance creates a new SQL database in an existing SQL server_). This guide will show how to setup shared infrastructure between Recipes.

## Pre-requisites

- [rad CLI]({{< ref "/guides/tooling/rad-cli/overview" >}})

## Step 1: Define an environment

Begin by defining an environment "demo-shared-env" in a file named `env.bicep`:

{{< ref file="snippets/env.bicep" embed=true marker="//ENV" >}}

## Step 2: Add a shared SQL server

To your `env.bicep` file add a SQL server which will be shared amongst Recipes:

{{< tabs Azure AWS >}}

{{< codetab >}}
{{< rad file="snippets/env-azure.bicep" marker="//SQL" >}}
{{< /codetab >}}

{{< codetab >}}
{{< rad file="snippets/env-aws.bicep" marker="//SQL" >}}
{{< /codetab >}}

{{< /tabs >}}

## Step 3: Author a Recipe using the shared SQL server

This example shows `shared-sql`, a [community Recipe](https://github.com/radius-project/recipes) that accepts the SQL server ID as a parameter and deploys a new database within it:

{{< tabs Azure AWS >}}

{{< codetab >}}
{{< rad file="snippets/recipe-azure.bicep" >}}
{{< /codetab >}}

{{< codetab >}}
{{< rad file="snippets/recipe-aws.bicep" >}}
{{< /codetab >}}

{{< /tabs >}}

## Step 4: Add a Recipe to the environment

Add the `shared-sql` Recipe to your environment, passing in the SQL server ID as a parameter to the Recipe. This will be passed in to the Recipe for every Recipe run:

{{< tabs Azure AWS >}}

{{< codetab >}}
{{< rad file="snippets/env-azure.bicep" marker="//ENVIRONMENT" >}}
{{< /codetab >}}

{{< codetab >}}
{{< rad file="snippets/env-aws.bicep" marker="//ENVIRONMENT" >}}
{{< /codetab >}}

{{< /tabs >}}

## Step 5: Deploy the environment

Deploy the environment + Recipe to your Radius cluster:

```bash
rad deploy env.bicep
```

## Step 6: Define two SQL databases

Add two SQL databases to a new file, `app.bicep`:

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 7: Deploy the application

Deploy `app.bicep` with [`rad deploy`]({{< ref rad_deploy >}}):

```bash
rad deploy app.bicep -a demo-shared-app
```

You should see the application deployed:

```

```

## Step 8: Verify the SQL database was deployed

Verify both SQL databases were deployed and share the common cloud resource with [`rad resource show`]({{< ref rad_resource_show >}}):

```bash
rad resource show sqldatabases db1 -o json

rad resource show sqldatabases db2 -o json
```

You should see `outputResources` with an ID that shows the same shared SQL server:

```

```

## Done

Now that you've deployed and verified that infrastructure can be shared amongst Recipes, cleanup the SQL databases with [`rad env delete`]({{< ref rad_env_delete >}}):

```bash
rad env delete demo-shared-env -y
```

Also make sure to delete the SQL server with the Azure or AWS CLIs or portal/console. **`rad env delete` does not currently delete non-Recipe cloud resources.**

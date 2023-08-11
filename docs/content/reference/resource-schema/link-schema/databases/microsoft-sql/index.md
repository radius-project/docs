---
type: docs
title: "Microsoft SQL Server database"
linkTitle: "Microsoft SQL"
description: "Sample application running on a user-managed Azure SQL Database"
weight: 100
categories: "Schema"
---

## Overview
This application showcases how Radius can use a user-manged Azure SQL Database.

## Resource format

{{< tabs Recipe Manual >}}

{{< codetab >}}

{{< rad file="snippets/sql-recipe.bicep" embed=true marker="//SQL" >}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/sql-manual.bicep" embed=true marker="//SQL" >}}

{{< /codetab >}}

{{< /tabs >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. | `sql`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| application | n | The ID of the application resource this resource belongs to. | `app.id`
| environment | y | The ID of the environment resource this resource belongs to. | `env.id`
| [resourceProvisioning](#resource-provisioning) | n | Specifies how the underlying service/resource is provisioned and managed. Options are to provision automatically via 'recipe' or provision manually via 'manual'. Selection determines which set of fields to additionally require. Defaults to 'recipe'. | `manual`
| [recipe](#recipe) | n | Configuration for the Recipe which will deploy the backing infrastructure. | [See below](#recipe)
| [resources](#resources)  | n | An array of IDs of the underlying resources for the link. | [See below](#resources)
| server | n | The fully qualified domain name of the SQL server. | `sql.hello.com`
| database | n | The name of the SQL database. | `5000`
| port | n | The SQL database port. | `1433`
| username | n | The username for the SQL database. | `'myusername'`
| [secrets](#secrets) | n | Secrets used when building the link from values. | [See below](#secrets)

### Secrets

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| connectionString | n | The connection string for the SQL database. Write only. | `'https://mysqlserver.cluster.svc.local,password=*****,....'`
| password | n | The password for the SQL database. Write only. | `'mypassword'`

#### Recipe

| Property | Required | Description | Example(s) |
|------|:--------:|-------------|---------|
| name | n | Specifies the name of the Recipe that should be deployed. If not set, the name defaults to `default`. | `name: 'azure-prod'`
| parameters | n | An object that contains a list of parameters to set on the Recipe. | `{ size: 'large' }`

#### Resources

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| id | n |  Resource ID of the supporting resource. |`sqlDb.id`

## Resource provisioning

### Provision with a Recipe

[Recipes]({{< ref "/recipes-section/howto-author-recipes" >}}) automate infrastructure provisioning using approved templates.
When no Recipe configuration is set Radius will use the Recipe registered as the **default** in the environment for the given resource. Otherwise, a Recipe name and parameters can optionally be set.

### Provision manually

If you want to manually manage your infrastructure provisioning outside of Recipes, you can set `resourceProvisioning` to `'manual'` and provide all necessary parameters and values and values that enable Radius to deploy or connect to the desired infrastructure.
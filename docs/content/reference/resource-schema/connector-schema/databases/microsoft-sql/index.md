---
type: docs
title: "Microsoft SQL Server database"
linkTitle: "Microsoft SQL"
description: "Sample application running on a user-managed Azure SQL Database"
weight: 100
---

This application showcases how Radius can use a user-manged Azure SQL Database.

## Resource format

{{< tabs Resource Values >}}

{{< codetab >}}
{{< rad file="snippets/sql-resource.bicep" embed=true marker="//SQL" >}}
{{< /codetab >}}

{{< codetab >}}
{{< rad file="snippets/sql-values.bicep" embed=true marker="//SQL" >}}
{{< /codetab >}}

{{< /tabs >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. | `mongo`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| application | n | The ID of the application resource this resource belongs to. | `app.id`
| environment | y | The ID of the environment resource this resource belongs to. | `env.id`
| resource  | n | The ID of the underlying resource for the connector. Used when building the connector from a resource. | `sqlDb.id`
| server | n | The fully qualified domain name of the SQL server. | `sql.hello.com`
| database | n | The name of the SQL database. | `5000`

## Supported resources

- [Azure SQL](https://docs.microsoft.com/en-us/azure/azure-sql/)

## Connections

[Services]({{< ref services >}}) can define [connections]({{< ref connections-model >}}) to connectors using the `connections` property. This allows the service to access properties of the connector and contributes to to visualization and health experiences.

### Environment variables

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-SERVER` | The fully-qualified hostname of the database server. |
| `CONNECTION_<CONNECTION-NAME>-DATABASE` | The name of the SQL Server database. |

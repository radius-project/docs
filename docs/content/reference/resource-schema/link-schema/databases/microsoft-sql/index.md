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
| resourceProvisioning | n | Specifies how the underlying service/resource is provisioned and managed. | `manual`
| resources  | n | The IDs of the underlying resource for the link. Used when building the link from resources. | `sqlDb.id`
| server | n | The fully qualified domain name of the SQL server. | `sql.hello.com`
| database | n | The name of the SQL database. | `5000`
| port | n | The MongoDB port. | `1433`
| username | n | The username for the SQL database. | `'myusername'`
| [secrets](#secrets) | n | Secrets used when building the link from values. | [See below](#secrets)

### Secrets

| Property | Required | Description | Example(s) |
|----------|:--------:|-------------|------------|
| connectionString | n | The connection string for the SQL database. Write only. | `'https://mymongo.cluster.svc.local,password=*****,....'`
| password | n | The password for the SQL database. Write only. | `'mypassword'`


## Supported resources

- [Azure SQL](https://docs.microsoft.com/en-us/azure/azure-sql/)

## Connections

[Services]({{< ref container >}}) can define [connections]({{< ref appmodel-concept >}}) to links using the `connections` property. This allows the service to access properties of the link and contributes to to visualization and health experiences.

### Environment variables

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-SERVER` | The fully-qualified hostname of the database server. |
| `CONNECTION_<CONNECTION-NAME>-DATABASE` | The name of the SQL Server database. |

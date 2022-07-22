---
type: docs
title: "Microsoft SQL Server database"
linkTitle: "Microsoft SQL"
description: "Sample application running on a user-managed Azure SQL Database"
weight: 100
---

This application showcases how Radius can use a user-manged Azure SQL Database. 

## Supported resources

- [Azure SQL Container](https://hub.docker.com/_/microsoft-mssql-server)
- [Azure SQL](https://docs.microsoft.com/en-us/azure/azure-sql/)

## Resource format

{{< rad file="snippets/unmanaged.bicep" embed=true marker="//DATABASE" >}}

| Property | Description | Example |
|----------|-------------|---------|
| resource | The ID of the Azure SQL Database to use for this resource. | `server::sqldb.id` |
| server | The name of the server. | `myserver` |
| database | The fully qualified domain name of the SQL database. | `myserver.database.com` |

## Connections

[Services]({{< ref services >}}) can define [connections]({{< ref connections-model >}}) to connectors using the `connections` property. This allows the service to access properties of the connector and contributes to to visualization and health experiences.

### Environment variables

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-SERVER` | The fully-qualified hostname of the database server. |
| `CONNECTION_<CONNECTION-NAME>-DATABASE` | The name of the SQL Server database. |

---
type: docs
title: "Microsoft SQL Server database"
linkTitle: "Microsoft SQL"
description: "Sample application running on a user-managed Azure SQL Database"
weight: 100
---

This application showcases how Radius can use a user-manged Azure SQL Database. 


## Platform resources

| Platform                             | Resource                                                       |
| ------------------------------------ | -------------------------------------------------------------- |
| [Microsoft Azure]({{< ref azure>}})  | [Azure SQL](https://docs.microsoft.com/en-us/azure/azure-sql/) |
| [Kubernetes]({{< ref kubernetes >}}) | Not compatible                                                 |

## Configuration

| Property | Description                                                                         | Example(s)         |
| -------- | ----------------------------------------------------------------------------------- | ------------------ |
| managed  | Indicates if the resource is Radius-managed. If no, a `Resource` must be specified. | `false`            |
| resource | The ID of the user-managed SQL Database to use for this resource.                  | `server::sqldb.id` |

## Resource lifecycle

This sample uses Bicep parameters to pass the resource ID of the database as well as the username and password.

{{< rad file="snippets/unmanaged.bicep" embed=true marker="//PARAMETERS" >}}

Pass the ID of the database into the connector:

{{< rad file="snippets/unmanaged.bicep" embed=true marker="//DATABASE" >}}

Radius does not have access to the username and password used to access your database. You should provide this when building a connection string in Bicep.

{{< rad file="snippets/unmanaged.bicep" embed=true marker="//CONTAINER" >}}

## Connections

[Services]({{< ref services >}}) can define [connections]({{< ref connections-model >}}) to connectors using the `connections` property. This allows the service to access properties of the connector and contributes to to visualization and health experiences.

### Environment variables

Connections to the SQL connector result in the following environment variables being set on your service:

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-SERVER` | The fully-qualified hostname of the database server. |
| `CONNECTION_<CONNECTION-NAME>-DATABASE` | The name of the SQL Server database. |

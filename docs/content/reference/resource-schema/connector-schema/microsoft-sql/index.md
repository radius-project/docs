---
type: docs
title: "Microsoft SQL Server database"
linkTitle: "Microsoft SQL database"
description: "Sample application running on a user-managed Azure SQL Database"
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

[Services]({{< ref container-schema >}}) can define [connections]({{< ref connections-model >}}) to connectors using the `connections` property. This allows the service to access properties of the connector and contributes to to visualization and health experiences.

### Environment variables

| Variable | Description |
|----------|-------------|
| `CONNECTION_<CONNECTION-NAME>-SERVER` | The fully-qualified hostname of the database server. |
| `CONNECTION_<CONNECTION-NAME>-DATABASE` | The name of the SQL Server database. |

## Starter

You can get up and running quickly with a SQL Database by using a starter:

{{% alert title="Known issue: dependsOn" color="warning" %}}
Any service that consumes the `existing` resource will need to manually add a `dependsOn` reference to the starter module. This requirement will be removed in an upcoming release. See the [webapp tutorial]({{< ref webapp-add-database >}}) for an example.
{{% /alert %}}

### Container

The module `'br:radius.azurecr.io/starters/sql:latest'` deploys a SQL Server container and outputs a `microsoft.com.SQLDatabase` resource.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter.bicep" embed=true >}}

#### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the SQL Database | Yes | - |
| adminPassword | The password for the SQL Server administrator | Yes | - |
| databaseName | The name for your SQL Database. | Yes | - |
| serverName | The name of the Azure SQL Server | No | `'sql-${uniqueString(resourceGroup().id, deployment().name)}'` |

#### Outputs

The output of this module is a name and ID for a `microsoft.com.SQLDatabase` resource.

| Parameter | Description | Type |
|-----------|-------------|------|
| sqlUsername | The username for the SQL Server. Always 'sa'. | string |

### Azure SQL Database

The module `'br:radius.azurecr.io/starters/sql-azure:latest'` deploys an Azure SQL Server & Database and outputs a `microsoft.com.SQLDatabase` resource.

To use this template, reference it in Bicep as:

{{< rad file="snippets/starter-azure.bicep" embed=true >}}

#### Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|:--------:|---------|
| radiusApplication | The application resource to use as the parent of the SQL Database | Yes | - |
| adminLogin | The username for the SQL Server administrator | Yes | - |
| adminPassword | The password for the SQL Server administrator | Yes | - |
| databaseName | The name for your SQL Database. | Yes | - |
| serverName | The name of the Azure SQL Server | No | `'sql-${uniqueString(resourceGroup().id, deployment().name)}'` |
| location | The Azure region to deploy the Azure SQL Server | No | `resourceGroup().location` |
| skuName | The Azure SQL Server SKU | No | `'Standard'` |
| skuTier | The Azure SQL Server SKU tier | No | `'Standard'` |

#### Outputs

The output of this module is a name and ID for a `microsoft.com.SQLDatabase` resource.

| Parameter | Description | Type |
|-----------|-------------|------|
| sqlUsername | The username for the SQL Server. | string |

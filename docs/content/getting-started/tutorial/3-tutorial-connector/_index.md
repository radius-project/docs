---
type: docs
title: "Swap connector resource"
linkTitle: "Swap connector resource"
description: "Move to production using Azure infrastructure"
weight: 4000
slug: "swap-connector"
---

This step of swapping a connector resource for an Azure resource shows how the application can easily movev to production in Azure. Once the developer does a handoff, the operator sets up the production environments to port the application. If you are a developer who handles everything related to deployments, this would be applicable to you as well.

## Ensure you have an Azure cloud provider configured

If you have created an environment without an Azure cloud provider, or if you are using the environment created via Codespaces, you need to [add an Azure cloud provider to your existing environment]({{<ref "providers#add-a-cloud-provider-to-an-existing-environment">}}) in order to continue with the rest of the tutorial:

1. Begin by logging into the Azure CLI and setting your subscription scope:

    ```bash
    az login
    ```
    ```bash
    az account set --subscription <subscription name>
    ```
1. Reinitialize your Radius environment, this time configuring the Azure cloud provider:

   {{< tabs "GitHub Codespace/k3s" "AKS" >}}
   
   {{% codetab %}}
   ```bash
   rad env init kubernetes --public-endpoint-override 'localhost:8081' -i
   ```
   {{% /codetab %}}
   
   {{% codetab %}}
   ```bash
   rad env init kubernetes -i
   ```
   {{% /codetab %}}
   
   {{< /tabs >}}

## Azure CosmosDB Mongo DB

The file `azure-cosmosdb.bicep` contains the definition to deploy the Azure CosmsoDB:

{{< rad file="snippets/azure-cosmosdb.bicep" embed=true replace-key-cosmos="//COSMOS" replace-value-cosmos="resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {...}" >}}

## Swap the module

Replace the existing Bicep module in `app.bicep` to reference the Azure CosmosDB file:

{{< rad file="snippets/app-azure.bicep" embed=true marker="//MONGOMODULE">}}

## Update the connector definition

Lastly, update the connector definition to use a resource reference instead of manually defining the connection string by replacing `secrets: {...}` with `resource: mongo.outputs.cosmosDatabaseId`:

{{< rad file="snippets/app-azure.bicep" embed=true marker="//DATABASE CONNECTOR">}}

## Add the location parameter

Next, add the following line to the top of your Bicep file:

```sh
param location string = resourceGroup().location
```

## Deploy the application with Azure database

1. In a terminal window deploy `app.bicep`:

   ```sh
   rad deploy app.bicep
   ```
   This may take a few minutes to create the database. On completion, you will see the following resources:

   ```
   Deployment In Progress:

    Completed            http-route      Applications.Core/httpRoutes
    Completed            webapp          Applications.Core/applications
    Completed            mongo-module    Microsoft.Resources/deployments
    Completed            public          Applications.Core/gateways
    Completed            db              Applications.Connector/mongoDatabases
    Completed            frontend        Applications.Core/containers

   Deployment Complete 
   ```

1. Just like before, a public endpoint will be available through the gateway. Use [`rad app status`]({{< ref rad_application_status >}}) to get the endpoint:

   ```bash
   rad app status -a webapp
   ```
   ```
   APPLICATION  RESOURCES
   webapp       4

   GATEWAY   ENDPOINT
   public    PUBLIC_ENDPOINT
   ```

1. To test your application, navigate to the public endpoint that was printed by `rad app status -a webapp`. You should see a page like:

   <img src="todoapp-withdb.png" width="400" alt="screenshot of the todo application with a database">

   If your page matches, then it means that the container is able to communicate with the database. Just like before, you can test the features of the todo app. Add a task or two. Now your data is being stored in an actual database.

## Cleanup

{{% alert title="Delete environment" color="warning" %}}
If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) to delete all Radius resourcesrunning on the Kubernetes Cluster.
{{% /alert %}}

{{% alert title="Cleanup Azure Resources" color="warning" %}}
Azure resources are not deleted when deleting a Radius environment, so to prevent additional charges, make sure to delete all resources from the resource group you used for your cloud provider.
{{% /alert %}}

{{% alert title="Delete other Kubernetes resources used" color="warning" %}}
Additional Kubernetes resources need to be cleaned up that were deployed for Mongo. Run the following commands to delete these resources:

```bash
kubectl delete statefulset,serviceaccount,clusterrolebinding,clusterrole,secret mongo
kubectl delete pvc db-storage-claim-mongo-0
```

{{% /alert %}}

{{< button text="Previous step: Author and deploy app" page="2-tutorial-app" >}}

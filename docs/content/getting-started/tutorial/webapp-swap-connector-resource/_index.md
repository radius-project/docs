---
type: docs
title: "Swap  connector resource"
linkTitle: "Swap connector resource"
description: "Swap a connector resource for an Azure resource to back the connector and deploy it to an environment with Azure cloud provider configured"
weight: 4000
slug: "frontend"
---

As enterprises have separate teams handling deployment responsibilities, this step of initializing production environment and porting the application is carried out by the infrastructure admin. If you are a developer who handles everything related to deployments, you can do this step as well.

To abstract the infrastructure workflows from the development workflows, we are working on a solution called **Radius recipes** that will enable the infra-admin to prepare connector recipes with all the organizational requirements which can be used by the developers without having to worry about provisioning or managing a resource. Check back for more updates in our future releases

## Prerequisites

1. Azure subscription
2. [az CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)

## Intialize Radius environment with Azure cloud provider
For simplicity purposes, you can reuse the same kubernetes cluster that you used before or you can create a new cluster by picking any one from the [prerequisites list]({{< ref "tutorial.d#prerequisites">}})

You can view the current context for kubectl by running
```bash
kubectl config current-context
```

Use the [`rad env init kubernetes` command]({{< ref rad_env_init_Kubernetes >}}) to initialize a new environment into your current kubectl context.
```bash
rad env init kubernetes -i
```
1. Specify the option to add the Azure provider
1. Specify your Azure subscription and resource group
1. Create an [Azure service principal](https://docs.microsoft.com/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac) with the [proper permissions](https://aka.ms/azadsp-more)

## Swap the connector for an azure resource
As an infra-admin, create an infra.bicep and paste the following to create an Azure cosmos db 

{{< rad file="snippets/infra-azure.bicep" embed=true >}}


### App.bicep

The app.bicep handed over by the developer should be like below 

{{< rad file="snippets/app-container.bicep" embed=true >}}

## Deploy the application with Azure database

{{% alert title="Known issue: Azure deployments" color="warning" %}}
There is a known issue where deployments to Azure will fail with a "NotFound" error for templates containing starters. This is being addressed in an upcoming release. As a workaround submit the deployment a second time. The second deployment should succeed.
{{% /alert %}}

1. In a terminal window deploy the infra.bicep file to set up the Azure cosmos db :

   ```sh
   rad deploy infra.bicep
   ```

   This may take a few minutes to create the database. On completion, you will see the following resources:

   ```sh
   Resources:
      Application              todoapp
      mongo.com.MongoDatabase  db
   ```
2. Next, deploy the app.bicep to deploy the front end service

   ```sh
   rad deploy app.bicep
   ```

   This may take a few minutes to create the database. On completion, you will see the following resources:

   ```sh
   Resources:
      Application              todoapp
      Container                frontend
      HttpRoute                frontend-route
      Gateway                  frontend-gateway
      mongo.com.MongoDatabase  db
   ```

   Just like before, a public endpoint will be available through the gateway.

   ```sh
   Public Endpoints:
      Gateway            frontend-gateway       IP-ADDRESS
   ```

1. To test your application, navigate to the public endpoint that was printed at the end of the deployment. You should see a page like:

   <img src="todoapp-withdb.png" width="400" alt="screenshot of the todo application with a database">

   If your page matches, then it means that the container is able to communicate with the database. Just like before, you can test the features of the todo app. Add a task or two. Now your data is being stored in an actual database.

## Cleanup

{{% alert title="Delete application" color="warning" %}} If you're done with testing, you can use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}) to prevent additional charges in your Azure subscription. {{% /alert %}}

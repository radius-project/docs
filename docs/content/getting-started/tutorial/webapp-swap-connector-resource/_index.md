---
type: docs
title: "Swap  connector resource"
linkTitle: "Swap connector resource"
description: "Swap a connector resource for an Azure resource to back the connector and deploy it to an environment with Azure cloud provider configured"
weight: 4000
slug: "frontend"
---

As enterprises have separate teams handling deployment responsibilities, initializing production environment and porting the application is carried out by the infrastructure admin. If you are a developer who handles everything related to deployments, this would be applicable to you as well.

To abstract the infrastructure workflows from the development workflows, we are working on a solution called **Radius recipes** that will enable the infra-admin to prepare connector recipes with all the organizational requirements which can be used by the developers without having to worry about provisioning or managing a resource. Check back for more updates in our future releases

## Intialize Radius environment with Azure cloud provider
You can reuse the same environment created previously if you have configured it with Azure cloud provider or you can create a new environment by following the instructions [here]({{<ref providers>}})

## Swap the connector for an azure resource

The app.bicep from the previous step should look like this 

{{< rad file="snippets/app-container.bicep" embed=true >}}

Update the bicep file like below to swap the connector resource with an Azure cosmosdb resource

{{< rad file="snippets/app-azure.bicep" embed=true >}}

## Deploy the application with Azure database

{{% alert title="Known issue: Azure deployments" color="warning" %}}
There is a known issue where deployments to Azure will fail with a "NotFound" error for templates containing starters. This is being addressed in an upcoming release. As a workaround submit the deployment a second time. The second deployment should succeed.
{{% /alert %}}

1. In a terminal window deploy the app.bicep file :

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

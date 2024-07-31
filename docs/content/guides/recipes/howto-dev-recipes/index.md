---
type: docs
title: "How-To: Use local-dev Recipes"
linkTitle: "local-dev Recipes"
description: "Learn how to use the pre-defined Recipes that makes it easy to run dependencies  in your application."
weight: 200
categories: "How-To"
tags: ["recipes"]
---

Local development environments created by the rad init command include a set of pre-defined Recipes called [`local-dev` Recipes]({{< ref "guides/recipes/overview##use-lightweight-local-dev-recipes" >}}), to get lightweight containerized infrastructure up and running quickly. This guide teaches how to use a local dev recipe to deploy a Redis container to a Kubernetes cluster.

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [`bicepconfig.json`]({{< ref "/guides/tooling/bicepconfig/overview" >}})
- [Setup a supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})

## Step 1: Initialize a Radius environment

1. Begin in a new directory for your application:

   ```bash
   mkdir recipes
   cd recipes
   ```
1. Initialize a new dev environment:

   ```bash
   rad init
   ```

   **Select 'No' when prompted to create an application.**

1. Use [`rad recipe list`]({{< ref rad_recipe_list >}}) to view the Recipes in your environment:

   ```bash
   rad recipe list 
   ```

   You should see a table of available Recipes:

   ```
   NAME      TYPE                                    TEMPLATE KIND  TEMPLATE VERSION  TEMPLATE
   default   Applications.Datastores/sqlDatabases    bicep                            ghcr.io/radius-project/recipes/local-dev/sqldatabases:latest
   default   Applications.Messaging/rabbitMQQueues   bicep                            ghcr.io/radius-project/recipes/local-dev/rabbitmqqueues:latest
   default   Applications.Dapr/pubSubBrokers         bicep                            ghcr.io/radius-project/recipes/local-dev/pubsubbrokers:latest
   default   Applications.Dapr/secretStores          bicep                            ghcr.io/radius-project/recipes/local-dev/secretstores:latest
   default   Applications.Dapr/stateStores           bicep                            ghcr.io/radius-project/recipes/local-dev/statestores:latest
   default   Applications.Datastores/mongoDatabases  bicep                            ghcr.io/radius-project/recipes/local-dev/mongodatabases:latest
   default   Applications.Datastores/redisCaches     bicep                            ghcr.io/radius-project/recipes/local-dev/rediscaches:latest
   ```

   > Visit the [Recipes repo](https://github.com/radius-project/recipes) to learn more about the definition of these `local-dev` recipe templates.

   When a Recipe is named "default" it will be used automatically when a resource doesn't specify a Recipe name. This makes it easy for applications to fully defer to the Environment for how to manage infrastructure.  

## Step 2: Define your application

Create a file named `app.bicep` with the following set of resources:

{{< rad file="snippets/app.bicep" embed=true >}}

Note that no Recipe name is specified within 'db', so it will be using the default Recipe for Redis in your environment.

## Step 3: Deploy your application

1. Run [`rad run`]({{< ref rad_run >}}) to deploy your application:

   ```bash
   rad run ./app.bicep -a local-dev-app
   ```

   You should see the following output:

   ```
   Building app.bicep...
   Deploying template './app.bicep' for application 'local-dev-app' and environment 'default' from workspace 'default'...

   Deployment In Progress...

   Completed            db              Applications.Datastores/redisCaches
   Completed            frontend        Applications.Core/containers

   Deployment Complete

   Resources:
      frontend        Applications.Core/containers
      db              Applications.Datastores/redisCaches

    Starting log stream...
   ```

   Your application is now deployed and running in your Kubernetes cluster.

## Step 4: Verify Redis containers are deployed

1. Visit [`http://localhost:3000`](http://localhost:3000) in your browser.

   You can now see both the environment variables of your container under Radius Connections as well as interact with the `Todo App` and add/remove items in it as wanted:

1. List your Kubernetes Pods to see the infrastructure containers deployed by the Recipe:

   ```bash
   kubectl get pods -n default-local-dev-app
   ```

   You will see your 'frontend' container, along with the Redis cache that was automatically created by the default local-dev Recipe:

   ```
   NAME                                   READY   STATUS    RESTARTS   AGE
   frontend-6d447f5994-pnmzv              1/1     Running   0          13m
   redis-ymbjcqyjzwkpg-66fdbf8bb6-brb6q   2/2     Running   0          13m
   ```

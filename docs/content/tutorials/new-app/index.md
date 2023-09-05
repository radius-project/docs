---
type: docs
title: "Tutorial: Create a Radius application"
linkTitle: "Create an application"
description: "Dive into Radius to learn how to define, deploy, and manage an application"
weight: 100
categories: "Tutorial"
---

## Prerequisites

- [Kubernetes cluster]({{< ref "supported-clusters" >}})
- [rad CLI]({{< ref howto-rad-cli >}})
- [Radius environment]({{< ref "/guides/deploy-apps/environments/howto-environment" >}})

## Step 1: Create the application

Radius applications bring together all your resources into a single unit. This makes it easy to deploy, manage, and delete all the "stuff" that makes up your application. Applications can be defined as part of your infrastructure-as-code (IaC) file.

1. Begin by creating a new file named `app.bicep`:

   ```bash
   touch app.bicep
   ```

1. Open `app.bicep` and add the following code to define a new application named `myapp`:

   {{% rad file="snippets/app.bicep" embed=true %}}

1. Deploy `app.bicep` with [`rad deploy`]({{< ref rad_deploy >}}):

   ```bash
   rad deploy app.bicep
   ```

   You should see your application deployed:

   ```
   Building .\app.bicep...
   Deploying template '.\app.bicep' for application 'myapp' and environment 'default' from workspace 'default'...

   Deployment In Progress...


   Deployment Complete

   Resources:
       myapp           Applications.Core/applications
   ```

1. View the full application definition by running [`rad app show -o json`]({{< ref rad_application_show >}}):

   ```bash
   rad app show myapp -o json
   ```

   You will see the full application definition in JSON format:
   
   ```
   {
     "id": "/planes/radius/local/resourcegroups/default/providers/Applications.Core/applications/myapp",
     "location": "global",
     "name": "myapp",
     "properties": {
       "environment": "/planes/radius/local/resourceGroups/default/providers/Applications.Core/environments/default",
       "provisioningState": "Succeeded",
       "status": {
         "compute": {
           "kind": "kubernetes",
           "namespace": "default-myapp"
         }
       }
     },
     "systemData": {},
     "tags": {},
     "type": "Applications.Core/applications"
   }
   ```
   
   There are a couple of things to note about the application definition:

   1. The `id` property is the fully-qualified resource ID of the application. This value is used to uniquely identify the application in the Radius system.
   1. The `location` property is the location of the application. For now, all applications are deployed to the `global` location.
   1. The application is part of the 'default' environment. This is the default environment created when you run `rad init`.
   1. The `status` property contains the `compute` property, which includes where services in the application are deployed. In this case, the application is deployed to a Kubernetes cluster in the `default-myapp` namespace.

## Step 2: Create your first container

Now that you have your application defined, you can add resources to it. The first resource we'll add is a container. Containers are the basic building block of Radius applications and are where your code runs.

1. Update your `app.bicep` file with a container named `frontend`. Also add some environment variables:

   {{% rad file="snippets/app-container.bicep" embed=true marker="//CONTAINER" markdownConfig="{linenos=table,linenostart=13}" %}}

1. Run `app.bicep` with [`rad run`]({{< ref rad_run >}}). This will deploy the container, forward logs, and automatically set up port forwarding:

   ```bash
   rad run app.bicep
   ```

   ```
   Building .\app.bicep...
   Deploying template '.\app.bicep' for application 'myapp' and environment 'default' from workspace 'default'...
   
   Deployment In Progress...
   
   
   Deployment Complete
   
   Resources:
       myapp           Applications.Core/applications
       frontend        Applications.Core/containers
   
   Starting log stream...
   ```

1. Open [localhost:3000](http://localhost:3000) to interact with the frontend container. You should see the container's connections and metadata:

    **TODO: Screenshot**

1. Press CTRL+C to terminate the port-forward and log stream.

## Step 3: Add a dependency

Next, you can add a dependency to your container. Dependencies are outside services/infrastructure that your container interacts with, such as a database, cache, message queue, etc.

1. Add a Redis cache to your `app.bicep` file:

   {{% rad file="snippets/app-redis.bicep" embed=true marker="//REDIS" markdownConfig="{linenos=table,linenostart=27}" %}}

1. Add a connection from your container to the Redis cache:

   {{% rad file="snippets/app-redis.bicep" embed=true marker="//CONTAINER" markdownConfig="{linenos=table,hl_lines=[\"12-17\"],linenostart=13}" %}}

1. Re-run your app with [`rad run`]({{< ref rad_run >}}):

    ```bash
    rad run app.bicep
    ```

    ```
    Building .\app.bicep...
    Deploying template '.\app.bicep' for application 'myapp' and environment 'default' from workspace 'default'...
    
    Deployment In Progress...
    
    
    Deployment Complete
    
    Resources:
        myapp           Applications.Core/applications
        frontend        Applications.Core/containers
        redis           Applications.Datastores/redisCaches
    
    Starting log stream...
    ```

1. Open [localhost:3000](http://localhost:3000) to interact with the frontend container. You should see the container's connections and metadata, this time with a connection to the Redis cache and new environment variables set:

    **TODO: Screenshot**

1. Press CTRL+C to terminate the port-forward and log stream.

## Step 4: Add a second container

In addition to adding dependencies, you can also add additional containers to your application which can interact with each other. This is useful for breaking up your application into smaller, more manageable pieces.

1. Add a second container named `backend` to your `app.bicep` file, specifying the image and port to open to other containers:

   {{% rad file="snippets/app-backend.bicep" embed=true marker="//BACKEND" markdownConfig="{linenos=table,linenostart=43}" %}}

1. Add a new connection from your `frontend` container to the `backend` container:

   {{% rad file="snippets/app-backend.bicep" embed=true marker="//CONTAINER" markdownConfig="{linenos=table,hl_lines=[\"16-18\"],linenostart=13}" %}}

1. Re-run your app with [`rad run`]({{< ref rad_run >}}):

    ```bash
    rad run app.bicep
    ```

    ```
    Building .\app.bicep...
    Deploying template '.\app.bicep' for application 'myapp' and environment 'default' from workspace 'default'...
    
    Deployment In Progress...
    
    
    Deployment Complete
    
    Resources:
        myapp           Applications.Core/applications
        frontend        Applications.Core/containers
        backend         Applications.Core/containers
        redis           Applications.Datastores/redisCaches
    
    Starting log stream...
    ```

1. Open [localhost:3000](http://localhost:3000) to interact with the frontend container. You should see the container's connections and metadata, this time with a connection to the backend container and new environment variables set:

    **TODO: Screenshot**

    Note the environment variables that are set with connection information for the backend container.

## Step 5: Add a gateway

Finally, you can add a gateway to your application. Gateways are used to expose your application to the outside world. They can be used to expose a single container or multiple containers.

1. Add a gateway to your `app.bicep` file:

   {{% rad file="snippets/app-gateway.bicep" embed=true marker="//GATEWAY" markdownConfig="{linenos=table,linenostart=63}" %}}

1. Deploy your app with [`rad deploy`]({{< ref rad_deploy >}}):

    ```bash
    rad deploy app.bicep
    ```

    ```
    Building .\app.bicep...
    Deploying template '.\app.bicep' for application 'myapp' and environment 'default' from workspace 'default'...
    
    Deployment In Progress...
    
    
    Deployment Complete
    
    Resources:
        myapp           Applications.Core/applications
        frontend        Applications.Core/containers
        backend         Applications.Core/containers
        gateway         Applications.Core/gateways
        redis           Applications.Datastores/redisCaches
    
    TODO: GATEWAY URL
    ```

1. Open the gateway URL in your browser. Unlike before, you are connecting to the gateway instead of the container directly. You should see the same container connections and metadata as before.

1. Done! You've successfully created your first Radius application.

## Next steps

Now that you've created your first application you can try out one of the other [tutorials]({{< ref tutorials >}}) or jump into the [user guides]({{< ref guides >}}) to learn more about Radius.


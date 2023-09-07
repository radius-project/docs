---
type: docs
title: "Tutorial: Create a Radius application"
linkTitle: "Create an application"
description: "Dive into Radius to learn how to define, deploy, and manage an application"
weight: 100
categories: "Tutorial"
---

This tutorial will walk you through the basics of creating a new Radius application. You will learn how to:

1. Define and deploy Radius application
1. Add a container to your application and customize it
1. Add a Mongo database to your application and connect it to your container
1. Add a second container and connect it to your other container
1. Expose your application to the internet through a gateway

By the end of the tutorial, you will created and deployed a new Radius application.

<img src="diagram.png" alt="Diagram of the application resources and their connections" width=600px >

## Prerequisites

- [Kubernetes cluster]({{< ref "supported-clusters" >}})
- [rad CLI]({{< ref howto-rad-cli >}})

## Step 1: Initialize a Radius environment

Radius environments are where applications are deployed, and determine how an application runs on a particular platform. If you don't have one already, initialize a new  environment in your favorite Kubernetes cluster with [`rad init`]({{< ref rad_init >}}):

```bash
rad init
```

## Step 2: Create an application

Radius applications bring together all your resources into a single understanding of what the app is. This makes it easy to deploy, manage, and delete all the "stuff" that makes up your application. Applications can be defined as part of your infrastructure-as-code (IaC) file.

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

   You should see your application resource deployed:

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

   1. The `id` property is the fully-qualified UCP resource ID of the application. This value is used to uniquely identify the application in the Radius system.
   1. The `location` property is the location of the application. For now, all applications are deployed to the `global` location.
   1. The application is part of the 'default' environment. This is the default environment created when you run `rad init`.
   1. The `status` property contains `compute` information, which includes where services in the application are to be deployed. In this case, the services are deployed into the `default-myapp` Kubernetes namespace, in the same cluster as the Radius installation.

## Step 3: Create your frontend container

Now that you have your application defined you can add resources to it. The first resource we'll add is a container. Containers are the basic building block of Radius applications and are where your code runs.

1. Update your `app.bicep` file with a container named `frontend`. Also add an environment variable to customize your container:

   {{% rad file="snippets/app-container.bicep" embed=true marker="//CONTAINER" markdownConfig="{linenos=table,linenostart=13}" %}}

1. Run `app.bicep` with [`rad run`]({{< ref rad_run >}}). This will deploy the container, forward logs, and automatically set up port forwarding:

   ```bash
   rad run app.bicep --application myapp
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

1. Open [localhost:3000](http://localhost:3000) to interact with the frontend container. You should see the container's connections and metadata. Expand the Environment Variables section to see the environment variables you set in the `app.bicep` file:

    <img src="demo-landing.png" alt="Screenshot of the Radius demo container" width=500px >

1. Press CTRL+C to terminate the port-forward and log stream.

## Step 4: Add a dependency and a connection

Next, you can add a dependency to your container. Dependencies are outside services/infrastructure that your container interacts with, such as a database, cache, message queue, etc.

1. Add a Mongo database to your `app.bicep` file:

   {{% rad file="snippets/app-mongo.bicep" embed=true marker="//MONGO" markdownConfig="{linenos=table,linenostart=27}" %}}

1. Add a connection from your container to the Mongo database:

   {{% rad file="snippets/app-mongo.bicep" embed=true marker="//CONTAINER" markdownConfig="{linenos=table,hl_lines=[\"16-20\"],linenostart=13}" %}}

1. Re-run your app with [`rad run`]({{< ref rad_run >}}):

    ```bash
    rad run app.bicep --application myapp
    ```

    ```
    Building .\app.bicep...
    Deploying template '.\app.bicep' for application 'myapp' and environment 'default' from workspace 'default'...
    
    Deployment In Progress...
    
    
    Deployment Complete
    
    Resources:
        myapp           Applications.Core/applications
        frontend        Applications.Core/containers
        mongodb         Applications.Datastores/mongoDatabases
    
    Starting log stream...
    ```

1. Open [localhost:3000](http://localhost:3000) to interact with the frontend container. You should see the container's connections and metadata, this time with a connection to the Mongo database and new environment variables set:

    <img src="demo-landing-connection.png" alt="Screenshot of the Radius demo container" width=500px >

1. Press CTRL+C to terminate the port-forward and log stream.

## Step 5: Add a backend container

In addition to dependencies, you can also add additional containers to your application which can interact with each other. This is useful for breaking up your application into smaller, more manageable pieces.

1. Add a second container named `backend` to your `app.bicep` file, specifying the image and port to open to other containers:

   {{% rad file="snippets/app-backend.bicep" embed=true marker="//BACKEND" markdownConfig="{linenos=table,linenostart=43}" %}}

1. Add a new connection from your `frontend` container to the `backend` container:

   {{% rad file="snippets/app-backend.bicep" embed=true marker="//CONTAINER" markdownConfig="{linenos=table,hl_lines=[\"20-22\"],linenostart=13}" %}}

1. Re-run your app with [`rad run`]({{< ref rad_run >}}):

    ```bash
    rad run app.bicep --application myapp
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
        mongodb         Applications.Datastores/mongoDatabases
    
    Starting log stream...
    ```

1. Open [localhost:3000](http://localhost:3000) to interact with the frontend container. You should see the container's connections and metadata, this time with a connection to the backend container and new environment variables set:

   <img src="demo-landing-backend.png" alt="Screenshot of the demo container with a connection to the backend container">

    Note the environment variables that are set with connection information for the backend container.

## Step 6: Add a gateway

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
        mongodb         Applications.Datastores/mongoDatabases
    
    Public Endpoints:
        gateway         Applications.Core/gateways http://localhost
    ```

1. Open the gateway URL in your browser. Unlike before, you are connecting to the gateway instead of the container directly. You should see the same container connections and metadata as before.

1. Done! You've successfully created your first Radius application.

## Next steps

Now that you've created your first application you can try out one of the other [tutorials]({{< ref tutorials >}}) or jump into the [user guides]({{< ref guides >}}) to learn more about Radius.


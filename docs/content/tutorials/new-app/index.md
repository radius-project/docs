---
type: docs
title: "Tutorial: Create a Radius Application"
linkTitle: "Create a new application"
description: "Learn how to define, deploy, and manage a new Radius Application"
weight: 100
categories: "Tutorial"
---

This tutorial will teach you the basics of creating a new Radius Application. You will learn how to:

1. Define and deploy a Radius Environment and Application
1. Add a container to your application and customize that container
1. Add a Mongo database to your application and connect it to your container
1. Add a second container and connect it to your first container
1. Securely expose your application to the internet through a gateway

By the end of the tutorial, you will have created and deployed a new Radius Application.

{{< image src="diagram.png" alt="Diagram of the application resources and their connections" width=600px >}}

## Prerequisites

- [Supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview" >}})
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension and Bicep configuration file]({{< ref "installation#step-2-install-the-radius-bicep-vs-code-extension" >}})

## Step 1: Initialize a Radius Environment and Application

[Radius Environments]({{< ref "/guides/deploy-apps/environments/overview" >}}) are where applications are deployed. Environments determine how an application runs on a particular platform (_like AWS or Azure_).

1. Begin by creating a new directory for your application:

   ```bash
   mkdir myapp
   cd myapp
   ```

1. Initialize a new Radius Environment with [`rad init`]({{< ref rad_init >}}):

   ```bash
   rad init
   ```

   When asked if you want to create a new application select "Yes". This will create a new file named `app.bicep` in your directory where your application will be defined. It will also create `bicepconfig.json` file that will contain the necessary setup to use Radius types with Bicep. 

   {{< alert title="💡 Development Environments" color="info" >}}
   By default `rad init` gets you up and running with a local, development-focused environment where most of the environment configuration is handled for you, including Recipes (_more on that soon_). If you would like to fully customize your environment, you can run `rad init --full`
   {{< /alert >}}

## Step 2: Inspect your Application

Radius Applications are where all your app's resources and relationships come together. Let's take a look at this Radius Application to learn more about it.

1. View the full Application definition by running [`rad app show -o json`]({{< ref rad_application_show >}}):

   ```bash
   rad app show myapp -o json
   ```

   You will see the full App definition in its raw JSON format:

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

   There are a few important things to note about the application definition:

   - **`id`** is the fully-qualified UCP resource ID of the application. This value is used to uniquely identify the application in the Radius system.
   - **`location`** is the _where_ your Application resides. For now, all applications are deployed to the `global` location, which corresponds to the cluster where Radius is running.
   - **`environment`** specifies the Radius Environment which the Applications "binds" to at deployment. This is what determines where containers should run (_Kubernetes_) and which namespace to deploy into (_prefixed with "default"_). In this case, the application will be deployed into the `default` Environment that was created by `rad init`.
   - **`compute`** specifies the hosting platform where running services in the Application will run. In this case, the services will be deployed into the `default-myapp` Kubernetes namespace within the same cluster where Radius is installed.

1. Let's take a look inside the Application to see what's deployed. Run [`rad app graph`]({{< ref rad_application_graph >}}) to print the Application's resources and relationships:

   ```bash
   rad app graph
   ```

   You'll see that nothing has been deployed yet and the app is empty:

   ```
   Displaying application: myapp

   (empty)
   ```

   Let's deploy some resources to start building out the application.

## Step 3: Inspect and deploy `app.bicep`

`app.bicep` will define all the resources (containers, gateways, cloud services, etc) that make up your application, including how those resources are connected to each other. Given this explicit and comprehensive application definition, Radius Application files make it simple to consistently deploy and manage your application.

1. Open `app.bicep` and see the scaffolded application created by `rad init`:

   {{% rad file="snippets/1-app.bicep" embed=true %}}

1. Deploy `app.bicep` with [`rad deploy`]({{< ref rad_deploy >}}):

   ```bash
   rad deploy app.bicep
   ```

   You should see your container deployed:

   ```
   Building .\app.bicep...
   Deploying template '.\app.bicep' for application 'myapp' and environment 'default' from workspace 'default'...

   Deployment In Progress...

   Deployment Complete

   Resources:
       demo            Applications.Core/containers
   ```

1. Run `rad app graph` again to see the container you just deployed:

    ```bash
    rad app graph
    ```

    You should see the container you just deployed, along with the underlying Kubernetes resources that were created to run it:

    ```
    Displaying application: myapp

   Name: demo (Applications.Core/containers)
   Connections: (none)
   Resources:
     demo (kubernetes: apps/Deployment)
     demo (kubernetes: core/Service)
     demo (kubernetes: core/ServiceAccount)
     demo (kubernetes: rbac.authorization.k8s.io/Role)
     demo (kubernetes: rbac.authorization.k8s.io/RoleBinding)
    ```

   {{< alert title="💡 Kubernetes mapping" color="info" >}}
   Radius Environments map how Applications "bind" to a particular platform. Earlier we saw the Application compute was set to `kubernetes` and the namespace was set to `default-myapp`. This means the container resources were deployed to the `default-myapp` namespace in the Kubernetes cluster where Radius is installed. Visit the [Kubernetes mapping docs]({{< ref "/guides/operations/kubernetes/overview#resource-mapping" >}}) to learn more.
   {{< /alert >}}

## Step 4: Run your application

When working with Radius Applications you will probably want to access container endpoints and view logs. [`rad run`]({{< ref rad_run >}}) makes it simple to deploy your application and automatically set up port-forwarding and log streaming:

```bash
rad run app.bicep
```

You should see the container deployed and the port-forward and log stream started:

```
Building .\app.bicep...
Deploying template '.\app.bicep' for application 'myapp' and environment 'default' from workspace 'default'...

Deployment In Progress...

..                   demo            Applications.Core/containers

Deployment Complete

Resources:
    demo            Applications.Core/containers

Starting log stream...

demo-bb9df8798-b68rc › demo
demo-bb9df8798-b68rc demo Using in-memory store: no connection string found
demo-bb9df8798-b68rc demo Server is running at http://localhost:3000
demo-bb9df8798-b68rc demo [port-forward] connected from localhost:3000 -> ::3000
```

Open [http://localhost:3000](http://localhost:3000) to view the Radius demo container:

{{< image src="demo-landing.png" alt="Screenshot of the Radius demo container" width=500px >}}

When you're done press `CTRL + c` to terminate the port-forward and log stream.

## Step 5: Add a database and a connection

In addition to containers, you can add dependencies like Redis caches, Dapr State Stores, Mongo databases, and more.

1. Add a Mongo database and an environment parameter to your `app.bicep` file:

   {{% rad file="snippets/2-app-mongo.bicep" embed=true marker="//MONGO" %}}

   {{< alert title="💡 Radius Recipes" color="info" >}}
   Note that when you added the Mongo database to your application you didn't need to specify _how or where_ to run the underlying infrastructure. The Radius Environment and its Recipes take care of that for you. Just like how the Radius Environment bound your container to a Kubernetes cluster, it also deploys and binds your Mongo database to underlying infrastructure using [Recipes]({{< ref "/guides/recipes/overview" >}}).
   {{< /alert >}}

1. To learn about the underlying Recipe that will deploy and manage the Mongo infrastructure run [`rad recipe show`]({{< ref rad_recipe_show >}}):

   ```bash
   rad recipe show default --resource-type Applications.Datastores/mongoDatabases
   ```

   You'll see details on the Recipe, including available parameters and defaults:

   ```
   NAME      TYPE                                    TEMPLATE KIND  TEMPLATE VERSION  TEMPLATE
   default   Applications.Datastores/mongoDatabases  bicep                            ghcr.io/radius-project/recipes/local-dev/mongodatabases:latest

   PARAMETER NAME  TYPE          DEFAULT VALUE   MIN       MAX
   username        string        admin           -         -
   password        secureString  Password1234==  -         -
   database        string                        -         -
   ```

   If you want to learn more about the Recipe template it's in the [Recipes repo](https://github.com/radius-project/recipes/blob/main/local-dev/mongodatabases.bicep).

1. Add a connection from your container to the Mongo database, which indicates to Radius that your container needs to communicate with the Mongo database:

   {{% rad file="snippets/2-app-mongo.bicep" embed=true marker="//CONTAINER" markdownConfig="{hl_lines=[\"16-20\"]}" %}}

   {{< alert title="💡 Radius Connections" color="info" >}}
   Radius Connections are more than just bookkeeping. They are used to automatically configure access for your containers. Learn more in the [containers documentation]({{< ref "/guides/author-apps/containers/overview" >}}).
   {{< /alert >}}

1. Re-run your app with [`rad run`]({{< ref rad_run >}}) to deploy the Mongo database and container and start the port-forward and log stream:

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
        demo            Applications.Core/containers
        mongodb         Applications.Datastores/mongoDatabases

    Starting log stream...
    ```

1. Open [localhost:3000](http://localhost:3000) to interact with the demo container. You should see the container's connections and metadata, this time with a connection to the Mongo database and new environment variables set:

    {{< image src="demo-landing-connection.png" alt="Screenshot of the Radius demo container" width=500px >}}

1. Press CTRL+C to terminate the port-forward and log stream.

1. Run `rad app graph` again to see the new dependency:

    ```bash
    rad app graph
    ```

    You should see the container and Mongo database you just deployed, along with the underlying Kubernetes resources that were created to run them:

    ```
    Displaying application: myapp

    Name: demo (Applications.Core/containers)
    Connections:
      demo -> mongodb (Applications.Datastores/mongoDatabases)
    Resources:
      demo (kubernetes: apps/Deployment)
      demo (kubernetes: core/Secret)
      demo (kubernetes: core/Service)
      demo (kubernetes: core/ServiceAccount)
      demo (kubernetes: rbac.authorization.k8s.io/Role)
      demo (kubernetes: rbac.authorization.k8s.io/RoleBinding)

    Name: mongodb (Applications.Datastores/mongoDatabases)
    Connections:
      demo (Applications.Core/containers) -> mongodb
    Resources:
      mongo-bzmp2btdgzez6 (kubernetes: apps/Deployment)
      mongo-bzmp2btdgzez6 (kubernetes: core/Service)
   ```

## Step 6: Add a backend container

In addition to dependencies, you can add more containers to make your application code more modular.  Containers can be configured to interact with each other as needed.

1. Add a second container named `backend` to your `app.bicep` file, specifying the image and port to open to other containers:

   {{% rad file="snippets/3-app-backend.bicep" embed=true marker="//BACKEND" %}}

1. Add a new connection from your `demo` container to the `backend` container:

   {{% rad file="snippets/3-app-backend.bicep" embed=true marker="//CONTAINER" markdownConfig="{hl_lines=[\"20-22\"]}" %}}

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
        demo            Applications.Core/containers
        backend         Applications.Core/containers
        mongodb         Applications.Datastores/mongoDatabases

    Starting log stream...
    ```

1. Open [localhost:3000](http://localhost:3000) to interact with the demo container. You should see the container's connections and metadata, this time with a connection to the backend container and new environment variables set:

   {{< image src="demo-landing-backend.png" alt="Screenshot of the demo container with a connection to the backend container" width=600px >}}

    Note the environment variables that are set with connection information for the backend container.

## Step 7: Add a gateway

Finally, you can add a gateway to your application. Gateways are used to expose your application to the internet. They can expose a single container or multiple containers.

1. Add a gateway to your `app.bicep` file:

   {{% rad file="snippets/4-app-gateway.bicep" embed=true marker="//GATEWAY" %}}

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
        demo            Applications.Core/containers
        backend         Applications.Core/containers
        gateway         Applications.Core/gateways
        mongodb         Applications.Datastores/mongoDatabases

    Public Endpoints:
        gateway         Applications.Core/gateways http://localhost
    ```

1. Open the gateway URL in your browser. Unlike before, you are connecting to the gateway instead of directly to the container. You will see the same container connections and metadata as before.

1. Done! You've successfully created your first Radius application.

## Next steps

Now that you've created your first application, try out more [tutorials]({{< ref tutorials >}}) or jump into the [user guides]({{< ref guides >}}) to learn more about Radius.

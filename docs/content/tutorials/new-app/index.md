---
type: docs
title: "Tutorial: Create a Radius Application"
linkTitle: "Create a new application"
description: "Learn how to define, deploy, and manage a new Radius Application"
weight: 100
categories: "Tutorial"
---

## Overview

This tutorial will teach you the basics of creating a new Radius Application. You will learn how to:

1. Define and deploy a Radius Environment and Application
1. Add a container to your application and customize that container
1. Add a MongoDB database to your application and connect it to your container
1. Add a second container and connect it to the first container
1. Expose your application through a Gateway

By the end of the tutorial, you will have created and deployed a new Radius Application.

{{< image src="todolist-app.png" alt="Diagram of the application resources and their connections" width=600px >}}

## Prerequisites

- [Supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-kubernetes-clusters" >}})
- [Radius CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep extension for VS Code]({{< ref "installation#step-2-install-the-vs-code-extension" >}})

## Step 1: Install Radius with a default Environment and Workspace

This tutorial will use the [`rad init`]({{< ref rad_initialize >}}) command to install Radius on a Kubernetes cluster and initialize the configuration with an Environment called *default* and Recipes for deploying to Kubernetes. Future tutorials will demonstrate using Recipes for deploying to AWS and Azure.

1. Create a new directory for the Todo List application.

   ```bash
   mkdir todolist
   cd todolist
   ```

1. Install Radius.

   ```bash
   rad init
   ```

   When asked if you want to create a new application select *Yes*. This will create a new file named `app.bicep` in your working directory where. It will also create a [`bicepconfig.json`]({{< ref "/guides/tooling/bicepconfig/overview" >}}) file that will contain the necessary configuration to use Radius core resource types. 

## Step 2: Explore the default configuration

Inspect the Workspace created by `rad init`. 

1. List the available Workspaces using [`rad workspace list`]({{< ref rad_workspace_list >}})

   ```bash
   rad workspace list
   ```

   ```
   $ rad workspace list
   WORKSPACE  KIND        KUBECONTEXT           ENVIRONMENT
   default    kubernetes  my-kube-context       default
   ```

   Show the current Workspace. The `--output json` will show all the details of the Workspace.

   ```bash
   rad workspace show -o json   
   ```

   ```
   $ rad workspace show -o json   
   {
     "connection": {
       "context": "my-kube-context",
       "kind": "kubernetes"
     },
     "environment": "/planes/radius/local/resourceGroups/default/providers/Applications.Core/environments/default",
     "scope": "/planes/radius/local/resourceGroups/default"
   }
   ```

   Notice that a Radius Workspace is a combination of a Kubernetes context, a Radius Environment, and a Resource Group.

   {{< alert title="💡 Workspaces" color="info" >}}
   [Workspaces]({{< ref Workspaces >}}) are configurations set for the Radius CLI. Similar to kubectl contexts, you can have multiple Workspaces pointing to different Radius installation, Resource Groups, and Environments.
   {{< /alert >}}

1. List the resource groups created by `rad init` using the [`rad group list`]({{< ref rad_group_list >}}) command. 

   ```bash
   rad group list
   ```

   ```
   $ rad group list                            
   GROUP     ID
   default   /planes/radius/local/resourcegroups/default
   ```

   `rad init` creates a group called `default`.

   {{< alert title="💡 Resource Groups" color="info" >}}
   Every resource deployed in Radius belongs to one and only [resource group]({{< ref Groups >}}). And each resource in a group must have a unique name. This includes environments and applications which are modeled as resources in Radius.
   {{< /alert >}}

1. Inspect the Environment using the [`rad environment list`]({{< ref rad_environment_list >}}) and [`rad environment show`]({{< ref rad_environment_show >}}) commands.

   ```bash
   rad environment list
   ```

   ```
   $ rad environment list
   RESOURCE  TYPE                            GROUP     STATE
   default   Applications.Core/environments  default   Succeeded
   ```

   ```bash
   rad environment show default --output json
   ```

   ```
   $ rad environment show default --output json
   {
     "id": "/planes/radius/local/resourcegroups/default/providers/Applications.Core/environments/default",
     "location": "global",
     "name": "default",
     "properties": {
       "compute": {
         "kind": "kubernetes",
         "namespace": "default"
       },
       "provisioningState": "Succeeded",
       "recipes": {
            ...
       }
     },
     ...
     "type": "Applications.Core/environments"
   }
   ```

   {{< alert title="💡 Development Environments" color="info" >}}
   By default `rad init` gets you up and running with a local, development-focused [environment](/guides/deploy-apps/environments/overview/) where most of the environment configuration is handled for you, including Recipes (_more on that soon_). If you would like to fully customize your environment, you can run `rad init --full`
   {{< /alert >}}

## Step 3: Deploy the Todo List application

The `app.bicep` file defines all the resources (Containers, Gateways, cloud services, etc.) that make up the Todo List application, including how those resources are connected to each other. 

1. Open `app.bicep` and review the application definition created by `rad init`. The Todo List application definition includes:

   {{% rad file="snippets/1-app.bicep" embed=true marker="//IMPORT" %}}

   The `extension` statement imports the resource types built into Radius.

   {{% rad file="snippets/1-app.bicep" embed=true marker="//PARAM" %}}

   The `application` parameter is defined so it can be used later in the resources. This parameter is set by the Radius CLI when deploying the application.

   {{% rad file="snippets/1-app.bicep" embed=true marker="//CONTAINER" %}}
   
   The initial version of the application only has a single container named demo.

1. Deploy Todo List application using the [`rad deploy`]({{< ref rad_deploy >}}) command.

   ```bash
   rad deploy app.bicep
   ```

   ```
   $ rad deploy app.bicep
   Building app.bicep...
   WARNING: The following experimental Bicep features have been enabled: Extensibility. Experimental features should be enabled for testing purposes only, as there are no guarantees about the quality or stability of these features. Do not enable these settings for any production usage, or your production environment may be subject to breaking.
   Deploying template 'app.bicep' for application 'todolist' and environment '/planes/radius/local/resourceGroups/default/providers/Applications.Core/environments/default' from workspace 'default'...

   Deployment In Progress... 

   Completes         demo            Applications.Core/containers

   Deployment Complete

   Resources:
     demo            Applications.Core/containers
   ```

1. Run `rad app graph` command to print the application resources and relationships:

    ```bash
    rad app graph
    ```

   You should see the container you just deployed, along with the underlying Kubernetes resources that were created to run it:

   ```
   $ rad app graph
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

## Step 4: Connect to the Todo List application

The `rad deploy` command simply deployed the application to the Kubernetes cluster but does not configure network access via an ingress controller or load balancer. In order to access the application, you must either setup Kubernetes port forwarding, or simply use the [`rad run`]({{< ref rad_run >}}) command which sets up port forwarding and log streaming. 

```bash
rad run app.bicep
```

You should see the container deployed and the port forward and log stream started:

```
$ rad run app.bicep
Building app.bicep...
WARNING: The following experimental Bicep features have been enabled: Extensibility. Experimental features should be enabled for testing purposes only, as there are no guarantees about the quality or stability of these features. Do not enable these settings for any production usage, or your production environment may be subject to breaking.
Deploying template 'app.bicep' for application 'todolist' and environment '/planes/radius/local/resourceGroups/default/providers/Applications.Core/environments/default' from workspace 'default'...

Deployment In Progress... 

Completes           demo            Applications.Core/containers

Deployment Complete

Resources:
    demo            Applications.Core/containers

Starting log stream...

+ demo-5bc9b77586-cf95n › demo
demo-5bc9b77586-cf95n demo No APPLICATIONINSIGHTS_CONNECTION_STRING found, skipping Azure Monitor setup
demo-5bc9b77586-cf95n demo Using in-memory store: no connection string found
demo-5bc9b77586-cf95n demo Server is running at http://localhost:3000
dashboard-5965dd78b9-xt2k6 dashboard [port-forward] connected from localhost:7007 -> ::7007
demo-5bc9b77586-cf95n demo [port-forward] connected from localhost:3000 -> ::3000
```

Open [http://localhost:3000](http://localhost:3000) to view the Radius demo container.

{{< image src="demo-landing.png" alt="Screenshot of the Radius demo container" width=500px >}}

When you're done press `CTRL + c` to terminate the port forward and log stream. The application continues to be deployed.

## Step 5: Add a database and a connection

Add a database to the Todo List application so that the todo items are persisted. Radius ships with a built-in MongoDB resource type.

1. Add a MongoDB database and an environment parameter to your `app.bicep` file:

   {{% rad file="snippets/2-app-mongo.bicep" embed=true marker="//MONGO" %}}

   {{< alert title="💡 Radius Recipes" color="info" >}}
   Note that when you added the MongoDB database to your application you didn't need to specify _how or where_ to run the underlying infrastructure. The Radius Environment and its Recipes take care of that for you. Just like how the Radius Environment bound your container to a Kubernetes cluster, it also deploys and binds your MongoDB database to underlying infrastructure using [Recipes]({{< ref "/guides/recipes/overview" >}}).
   {{< /alert >}}

1. To learn about the underlying Recipe that will deploy and manage the Mongo infrastructure run [`rad recipe show`]({{< ref rad_recipe_show >}}):

   ```bash
   rad recipe show default --resource-type Applications.Datastores/mongoDatabases
   ```

   You'll see details on the Recipe, including available parameters and defaults:

   ```
   $ rad recipe show default --resource-type Applications.Datastores/mongoDatabases
   NAME      TYPE                                    TEMPLATE KIND  TEMPLATE VERSION  TEMPLATE
   default   Applications.Datastores/mongoDatabases  bicep                            ghcr.io/radius-project/recipes/local-dev/mongodatabases:latest

   PARAMETER NAME  TYPE          DEFAULT VALUE   MIN       MAX
   username        string        admin           -         -
   password        secureString  Password1234==  -         -
   database        string                        -         -
   ```

   You can view the Bicep template used as the Recipe in the [Recipes GitHub repository](https://github.com/radius-project/recipes/blob/main/local-dev/mongodatabases.bicep).

1. Add a connection from your container to the MongoDB database, which indicates to Radius that your container needs to communicate with the database:

   {{% rad file="snippets/2-app-mongo.bicep" embed=true marker="//CONTAINER" markdownConfig="{hl_lines=[\"13-17\"]}" %}}

   {{< alert title="💡 Radius Connections" color="info" >}}
   Radius Connections are more than just bookkeeping. They are used to automatically configure access for your containers. Learn more in the [containers documentation]({{< ref "/guides/author-apps/containers/overview" >}}).
   {{< /alert >}}

1. Re-run your app using [`rad run`]({{< ref rad_run >}}) to deploy the MongoDB database and container and start the port forward and log stream:

   ```bash
   rad run app.bicep
   ```

1. Open [localhost:3000](http://localhost:3000) to interact with the demo container. You should see the container's connections and metadata, this time with a connection to the Mongo database and new environment variables set.

    {{< image src="demo-landing-connection.png" alt="Screenshot of the Radius demo container" width=500px >}}

1. Press `CTRL + c` to terminate the port forward and log stream.

1. Run `rad app graph` again to see the new resource.

   ```bash
   rad app graph
   ```

   You should see the container and MongoDB database you just deployed, along with the underlying Kubernetes resources that were created:

   ```
   $ rad app graph
   rad app graph
   Displaying application: todolist

   Name: demo (Applications.Core/containers)
   Connections:
     demo -> mongodb (Applications.Datastores/mongoDatabases)
   Resources:
     demo (apps/Deployment)
     demo (core/Secret)
     demo (core/Service)
     demo (core/ServiceAccount)
     demo (rbac.authorization.k8s.io/Role)
     demo (rbac.authorization.k8s.io/RoleBinding)

   Name: mongodb (Applications.Datastores/mongoDatabases)
   Connections:
     demo (Applications.Core/containers) -> mongodb
   Resources:
     mongo-bzmp2btdgzez6 (apps/Deployment)
     mongo-bzmp2btdgzez6 (core/Service)
   ```

## Step 6: Add a backend container

In addition to dependencies, you can add more containers to make your application code more modular. Containers can be configured to interact with each other as needed.

1. Add a second container named `backend` to your `app.bicep` file, specifying the image and port to open to other containers:

   {{% rad file="snippets/3-app-backend.bicep" embed=true marker="//BACKEND" %}}

1. Add a new connection from your `demo` container to the `backend` container:

   {{% rad file="snippets/3-app-backend.bicep" embed=true marker="//CONTAINER" markdownConfig="{hl_lines=[\"17-19\"]}" %}}

1. Re-run your app with [`rad run`]({{< ref rad_run >}}):

    ```bash
    rad run app.bicep
    ```

1. Open [localhost:3000](http://localhost:3000) to interact with the demo container. You should see the container's connections and metadata, this time with a connection to the backend container and new environment variables set:

   {{< image src="demo-landing-backend.png" alt="Screenshot of the demo container with a connection to the backend container" width=600px >}}

    Note the environment variables that are set with connection information for the backend container.

## Step 7: View the application graph in the Radius Dashboard

Navigate to the Radius Dashboard at [http://localhost:7007](http://localhost:7007/resources/default/Applications.Core/applications/todolist/application), You should see a visualization of the application graph for the application, including the connection from the `demo` container to `mongodb` and `backend`.

{{< image src="dashboard.png" alt="Screenshot of the Radius dashboard showing the demo container with a connection to the backend container" width=600px >}}

## Step 8: Add a Gateway

Finally, add a Gateway to your application to expose the application so that it is accessible from outside the cluster. 

1. Add a gateway to your `app.bicep` file:

   {{% rad file="snippets/4-app-gateway.bicep" embed=true marker="//GATEWAY" %}}

1. Deploy your app with [`rad deploy`]({{< ref rad_deploy >}}):

   ```bash
   rad deploy app.bicep
   ```

   ```
   Building app.bicep...
   Deploying template 'app.bicep' for application 'todolist' and environment '/planes/radius/local/resourceGroups/default/providers/Applications.Core/environments/default' from workspace 'default'...

   Deployment In Progress... 

   Completed            mongodb         Applications.Datastores/mongoDatabases
   Completed            backend         Applications.Core/containers
   Completed            gateway         Applications.Core/gateways
   Completed            demo            Applications.Core/containers

   Deployment Complete

   Resources:
      backend         Applications.Core/containers
      demo            Applications.Core/containers
      gateway         Applications.Core/gateways
      mongodb         Applications.Datastores/mongoDatabases

   Public Endpoints:
      gateway         Applications.Core/gateways http://gateway.todolist.172.18.0.6.nip.io
    ```

1. Open the gateway resource's URL in your browser. Unlike before, you are connecting to the Gateway instead of directly to the container. You will see the same container connections and metadata as before.

   {{% alert title="Warning" color="warning" %}}
   The application will only be accessible if the Kubernetes cluster you are using has a load balancer controller. If you are using AKS or EKS, the controller is enabled by default. If you are using a local Kubernetes cluster such as kind or k3d, you will need to configure a load balancer controller. See this tutorial for [k3d](https://k3d.io/v5.3.0/usage/exposing_services/) and this for [kind](https://kind.sigs.k8s.io/docs/user/loadbalancer).
   {{% /alert %}}

{{< button text="Next step: Add a custom resource →" page="custom-resource-type" >}}

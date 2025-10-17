---
type: docs
title: "5. Deploy Application"
linkTitle: "5. Deploy Application"
description: "Learn how to deploy, and manage a Radius Application"
weight: 600
categories: "Tutorial"
---

## Model the Todo List application 

Create a `app.bicep` file that defines all the resources (Containers, Gateways, cloud services, etc.) that make up the Todo List application, including how those resources are connected to each other. 

Add the following to `app.bicep`:

{{% rad file="snippets/app.bicep" embed=true marker="//IMPORT" %}}

The `extension radius` statement imports the resource types built into Radius. 

The `extension radiusResources` statement imports the PostgreSQL resource type created in the previous step.

{{% rad file="snippets/app.bicep" embed=true marker="//PARAM" %}}

   The `application` and `environment` parameters are defined so they can be used later in the resources. These parameters are set by the Radius CLI when deploying the application.

## Add the Application resource

{{% rad file="snippets/app.bicep" embed=true marker="//APPLICATION" %}}


### Add the Container resource

{{% rad file="snippets/app.bicep" embed=true marker="//CONTAINER" %}}
   
<add content about connections>

### Add the PostgreSQL resource

{{% rad file="snippets/app.bicep" embed=true marker="//DATABASE" %}}

   The PostgreSQL resource uses the custom resource type created in the previous step. The `environment` and `application` properties are set using the parameters defined earlier. The `size` property is set to `S` to create a small instance of PostgreSQL.

### Add the Gateway resource

{{% rad file="snippets/app.bicep" embed=true marker="//GATEWAY" %}}
   
   The Gateway resource exposes the demo container to the internet.

## Step 5: Deploy the application

Deploy the application using `rad deploy`.

```bash
rad deploy app.bicep
```

```
$ rad deploy app.bicep
Building app.bicep...
WARNING: The following experimental Bicep features have been enabled: Extensibility. Experimental features should be enabled for testing purposes only, as there are no guarantees about the quality or stability of these features. Do not enable these settings for any production usage, or your production environment may be subject to breaking.
Deploying template 'app.bicep' for application 'todolist' and environment '/planes/radius/local/resourceGroups/default/providers/Applications.Core/environments/default' from workspace 'default'...

Deployment In Progress... 

Completed            postgresql      Radius.Resources/postgreSQL
Completed            gateway         Applications.Core/gateways
Completed            demo            Applications.Core/containers

Deployment Complete

Resources:
    demo            Applications.Core/containers
    gateway         Applications.Core/gateways
    postgresql      Radius.Resources/postgreSQL

Public Endpoints:
    gateway         Applications.Core/gateways http://gateway.todolist.172.18.0.6.nip.io
```

Open the gateway URL in your browser. The Radius Connections section now has PostgreSQL details and MongoDB is no longer there.

{{< image src="todolist_postgresql.png" alt="Todo List with PostgreSQL connection" width=800px >}}

When you're done press `CTRL + c` to terminate the port forward and log stream. The application continues to be deployed.


## View the application graph in the Radius Dashboard

Navigate to the Radius Dashboard at [http://localhost:7007](http://localhost:7007/resources/default/Applications.Core/applications/todolist/application), You should see a visualization of the application graph for the application, including the connection from the `demo` container to `postgresql`

{{< image src="dashboard.png" alt="Screenshot of the Radius dashboard showing the demo container with a connection to the backend container" width=600px >}}


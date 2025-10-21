---
type: docs
title: "5. Deploy Application"
linkTitle: "5. Deploy Application"
description: "Learn how to deploy, and manage a Radius Application"
weight: 600
categories: "Tutorial"
---

In part five of this tutorial, you will deploy the Todo List application with the PostgreSQL resource type.

## Model the Todo List application 

Create a `app.bicep` file that defines all the resources that make up the Todo List application, including how those resources are connected to each other. 

Add the following to `app.bicep`:

{{% rad file="snippets/app.bicep" embed=true marker="//IMPORT" %}}

The `extension radius` statement imports the resource types built into Radius. 

The `extension radiusResources` statement imports the PostgreSQL resource type created in the previous step.

{{% rad file="snippets/app.bicep" embed=true marker="//PARAM" %}}

The `application` and `environment` parameters are defined so that they can be used later in the resources. These parameters are set by the Radius CLI when deploying the application.

### Add the Application resource

{{% rad file="snippets/app.bicep" embed=true marker="//APPLICATION" %}}

### Add the Container resource

{{% rad file="snippets/app.bicep" embed=true marker="//CONTAINER" %}}
   
When a connection is added between a container and another resource, the properties of the connected resource are created as environment variables in the container. If you prefer to not have environment variables created automatically, set the disableDefaultEnvVars property to true on the container resource. 

### Add the PostgreSQL resource

{{% rad file="snippets/app.bicep" embed=true marker="//DATABASE" %}}

## Deploy the application

Deploy the application using `rad deploy`.

```bash
rad deploy app.bicep --application todolist
```

```
Building app.bicep...
Deploying template 'app.bicep' for application 'todolist' and environment '/planes/radius/local/resourceGroups/my-group/providers/applications.core/environments/my-env' from workspace 'my-workspace'...

Deployment In Progress... 

Completed            todolist        Applications.Core/applications
Completed            database      Radius.Data/postgreSqlDatabases
Completed            frontend       Applications.Core/containers

Deployment Complete

Resources:
   todolist        Applications.Core/applications
   frontend        Applications.Core/containers
   database      Radius.Data/postgreSqlDatabases
```

Create a port-foward to access the Todo List application using the [rad resource expose]({{< ref rad_resource_expose>}}) command.

```bash
rad resource expose Applications.Core/containers frontend -a todolist --port 3000
```
Navigate to the [http://localhost:3000](http://localhost:3000) to access the Todo List application.

{{< image src="todolist.png" alt="Todo List with PostgreSQL connection" width=800px >}}

When you're done press `CTRL + c` to terminate the port forward and log stream. The application continues to be deployed.

## View the application graph in the Radius Dashboard

Navigate to the Radius Dashboard at [http://localhost:7007](http://localhost:7007/resources/my-group/Applications.Core/applications/todolist/application), You should see a visualization of the application graph for the application, including the connection from the `frontend` container to `database`

{{< image src="dashboard.png" alt="Screenshot of the Radius dashboard showing the frontend container with a connection to the backend container" width=800px >}}

## Cleanup

Delete the Todo List application:

```bash
rad app delete todolist
```

Optionally, uninstall Radius using the `purge` argument to remove Radius and all data:
```bash
rad uninstall kubernetes --purge
```
<br><br>
{{< button text="Next step: Explore How-To Guides" page="guides" >}}
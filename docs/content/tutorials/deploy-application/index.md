---
type: docs
title: "5. Deploy Application"
linkTitle: "5. Deploy Application"
description: "Learn how to deploy, and manage a Radius Application"
weight: 600
---

In part five of this tutorial, you will deploy the Todo List Application to the Environment.

## Model the Todo List Application

Create a file called `app.bicep` in your current directory. This file defines all the resources that make up the Todo List Application, including how those resources are connected to each other.

Add the following to `app.bicep`:

{{% rad file="snippets/app.bicep" embed=true marker="//IMPORT" %}}

The `extension radius` statement imports the resource types built into Radius. 

{{% rad file="snippets/app.bicep" embed=true marker="//PARAM" %}}

The `environment` parameter is set by the Radius CLI when deploying the application.

### Add the Application resource

The Application resource is the parent resource for all other resources. 
{{% rad file="snippets/app.bicep" embed=true marker="//APPLICATION" %}}

### Add the PostgreSQL resource

Notice the `size` parameter is set by the developer to 'S'.
{{% rad file="snippets/app.bicep" embed=true marker="//DATABASE" %}}

### Add the Container resource

{{% rad file="snippets/app.bicep" embed=true marker="//CONTAINER" %}}
   
When a connection is added between a container and another resource, the properties of the connected resource are created as environment variables in the container.

## Deploy the application

Deploy the application using `rad deploy`.

```bash
rad deploy app.bicep
```

You should see output similar to:

```
Building app.bicep...
Deploying template 'app.bicep' for application 'todolist' and environment '/planes/radius/local/resourceGroups/my-group/providers/applications.core/environments/my-env' from workspace 'my-workspace'...

Deployment In Progress... 

Completed            todolist        Applications.Core/applications
Completed            postgresql      Radius.Data/postgreSqlDatabases
Completed            frontend       Applications.Core/containers

Deployment Complete

Resources:
   todolist        Applications.Core/applications
   frontend        Applications.Core/containers
   postgresql      Radius.Data/postgreSqlDatabases
```

Set up port forwarding to access the Todo List Application using the `rad resource expose` command.

```bash
rad resource expose Applications.Core/containers frontend -a todolist --port 3000
```

Navigate to the [http://localhost:3000](http://localhost:3000) to access the Todo List application. You should see the Todo List application similar to this screenshot:

{{< image src="todolist.png" alt="Todo List with PostgreSQL connection" width=800px >}}

When you're done press `CTRL + c` to terminate the port forward and log stream. The application continues to be deployed.

## View the Application in the Radius Dashboard

If you already set up the port-forward in part 2, use the same to access the Radius Dashboard else create a new port-forward.

```bash
kubectl port-forward --namespace=radius-system svc/dashboard 7007:80 
```

Navigate to the Radius Dashboard at [http://localhost:7007](http://localhost:7007/resources/my-group/Applications.Core/applications/todolist/application), You should see a visualization of the application graph for the application, including the connection from the `frontend` container to `database`.

{{< image src="dashboard.png" alt="Screenshot of the Radius dashboard showing the frontend container with a connection to the backend container" width=800px >}}

## Cleanup

Delete the Todo List application using the `rad application delete` command:

```bash
rad application delete todolist
```

This will delete the Radius application and the deployed resources.

Optionally, uninstall Radius using the `--purge` flag to remove Radius and all its data from your Kubernetes cluster:

```bash
rad uninstall kubernetes --purge
```

<br>
{{< button text="Next step: Explore How-To Guides" page="guides" >}}
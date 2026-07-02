---
type: docs
title: "5. Deploy Application"
linkTitle: "5. Deploy Application"
description: "Learn how to deploy, and manage a Radius Application"
weight: 600
categories: "Tutorial"
---

In part five of this tutorial, you will deploy the Todo List Application to the Environment.

## Model the Todo List Application

Create a file called `app.bicep` in your current directory. This file defines all the resources that make up the Todo List Application, including how those resources are connected to each other.

Add the following to `app.bicep`:

{{% rad file="snippets/app.bicep" embed=true marker="//IMPORT" %}}

The `extension radius` statement imports the resource types built into Radius. 

The `extension radiusResources` statement imports the PostgreSQL resource type created in the previous step.

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

The `containers` property is a map of container definitions keyed by name. The outer resource name (`frontend`) identifies the workload in Radius and is used for the Kubernetes Deployment, while each inner key (also `frontend` here) names one container inside the workload and becomes the name of the Kubernetes Service when a port is exposed.

When a connection is added between a container and another resource, the properties of the connected resource are created as environment variables in the container.

## Deploy the application

Deploy the application using `rad deploy`.

```bash
rad deploy app.bicep
```

You should see output similar to:

```
Building app.bicep...
Deploying template 'app.bicep' for application 'todolist' and environment '/planes/radius/local/resourceGroups/my-group/providers/Radius.Core/environments/my-env' from workspace 'my-workspace'...

Deployment In Progress... 

Completed            todolist        Radius.Core/applications
Completed            postgresql      Radius.Data/postgreSqlDatabases
Completed            frontend        Radius.Compute/containers

Deployment Complete

Resources:
   todolist        Radius.Core/applications
   frontend        Radius.Compute/containers
   postgresql      Radius.Data/postgreSqlDatabases
```

## Port-forward to the application

`rad deploy` does not set up port forwarding. The default Kubernetes container Recipe creates a `ClusterIP` Service named after the inner container key (`frontend`) in the namespace configured on your Environment (`my-env` from part four).

In a new terminal, forward a local port to the Service:

```bash
kubectl port-forward svc/frontend 3000:3000 -n my-env
```

Leave this terminal running, then navigate to [http://localhost:3000](http://localhost:3000) to access the Todo List Application. You should see the Todo List application similar to this screenshot:

{{< image src="todolist.png" alt="Todo List with PostgreSQL connection" width=800px >}}

## Stream container logs

In another terminal, stream logs from the `frontend` container:

```bash
kubectl logs -f deployment/frontend -n my-env --all-containers=true
```

## View the Application in the Radius Dashboard

If you already set up the port-forward in part 2, use the same to access the Radius Dashboard else create a new port-forward.

```bash
kubectl port-forward --namespace=radius-system svc/dashboard 7007:80 
```

Navigate to the Radius Dashboard at [http://localhost:7007](http://localhost:7007/resources/my-group/Radius.Core/applications/todolist/application). You should see a visualization of the application graph for the application, including the connection from the `frontend` container to `postgresql`.

{{< image src="dashboard.png" alt="Screenshot of the Radius dashboard showing the frontend container with a connection to the backend container" width=800px >}}

## Cleanup

Stop the open port-forward and log-streaming terminals you started above by pressing `Ctrl+C` in each terminal (or close the terminal windows). This terminates the `kubectl port-forward` and `kubectl logs` processes.

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
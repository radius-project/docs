---
type: docs
title: "Quick Start: Deploy a containerized application"
linkTitle: "Quick Start"
weight: 10
description: "Perform a quick installation of Radius and deploy your first application"
aliases:
    - /getting-started/
    - /getting-started/tutorial/
    - /getting-started/install/
    - /getting-started/first-app/
    - /quick-start/
---

This guide will show you how to quickly get started with Radius. You will do a basic installation of Radius on a Kubernetes cluster then deploy the Todo List sample application.

## Prerequisites

For this quick start, you will only need a **Kubernetes cluster**. To install Radius your user must have the cluster-admin role. Radius <a href="https://docs.radapp.io/guides/operations/kubernetes/overview/#supported-kubernetes-clusters">supports</a> <a href="https://azure.microsoft.com/en-us/products/kubernetes-service">AKS</a>, <a href="https://aws.amazon.com/eks/">EKS</a>, <a href="https://k3d.io/">k3d</a>, and <a href="https://kind.sigs.k8s.io/">kind</a> clusters. For this quick start, running a Kubernetes cluster on your workstation with k3d or kind is recommended.

## Install the Radius CLI

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## Install Radius

Create a new directory for the Todo List application:

```bash
mkdir todolist
cd todolist
```

Ensure your cluster is set as your current context using `kubectl config current-context`. If the context needs updating, change it using `kubectl config set-context <context-name>`. Then install Radius using `rad initialize` command:

```bash
rad initialize
```

Select `Yes` to set up application in the current directory.

Example output:

```
Initializing Radius...

✅ Install Radius {{< param version >}}
    - Kubernetes cluster: k3d-k3s-default
    - Kubernetes namespace: radius-system
✅ Create new environment default
    - Kubernetes namespace: default
    - Recipe pack: local-dev
✅ Scaffold application todolist
✅ Update local configuration

Initialization complete! Have a RAD time 😎
```

## Run the Todo List Application

In addition to installing Radius, the `rad initialize` command creates a sample application definition, `app.bicep`:

```
extension radius

@description('The Radius Application ID. Injected automatically by the rad CLI.')
param application string

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}
```

Use the `rad run` command to deploy the application and setup port forwarding.

```bash
rad run app.bicep
```

This command:

- Creates a Deployment on the Kubernetes cluster
- Since a containerPort was specified, creates a ClusterIP Service on the Kubernetes cluster
- Sets up port forwarding from localhost to the container
- Sets up port forwarding from localhost to the Radius Dashboard
- Streams container logs to your terminal

## Browse the Todo List Application UI

Browse to the Todo List application by visiting [http://localhost:3000](http://localhost:3000). Notice that the Radius Connections section says "No connections defined." In the five part tutorial, you will add a database and a connection between the container and the database.

## Browse the Radius Dashboard

Browse to the Radius Dashboard by visiting [http://localhost:7007](http://localhost:7007). Find the Todo List Application under the Applications tab and examine its resources.

## View the Application Graph

The `rad app graph` command shows you all the resources that the application is composed of. 

```bash
rad app graph
```

You should see the following output, which lists the underlying Kubernetes resources running the application.

```
Displaying application: todolist

Name: demo (Applications.Core/containers)
Connections: (none)
Resources:
  demo (apps/Deployment)
  demo (core/Service)
  demo (core/ServiceAccount)
  demo (rbac.authorization.k8s.io/Role)
  demo (rbac.authorization.k8s.io/RoleBinding)
```

Congratulations, you have deployed your first application using Radius!


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
{{< button text="Next step: Read Radius concepts" page="concepts" >}}

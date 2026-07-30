---
type: docs
title: "Quick Start: Deploy a containerized application"
linkTitle: "Quick Start"
weight: 100
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

For this quick start, you will only need a **Kubernetes cluster**. To install Radius, your user must have the cluster-admin role. Radius <a href="{{< ref "installation#supported-kubernetes-clusters" >}}">supports</a> <a href="https://azure.microsoft.com/en-us/products/kubernetes-service">AKS</a>, <a href="https://aws.amazon.com/eks/">EKS</a>, <a href="https://k3d.io/">k3d</a>, and <a href="https://kind.sigs.k8s.io/">kind</a> clusters. For this quick start, running a Kubernetes cluster on your workstation with k3d or kind is recommended.

## Install the Radius CLI

{{< read file="/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## Install Radius

Create a new directory for the Todo List application:

```bash
mkdir todolist
cd todolist
```

Ensure your cluster is set as your current context using `kubectl config current-context`. If the context needs updating, change it using `kubectl config set-context <context-name>`. Then install Radius using the `rad initialize` command:

```bash
rad initialize --preview
```

Select `Yes` to set up an application in the current directory.

Example output:

```
Initializing Radius...

✅ Install Radius {{< param version >}}
    - Kubernetes cluster: k3d-k3s-default
    - Kubernetes namespace: radius-system
✅ Create new environment default
    - Kubernetes namespace: default
    - Recipe pack: default
✅ Scaffold application todolist
✅ Update local configuration

Initialization complete! Have a RAD time 😎
```

## Deploy the Todo List application

In addition to installing Radius, the `rad initialize` command creates a sample application definition, `app.bicep`:

```
extension radius

@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string

resource todolist 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'todolist'
  properties: {
    environment: environment
  }
}

resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    environment: environment
    application: todolist.id
    containers: {
      web: {
        image: 'ghcr.io/radius-project/samples/demo:latest'
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
    }
  }
}
```

Use the `rad deploy` command to deploy the application to your Radius environment.

```bash
rad deploy app.bicep
```

The `rad deploy` command deploys the Todo List sample application to the `default` Radius Environment which is configured to use the `default` namespace of your Kubernetes cluster. The `Radius.Compute/containers` resource in the application definition is provisioned using a Recipe which creates a Kubernetes Deployment and a `ClusterIP` Service.

You can view the deployed resources using `kubectl`:

```bash
kubectl get deployment,service
```

Example output:

```
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/frontend   1/1     1            1           6m55s

NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/frontend-web   ClusterIP   10.96.166.208   <none>        3000/TCP   6m55s
```

## Browse the Todo List application UI

In order to access the Todo List application, use `kubectl` to forward a local port to the container's Kubernetes Service.

```bash
kubectl port-forward svc/frontend-web 3000:3000
```

Browse to the Todo List application by opening [http://localhost:3000](http://localhost:3000) in your browser. Notice that the Radius Connections section says "No connections defined." In the five-part tutorial, you will add a database and a connection between the container and the database.

Back in your terminal, press `Ctrl+C` to exit the port forwarding.

## Browse the Radius Dashboard

Start port forwarding for the Radius Dashboard:

```bash
kubectl port-forward svc/dashboard 7007:80 -n radius-system
```

Open [http://localhost:7007](http://localhost:7007) in your browser. Find the Todo List application under the Applications tab and examine its resources. Press `Ctrl+C` to exit the port forwarding in your terminal when you are done.


## View the Application Graph

The `rad application graph` command shows you all the resources that the application is composed of.

```bash
rad application graph todolist --preview
```

You should see the following output, which lists the underlying Kubernetes resources running the application.

```
Displaying application: todolist

Name: frontend (Radius.Compute/containers)
Connections: (none)
Resources:
  frontend (apps/Deployment)
  frontend-web (core/Service)
```

Congratulations, you have deployed your first application using Radius!


## Cleanup

Stop any remaining port forwards by pressing `Ctrl+C` (or close the terminal windows). 

Delete the Todo List application:

```bash
rad application delete todolist --preview
```

Optionally, uninstall Radius using the `purge` argument to remove Radius and all data:

```bash
rad uninstall kubernetes --purge
```

<br><br>
{{< button text="Next step: Read Radius concepts" page="concepts" >}}

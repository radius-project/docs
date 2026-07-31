---
type: docs
title: "2. Deploy an application"
linkTitle: "2. Deploy an application"
description: "Deploy the Todo List sample application to your Radius Environment"
weight: 200
---

In the previous step, `rad initialize` created a sample application definition, `app.bicep`, in your `todolist` directory:

```bicep
extension radius

@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string

@description('The Radius Application ID. Injected automatically by the rad CLI.')
param application string

resource demo 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'demo'
  properties: {
    environment: environment
    application: application
    containers: {
      demo: {
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

Deploy the application with `rad deploy`:

```bash
rad deploy app.bicep --application todolist
```

Radius deploys the application to the `default` Environment, which is configured to use the `default` namespace of your Kubernetes cluster. The `Radius.Compute/containers` resource is provisioned by a Recipe that creates a Kubernetes Deployment and a `ClusterIP` Service.

View the deployed resources with `kubectl`:

```bash
kubectl get deployment,service
```

Example output:

```
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/demo   1/1     1            1           3m18s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/demo-demo    ClusterIP   10.96.177.228   <none>        3000/TCP   3m18s
```

## Browse the Todo List application

Use `kubectl` to forward a local port to the container's Kubernetes Service:

```bash
kubectl port-forward svc/demo-demo 3000:3000
```

Open [http://localhost:3000](http://localhost:3000) in your browser. The Radius Connections section says "No connections defined"; you will add a database connection in the next step. Press `Ctrl+C` to stop the port forward.

## Browse the Radius Dashboard

Start port forwarding for the Radius Dashboard:

```bash
kubectl port-forward svc/dashboard 7007:80 -n radius-system
```

Open [http://localhost:7007](http://localhost:7007). Find the Todo List application under the Applications tab and examine its resources. Press `Ctrl+C` when you are done.

## View the application graph

The `rad application graph` command lists the resources the application is composed of:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application graph todolist --preview
```

You should see output listing the underlying Kubernetes resources:

```
Displaying application: todolist

Name: demo (Radius.Compute/containers)
Connections: (none)
Resources:
  demo (apps/Deployment)
  demo-demo (core/Service)
```

You have deployed your first application with Radius. For a deeper walkthrough of authoring and deploying application definitions, see [How to deploy applications using Radius]({{< ref "/applications/deploy" >}}).

## Next steps

In part three of this guide, you will add a database resource and a connection to the `demo` container.

{{< button text="Next step: Add a connection" page="getting-started/add-connection" >}}

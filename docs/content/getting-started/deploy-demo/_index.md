---
type: docs
title: "2. Deploy an application"
linkTitle: "2. Deploy an application"
description: "Deploy the Radius Demo sample application to your Radius Environment"
weight: 200
aliases:
  - /getting-started/deploy-todolist/
---

The Radius Demo is a small containerized application. Its definition, `app.bicep`, declares a Radius Application and a container that runs the demo image:

<div class="td-max-width-on-larger-screens" style="margin-bottom: -2rem;"><a href="https://github.com/radius-project/samples/blob/{{< param version >}}/samples/demo/app.bicep" target="_blank" rel="noopener">samples/demo/app.bicep</a></div>

{{< rad file="/static/samples/demo/app.bicep" embed=true >}}

The Application and container are named `demo-${environmentName}`. The Environment name is included so the resource names are unique across the Resource Group when you deploy to more than one Environment (for example dev, test, and prod).

Deploy the Radius Demo using `rad deploy`:

{{< rad-deploy path="samples/demo/app.bicep" >}}

Radius deploys the application to the `default` Environment. The `Radius.Compute/containers` resource is provisioned by a Recipe that creates a Kubernetes Deployment and a `ClusterIP` Service. Find the actual runtime namespace rather than assuming it matches the Environment's configured namespace:

```bash
kubectl get deployment --all-namespaces \
  -l radapp.io/application=demo-default,radapp.io/resource=demo-default
```

Set `DEMO_NAMESPACE` to the namespace shown for this tutorial's deployment. If more than one deployment matches, identify the one in your tutorial Environment before continuing:

```bash
DEMO_NAMESPACE='<runtime-namespace>'
kubectl rollout status deployment/demo-default -n "$DEMO_NAMESPACE" --timeout=180s
```

View the deployed resources with `kubectl`:

```bash
kubectl get pod,deployment,service -n "$DEMO_NAMESPACE" -l radapp.io/application=demo-default
```

Example output:

```
NAME                               READY   STATUS    RESTARTS   AGE
pod/demo-default-xxxxxxxxxx-xxxxx  1/1     Running   0          3m18s

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/demo-default   1/1     1            1           3m18s

NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/demo-default-web   ClusterIP   10.96.177.228   <none>        3000/TCP   3m18s
```

## Browse the Radius Demo application

Use `kubectl` to forward a local port to the container's Kubernetes Service:

```bash
kubectl port-forward svc/demo-default-web -n "$DEMO_NAMESPACE" 3000:3000
```

Open [http://localhost:3000](http://localhost:3000) in your browser. The Radius Connections section says "No connections defined"; you will add PostgreSQL and password Secret connections in the next step. Press `Ctrl+C` to stop the port forward.

## Browse the Radius Dashboard

Start port forwarding for the Radius Dashboard:

```bash
kubectl port-forward svc/dashboard 7007:80 -n radius-system
```

Open [http://localhost:7007](http://localhost:7007). Find the `demo-default` application under the Applications tab and examine its resources. Press `Ctrl+C` when you are done.

## View the application graph

The `rad application graph` command lists the resources the application is composed of:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application graph demo-default --preview
```

You should see output listing the underlying Kubernetes resources:

```
Displaying application: demo-default

Name: demo-default (Radius.Compute/containers)
Connections: (none)
Resources:
  demo-default (apps/Deployment)
  demo-default-web (core/Service)
```

You have deployed your first application with Radius. For a deeper walkthrough of authoring and deploying application definitions, see [How to deploy applications using Radius]({{< ref "/applications/deploy" >}}).

## Next steps

In part three of this guide, you will add a PostgreSQL database and an authored password Secret, then connect both to the `demo-default` container.

{{< button text="Next step: Add a connection" page="getting-started/add-connection" >}}

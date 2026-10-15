---
type: docs
title: "2. Deploy an application"
linkTitle: "2. Deploy an application"
description: "Deploy the Radius Demo sample application to your Radius Environment"
weight: 200
aliases:
  - /getting-started/deploy-todolist/
---

The Radius Demo is a small containerized application. Continue only after the installation step has selected and verified the explicit tutorial Recipe Pack. Keep using that step's shell, local `RAD_CONFIG`, and Kubernetes context. Its definition, `app.bicep`, declares a Radius Application and a container that runs the demo image:

<div class="td-max-width-on-larger-screens" style="margin-bottom: -2rem;"><a href="https://github.com/radius-project/samples/blob/{{< param version >}}/samples/demo/app.bicep" target="_blank" rel="noopener">samples/demo/app.bicep</a></div>

{{< rad file="/static/samples/demo/app.bicep" embed=true >}}

[Download the base application definition](/samples/demo/app.bicep).

The Application and container are named `demo-${environmentName}`. The Environment name is included so the resource names are unique across the Resource Group when you deploy to more than one Environment (for example dev, test, and prod).

Deploy the Radius Demo using `rad deploy`:

{{< rad-deploy path="samples/demo/app.bicep" args=`--environment tutorial --group default --config "$RAD_CONFIG"` >}}

Radius deploys the application to the `tutorial` Environment, which uses the `radius-tutorial` namespace of your Kubernetes cluster. The `Radius.Compute/containers` resource is provisioned by the explicitly selected Container Recipe, which creates a Kubernetes Deployment and a `ClusterIP` Service.

View the deployed resources with `kubectl`:

```bash
NAMESPACE="$(rad environment show tutorial --group default \
  --config "$RAD_CONFIG" --output json \
  | jq -er '.properties.providers.kubernetes.namespace | select(type == "string" and length > 0)')"
if [[ "$NAMESPACE" != radius-tutorial ]]; then
  printf 'Unexpected tutorial namespace: %s. Stop and check the Environment.\n' "$NAMESPACE" >&2
  exit 1
fi
kubectl get pod,deployment,service -n "$NAMESPACE" --context "$KUBE_CONTEXT"
```

Example output:

```
NAME                               READY   STATUS    RESTARTS   AGE
pod/demo-tutorial-xxxxxxxxxx-xxxxx  1/1     Running   0          3m18s

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/demo-tutorial   1/1     1            1           3m18s

NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/demo-tutorial-web   ClusterIP   10.96.177.228   <none>        3000/TCP   3m18s
```

## Browse the Radius Demo application

Use `kubectl` to forward a local port to the container's Kubernetes Service:

```bash
kubectl port-forward svc/demo-tutorial-web 3000:3000 \
  -n "$NAMESPACE" --context "$KUBE_CONTEXT"
```

Open [http://localhost:3000](http://localhost:3000) in your browser. The Radius Connections section says "No connections defined"; you will add a PostgreSQL database connection in the next step. Press `Ctrl+C` to stop the port forward.

Keep this demo accessible only through the local port forward. Its connection display is a learning tool, not a production interface: after you add a database, it displays connection credentials.

## Browse the Radius Dashboard

Start port forwarding for the Radius Dashboard:

```bash
kubectl port-forward svc/dashboard 7007:80 -n radius-system --context "$KUBE_CONTEXT"
```

Open [http://localhost:7007](http://localhost:7007). Find the `demo-tutorial` application under the Applications tab and examine its resources. Press `Ctrl+C` when you are done.

## View the application graph

The `rad application graph` command lists the resources the application is composed of:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application graph demo-tutorial --environment tutorial --group default \
  --preview --config "$RAD_CONFIG"
```

You should see output listing the underlying Kubernetes resources:

```
Displaying application: demo-tutorial

Name: demo-tutorial (Radius.Compute/containers)
Connections: (none)
Resources:
  demo-tutorial (apps/Deployment)
  demo-tutorial-web (core/Service)
```

You have deployed your first application with Radius. For a deeper walkthrough of authoring and deploying application definitions, see [How to deploy applications using Radius]({{< ref "/applications/deploy" >}}).

## Next steps

In part three of this guide, you will add a PostgreSQL database resource and a connection to the container.

{{< button text="Next step: Add a connection" page="getting-started/add-connection" >}}

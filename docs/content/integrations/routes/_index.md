---
type: docs
title: "How to use the Kubernetes Gateway API with Radius"
linkTitle: "Use the Gateway API with Radius"
description: "Learn how the Routes Resource Type integrates with the Kubernetes Gateway API and third-party gateway controllers"
weight: 200
aliases:
   - /guides/routes/
---

The [Routes]({{< ref "/reference/resources" >}}) Resource Type exposes your application's Containers to external connections. It builds on the [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io/) and works with any conformant gateway controller such as NGINX Gateway Fabric, Envoy Gateway, Istio, or Contour. A Routes resource is analogous to a Kubernetes `HTTPRoute`, `TCPRoute`, `TLSRoute`, or `UDPRoute`.

Radius does not install or manage a gateway. You install a gateway controller and create a gateway in your cluster, then configure the Routes recipe to use that gateway. This guide covers installing a controller, configuring the recipe with your gateway's name, and adding a route to your application.

## How the integration works

A Routes resource declares how external traffic reaches your application, such as which path forwards to which container. When Radius provisions it, the Routes recipe creates the matching Gateway API route (an `HTTPRoute`, for example) and attaches it to a gateway that already exists in your cluster.

Radius relies on two things you set up outside of it:

- **A gateway controller and gateway** running in the cluster.
- **The gateway's name and namespace**, which you pass to the Routes recipe through the `gatewayName` and `gatewayNamespace` parameters on the Recipe Pack or the Environment.

Because the recipe finds the gateway by name, the same application definition works across clusters that run different gateway controllers.

## Step 1: Install a gateway controller

Install the [Gateway API](https://gateway-api.sigs.k8s.io/) CRDs and a conformant controller, then create a gateway for Radius routes to attach to. The following example uses [NGINX Gateway Fabric](https://docs.nginx.com/nginx-gateway-fabric/); any conformant controller works.

Install the Gateway API CRDs and the controller. Use the versions and commands from your controller's installation guide:

```bash
# Install the standard Gateway API CRDs
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml

# Install a gateway controller (NGINX Gateway Fabric shown here)
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric \
  --create-namespace --namespace nginx-gateway
```

Create a `Gateway` that the Routes recipe attaches to. This example defines a gateway named `radius-gateway` in the `nginx-gateway` namespace with an HTTP listener:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: radius-gateway
  namespace: nginx-gateway
spec:
  gatewayClassName: nginx
  listeners:
    - name: http
      protocol: HTTP
      port: 80
      allowedRoutes:
        namespaces:
          from: All
```

Apply it with `kubectl apply -f gateway.yaml`. Refer to your controller's documentation for TLS, load balancer, and DNS configuration.

## Step 2: Point the Routes recipe at your gateway

The Routes recipe attaches routes to the gateway you created. Provide the gateway name and namespace through the `gatewayName` and `gatewayNamespace` recipe parameters. Set them on the Recipe Pack so every Environment that references the pack shares the same gateway, or set them on an Environment to override the value per Environment.

Set the parameters on the Recipe Pack:

```bicep
extension radius

resource computeRecipes 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'compute-recipes'
  properties: {
    recipes: {
      'Radius.Compute/routes': {
        kind: 'bicep'
        source: 'ghcr.io/my-org/recipes/routes:v1.0.0' // Replace with your published Radius.Compute/routes recipe
        parameters: {
          gatewayName: 'radius-gateway'
          gatewayNamespace: 'nginx-gateway'
        }
      }
    }
  }
}
```

Or set them on an Environment with `recipeParameters`, keyed by the Resource Type. A value set on the Environment overrides the value from the Recipe Pack:

```bicep
resource devEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'dev'
  properties: {
    providers: {
      kubernetes: {
        namespace: 'dev'
      }
    }
    recipePacks: [
      computeRecipes.id
    ]
    recipeParameters: {
      'Radius.Compute/routes': {
        gatewayName: 'radius-gateway'
        gatewayNamespace: 'nginx-gateway'
      }
    }
  }
}
```

See [How to manage Recipe Packs]({{< ref "/extensibility/recipe-packs" >}}) and [How to design and manage Environments]({{< ref "/management/environments" >}}) for more on assigning recipes and setting parameters.

## Step 3: Add a route to your application

In your application definition, add a `Radius.Compute/routes` resource that forwards traffic to a Container. Each rule matches incoming requests and forwards them to a Container using its resource ID, container name, and port. The following example exposes the `frontend` Container's `web` port at the root path:

```bicep
extension radius

@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string

resource app 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'my-app'
  properties: {
    environment: environment
  }
}

resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    environment: environment
    application: app.id
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

resource route 'Radius.Compute/routes@2025-08-01-preview' = {
  name: 'frontend-route'
  properties: {
    environment: environment
    application: app.id
    kind: 'HTTP'
    rules: [
      {
        matches: [
          {
            httpPath: '/'
          }
        ]
        destinationContainer: {
          resourceId: frontend.id
          containerName: 'web'
          containerPort: 3000
        }
      }
    ]
  }
}
```

Set `kind` to `HTTP`, `TCP`, `TLS`, or `UDP` to select the kind of route. Use `matches` to route by path, header, method, or query parameter, and add more entries to `rules` to expose several Containers through the same gateway. For HTTP and TLS routes, set `hostnames` to match requests by host. See the [`Radius.Compute/routes` reference]({{< ref "/reference/resources" >}}), or run `rad resource-type show Radius.Compute/routes`, for the full property list.

## Step 4: Deploy and access the application

Deploy the definition with [`rad deploy`]({{< ref rad_deploy >}}):

```bash
rad deploy app.bicep
```

Radius provisions the route, and its recipe creates the matching Gateway API route object attached to your gateway. The route's read-only `listener` property reports the hostname and port the recipe assigned. Inspect it with [`rad resource show`]({{< ref rad_resource_show >}}):

```bash
rad resource show Radius.Compute/routes frontend-route
```

Send traffic to your gateway's external address using the reported hostname to reach the application.

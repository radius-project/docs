---
type: docs
title: "How to use the Kubernetes Gateway API with Radius"
linkTitle: "Use the Gateway API with Radius"
description: "Learn how the Routes Resource Type uses the Kubernetes Gateway API, the built-in Contour gateway, and third-party gateway controllers"
weight: 300
aliases:
   - /guides/routes/
---

The [Routes]({{< ref "/reference/resources" >}}) Resource Type exposes your application's Containers to external connections. It builds on the [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io/) and works with any conformant gateway controller such as Contour, NGINX Gateway Fabric, Envoy Gateway, or Istio. A Routes resource is analogous to a Kubernetes `HTTPRoute`, `TCPRoute`, `TLSRoute`, or `UDPRoute`.

By default, Radius installs [Contour](https://projectcontour.io/) and creates a managed gateway named `radius` in the `radius-system` namespace. The `default` Recipe Pack's Routes recipe is pre-configured to attach routes to this gateway, so routes work out of the box with no gateway setup. If you would rather run a different Gateway API controller, you can disable the built-in Contour installation and point the recipe at your own gateway.

## How the integration works

A Routes resource declares how external traffic reaches your application, such as which path forwards to which Container. When Radius provisions it, the Routes recipe creates the matching Gateway API route object (an `HTTPRoute`, for example) and attaches it to a gateway that already exists in the cluster.

The recipe finds that gateway through two recipe parameters:

- `gatewayName`: the name of the `Gateway` to attach routes to. Defaults to `radius`.
- `gatewayNamespace`: the namespace of that `Gateway`. Defaults to `radius-system`.

These defaults point at the built-in Contour gateway. Because the recipe finds the gateway by name, the same application definition works across clusters that run different gateway controllers: only the recipe parameters change, not the application.

## Use the built-in Contour gateway

When you install Radius with [`rad initialize`]({{< ref rad_initialize >}}) or [`rad install`]({{< ref rad_install_kubernetes >}}), Radius installs Contour and creates the Gateway API infrastructure that the default Routes recipe uses:

- A `GatewayClass` named `contour`.
- A `Gateway` named `radius` in the `radius-system` namespace, with an HTTP listener on port 80 and a TLS passthrough listener on port 443. Both listeners allow routes from all namespaces.

The `default` Recipe Pack sets `gatewayName: radius` and `gatewayNamespace: radius-system` on the `Radius.Compute/routes` recipe, so you can [add a route](#add-a-route-to-your-application) without configuring a gateway.

The built-in gateway serves HTTP on port 80 and TLS passthrough on port 443. TCP routes require a gateway listener on the target port, and Contour's Gateway API does not support UDP. For those cases, or to run a different controller, see [Use a different gateway controller](#use-a-different-gateway-controller).

## Use a different gateway controller

To route through a Gateway API controller other than the built-in Contour, disable the Contour installation, install the controller you want, create a gateway, and point the Routes recipe at it.

### Disable the built-in Contour installation

Contour is installed by default. To skip it, pass `--skip-contour-install` when you install Radius:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad install kubernetes --preview --skip-contour-install
```

With Contour skipped, Radius does not create the managed `radius` gateway, so no gateway exists on the cluster until you create one. The default Routes recipe has nothing to attach to until you complete the next two steps. See [How to install the Radius control plane]({{< ref "/installation/control-plane" >}}) for more installation options.

### Install a gateway controller

Install the [Gateway API](https://gateway-api.sigs.k8s.io/) CRDs and a conformant controller, then create a gateway for Radius routes to attach to. Any conformant controller works; this guide uses [NGINX Gateway Fabric](https://docs.nginx.com/nginx-gateway-fabric/) as an example.

Follow the controller's own documentation to install the Gateway API CRDs and the controller, since the exact versions and commands change between releases. For NGINX Gateway Fabric, see the [installation guide](https://docs.nginx.com/nginx-gateway-fabric/install). Note the namespace you install the controller into, because you reference it when you create the gateway below.

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

### Point the Routes recipe at your gateway

Override the `gatewayName` and `gatewayNamespace` recipe parameters so the Routes recipe attaches to your gateway instead of the built-in `radius` gateway. Set them on the Recipe Pack so every Environment that references the pack shares the same gateway, or set them on an Environment to override the value per Environment.

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

See [How to manage Recipe Packs]({{< ref "/management/recipe-packs" >}}) and [How to design and manage Environments]({{< ref "/management/environments" >}}) for more on assigning recipes and setting parameters.

## Add a route to your application

In your application definition, add a `Radius.Compute/routes` resource that forwards traffic to a Container. Each rule matches incoming requests and forwards them to a Container using its resource ID, container name, and port.

For HTTP and TLS routes, set at least one hostname. The built-in `radius` gateway requires a hostname on HTTP and TLS routes so requests are matched to your application and not to another route on the same listener. The following example exposes the `frontend` Container's `web` port at the root path for the host `frontend.example.com`:

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
    hostnames: [
      'frontend.example.com'
    ]
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

Set `kind` to `HTTP`, `TCP`, `TLS`, or `UDP` to select the kind of route. Use `matches` to route by path, header, method, or query parameter, and add more entries to `rules` to expose several Containers through the same gateway. See the [`Radius.Compute/routes` reference]({{< ref "/reference/resources" >}}), or run `rad resource-type show Radius.Compute/routes`, for the full property list.

## Deploy and access the application

Deploy the definition with [`rad deploy`]({{< ref rad_deploy >}}):

```bash
rad deploy app.bicep
```

Radius provisions the route, and its recipe creates the matching Gateway API route object attached to your gateway. The route's read-only `listener` property reports the hostname and port the recipe assigned. Inspect it with [`rad resource show`]({{< ref rad_resource_show >}}):

```bash
rad resource show Radius.Compute/routes frontend-route
```

Send traffic to your gateway's external address using the reported hostname to reach the application.

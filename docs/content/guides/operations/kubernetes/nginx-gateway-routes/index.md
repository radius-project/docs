---
type: docs
title: "How-To: Use NGINX Gateway Fabric with Radius routes"
linkTitle: "NGINX Gateway"
description: "Install Radius without Contour and use NGINX Gateway Fabric with Radius.Compute/routes"
weight: 260
categories: "How-To"
tags: ["Kubernetes", "Recipes", "Networking"]
---

This guide shows how to install Radius without the default Contour ingress controller, install [NGINX Gateway Fabric](https://docs.nginx.com/nginx-gateway-fabric/), and configure the `Radius.Compute/routes` recipe to attach application routes to an NGINX Gateway API `Gateway`.

Use this pattern when your platform team wants to manage the Kubernetes Gateway controller separately from Radius while still letting application authors use portable Radius route resources.

## Prerequisites

- [Kubernetes cluster]({{< ref "guides/operations/kubernetes/overview#supported-kubernetes-clusters" >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
- [rad CLI]({{< ref howto-rad-cli >}})

The examples use:

- Radius environment name: `default`
- Application namespace: `nginx-radius-demo`
- Gateway name: `radius`
- Route hostname: `nginx.example.com`

## Step 1: Install Radius without Contour

Install Radius and skip the default Contour installation:

```bash
rad install kubernetes --skip-contour-install
```

Create a resource group, workspace, and environment:

```bash
rad group create default
rad workspace create kubernetes default --group default --force
rad group switch default

rad env create default --preview
kubectl create namespace nginx-radius-demo
rad env update default --kubernetes-namespace nginx-radius-demo --preview
```

## Step 2: Install NGINX Gateway Fabric

Install the Gateway API standard channel CRDs:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.5.0/standard-install.yaml
```

The standard channel includes the `GatewayClass`, `Gateway`, and `HTTPRoute` resources used in this guide. Use the experimental channel only if your route recipes need experimental Gateway API resources such as `TLSRoute`, `TCPRoute`, or `UDPRoute`.

Install NGINX Gateway Fabric:

```bash
helm upgrade --install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric \
  --namespace nginx-gateway \
  --create-namespace \
  --wait

kubectl wait --timeout=5m \
  --namespace nginx-gateway \
  deployment/ngf-nginx-gateway-fabric \
  --for=condition=Available
```

Create a Gateway API `Gateway` for Radius routes:

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: radius
  namespace: nginx-radius-demo
spec:
  gatewayClassName: nginx
  listeners:
    - name: http
      protocol: HTTP
      port: 80
      allowedRoutes:
        namespaces:
          from: All
EOF

kubectl wait --timeout=5m \
  --namespace nginx-radius-demo \
  gateway/radius \
  --for=condition=Programmed
```

## Step 3: Configure Bicep extensions

Create `bicepconfig.json`:

```json
{
  "experimentalFeaturesEnabled": {
    "extensibility": true
  },
  "extensions": {
    "radius": "br:biceptypes.azurecr.io/radius:latest",
    "radiusCompute": "br:biceptypes.azurecr.io/radiuscompute:latest"
  }
}
```

## Step 4: Register a routes recipe pack

Create `nginx-routes-recipe-pack.bicep`:

```bicep
extension radius

param recipeTag string = 'latest'

resource recipePack 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'nginx-gateway'
  location: 'global'
  properties: {
    recipes: {
      'Radius.Compute/containers': {
        recipeKind: 'bicep'
        recipeLocation: 'ghcr.io/radius-project/kube-recipes/containers:${recipeTag}'
      }
      'Radius.Compute/routes': {
        recipeKind: 'bicep'
        recipeLocation: 'ghcr.io/radius-project/kube-recipes/routes:${recipeTag}'
        parameters: {
          gatewayName: 'radius'
          gatewayNamespace: 'nginx-radius-demo'
        }
      }
    }
  }
}
```

Deploy the recipe pack and attach it to the environment:

```bash
ENVIRONMENT_ID="/planes/radius/local/resourcegroups/default/providers/Radius.Core/environments/default"

rad deploy nginx-routes-recipe-pack.bicep \
  --group default \
  --environment "$ENVIRONMENT_ID"

rad env update default --recipe-packs nginx-gateway --preview
```

The `gatewayName` and `gatewayNamespace` parameters tell the `Radius.Compute/routes` recipe which Kubernetes Gateway should receive generated `HTTPRoute` resources.

## Step 5: Deploy an application with a route

Create `app.bicep`:

```bicep
extension radius
extension radiusCompute

param environment string
param routeHostname string = 'nginx.example.com'

resource app 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'nginx-radius-demo'
  properties: {
    environment: environment
  }
}

resource web 'radiusCompute:Radius.Compute/containers@2025-08-01-preview' = {
  name: 'web'
  properties: {
    environment: environment
    application: app.id
    containers: {
      web: {
        image: 'nginx:alpine'
        ports: {
          http: {
            containerPort: 80
            protocol: 'TCP'
          }
        }
      }
    }
  }
}

resource route 'radiusCompute:Radius.Compute/routes@2025-08-01-preview' = {
  name: 'web'
  properties: {
    environment: environment
    application: app.id
    kind: 'HTTP'
    hostnames: [
      routeHostname
    ]
    rules: [
      {
        matches: [
          {
            httpPath: '/'
          }
        ]
        destinationContainer: any({
          resourceId: web.id
          containerName: 'web'
          containerPort: web.properties.containers.web.ports.http.containerPort
        })
      }
    ]
  }
}
```

Deploy the application:

```bash
rad deploy app.bicep \
  --application nginx-radius-demo \
  --environment "$ENVIRONMENT_ID" \
  --parameters routeHostname=nginx.example.com
```

Radius deploys the container through the `Radius.Compute/containers` recipe and creates a Kubernetes `HTTPRoute` through the `Radius.Compute/routes` recipe.

## Step 6: Verify traffic

Check that the Gateway and route are accepted:

```bash
kubectl get gateway radius --namespace nginx-radius-demo
kubectl get httproute --namespace nginx-radius-demo
```

For local clusters, port-forward the NGINX Gateway service:

```bash
SERVICE_NAME="$(kubectl get service \
  --namespace nginx-radius-demo \
  --selector gateway.networking.k8s.io/gateway-name=radius \
  --output jsonpath='{.items[0].metadata.name}')"

kubectl port-forward \
  --namespace nginx-radius-demo \
  "service/${SERVICE_NAME}" \
  8080:80
```

In another terminal, send a request with the route hostname:

```bash
curl -H "Host: nginx.example.com" http://127.0.0.1:8080/
```

You should see the default NGINX welcome page.

## Clean up

Delete the application:

```bash
rad app delete nginx-radius-demo --yes
```

If you no longer need the NGINX recipe pack, first update the environment to use another recipe pack or delete the environment that references it. Then delete the recipe pack:

```bash
rad recipe-pack delete nginx-gateway --group default --yes
```

Uninstall NGINX Gateway Fabric:

```bash
helm uninstall ngf --namespace nginx-gateway
kubectl delete namespace nginx-gateway
```

## Further reading

- [Radius Recipes]({{< ref "/guides/recipes" >}})
- [Kubernetes platform]({{< ref "/guides/operations/kubernetes/overview" >}})
- [Application networking]({{< ref "/guides/author-apps/networking/overview" >}})

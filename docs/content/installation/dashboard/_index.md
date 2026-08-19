---
type: docs
title: "How to configure access to the Radius dashboard"
linkTitle: "Access the Dashboard"
description: "Accessing the Radius dashboard"
weight: 400
aliases:
  - /guides/installation/dashboard/
---

How you access the Dashboard depends on how Radius is installed. For local development on a k3d or kind cluster, port-forwarding is the simplest option. For centralized installations on a shared cluster such as AKS or EKS, a platform engineer typically configures ingress so that users can reach the Dashboard without port-forwarding.

## Port-forwarding

Create a port-forward from `localhost` to a port of your choice to access the Radius Dashboard, then visit [http://localhost:7007](http://localhost:7007) in a browser:

```bash
kubectl port-forward --namespace=radius-system svc/dashboard 7007:80
```

Port-forwarding works well on a local cluster like k3d or kind, where the cluster runs on your own machine and only you need access to the Dashboard.

## Ingress

For a centralized Radius installation on a shared cluster such as AKS or EKS, port-forwarding requires every user to have `kubectl` access to the `radius-system` namespace. Instead, a platform engineer can expose the Dashboard through the cluster's ingress controller so that users can reach it over a stable URL.

The Dashboard is served by the `dashboard` service in the `radius-system` namespace on port `80`. Configure an ingress resource that routes to this service using whichever ingress controller your cluster uses (for example, NGINX, AKS Application Gateway, or AWS Load Balancer Controller). The following example uses the NGINX ingress controller:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dashboard
  namespace: radius-system
spec:
  ingressClassName: nginx
  rules:
    - host: dashboard.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: dashboard
                port:
                  number: 80
```

Update the `host`, `ingressClassName`, and any annotations to match your cluster and ingress controller. Because the Dashboard does not provide its own authentication, secure access to it—for example with TLS and an authentication proxy—before exposing it outside the cluster.

## Next steps

With the Dashboard configured, set up developer workstations so your team can build and deploy applications.

{{< button text="Next step: How to set up developer workstations" page="installation/dev-workstation" >}}

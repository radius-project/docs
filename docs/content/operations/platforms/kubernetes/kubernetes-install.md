---
type: docs
title: "Install Radius on Kubernetes"
linkTitle: "Installation"
description: "Learn how to setup Radius on supported Kubernetes clusters"
weight: 200
categories: "How-To"
tags: ["Kubernetes"]
slug: 'install'
---

The [Radius control plane]({{< ref architecture >}}) handles the deployment and management of Radius environments, applications, and resources.

## Install with the rad CLI

Use the [`rad install kubernetes` command]({{< ref rad_install_kubernetes >}}) to install the Radius control plane into the `radius-system` namespace on your Kubernetes cluster. You can optionally use the `--set` flag to customize the installation with [Helm configuration options](#helm-configuration-options):

```bash
# Install the Radius control plane
rad install kubernetes

# Install the Radius control plane with tracing and public endpoint override
rad install kubernetes --set global.zipkin.url=http://jaeger-collector.radius-monitoring.svc.cluster.local:9411/api/v2/spans,rp.publicEndpointOverride=localhost:8081`
```

## Install with Helm

1. Begin by adding the Radius Helm repository:
   ```bash
   helm repo add radius https://radius.azurecr.io/helm/v1/repo
   helm repo update
   ```
1. Get all available versions:
   ```bash
   helm search repo radius --versions
   ```
1. Install the specified chart:
   ```bash
   helm upgrade radius radius/radius --install --create-namespace --namespace radius-system --version {{< param chart_version >}} --wait --timeout 15m0s
   ```

### Helm configuration options

| Name | Default | Description |
|------|---------|-------------|
| `global.zipkin.url` | | Zipkin collector URL. If not specified, tracing is disabled.
| `global.prometheus.enabled` | `true` | Enables Prometheus metrics. Defaults to `true`
| `global.prometheus.path` | `"/metrics"` | Metrics endpoint
| `global.prometheus.port` | `9090` | Metrics port
| `rp.image` | `radius.azurecr.io/appcore-rp` | Location of the Radius resource provider (RP) image
| `rp.tag` | `latest` | Tag of the Radius resource provider (RP) image
|`rp.publicEndpointOverride` | `""` | Public endpoint of the Kubernetes cluster. Overrides the default behavior of automatically detecting the public endpoint.
| `de.image` | `radius.azurecr.io/deployment-engine` | Location of the Bicep deployment engine (DE) image
| `de.tag` | `latest` | Tag of the Bicep deployment engine (DE) image
| `ucp.image` | `radius.azurecr.io/ucpd` | Location of universal control plane (UCP) image
| `ucp.tag` | `latest` | Tag of the universal control plane (UCP) image

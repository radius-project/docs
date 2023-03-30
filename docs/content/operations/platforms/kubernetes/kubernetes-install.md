---
type: docs
title: "Install Radius on Kubernetes"
linkTitle: "Installation"
description: "Learn how to setup Radius on supported Kubernetes clusters"
weight: 200
---

The [Radius control plane]({{< ref architecture >}}) handles the deployment and management of Radius environments, applications, and resources.

## Install with the rad CLI

Use the [`rad install kubernetes` command]({{< ref rad_install_Kubernetes >}}) to install Radius control plane on the kubernetes cluster.
```bash
rad install kubernetes
```
`rad install kubernetes set` can be used to configure options on the command line to be passed to the Radius Helm chart and the Kubernetes cluster upon install. You can specify multiple values in a comma-separated list, for example: key1=val1,key2=val2.

For example,
`rad install kubernetes --set global.zipkin.url=http://jaeger-collector.radius-monitoring.svc.cluster.local:9411/api/v2/spans,rp.publicEndpointOverride=localhost:8081`

Options for set command:

| Name                       | Default                       |  Description                                                                   |
| ---------------------------| ------------------------------|--------------------------------------------------------------------------------|
| `global.zipkin.url`        |  None                         | set this variable to valid zipkin collector url to turn on distributed tracing |
| `global.prometheus.enabled`|  true                         | set this variable to false to turn off metrics                                 |
| `global.prometheus.path`   |  "/metrics"                   | set this variable to meter endpoint                                             |
| `global.prometheus.port`   |  9090                         | set this variable to meter port                                                 |
| `rp.image`          |  radius.azurecr.io/appcore-rp | set this variable to location of radius rp image                                |
| `rp.tag`            |  radius.azurecr.io/appcore-rp | set this variable to tag of radius rp image                                      |  
|`rp.publicEndpointOverride` | ""      |set this variable to the public endpoint of the Kubernetes cluster |
| `de.image`                 |  radius.azurecr.io/appcore-rp | set this variable to tag of radius rp image                                      |  
| `de.tag`                   |  radius.azurecr.io/appcore-rp | set this variable to tag of radius rp image                                      |  
| `ucp.image`                |  radius.azurecr.io/appcore-rp | set this variable to tag of radius rp image                                      |  
| `ucp.tag`                  |  radius.azurecr.io/appcore-rp | set this variable to tag of radius rp image                                      | 



{{% alert title="💡 About namespaces" color="success" %}}
When Radius initializes a Kubernetes environment, it will deploy the system resources into the `radius-system` namespace. These aren't part your application. The namespace specified in interactive mode will be used for future deployments by default.
{{% /alert %}}

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

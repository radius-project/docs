---
type: docs
title: "How to install the Radius control plane"
linkTitle: "Radius control plane"
description: "Learn how to install, customize, upgrade, and uninstall the Radius control plane on Kubernetes"
weight: 200
aliases:
  - /guides/installation/control-plane/
  - /guides/installation/install/
---

There are three ways to install the Radius control plane. They install the same components on the Kubernetes cluster; they differ in how much of the surrounding setup they automate and how much control they give you over the installation.

- **`rad install`** performs the base installation and is oriented toward platform engineers who are setting up a centralized Radius control plane for developers to connect to. `rad install` accepts `--set` flags to override individual Helm chart values (listed below).
- **`rad initialize`** does everything `rad install` does plus configures the local workstation with a Workspace and Bicep configuration file. It is oriented toward local development, where you install Radius and build an application on the same machine.
- **`helm upgrade radius`** installs only the control plane. It does not create Resource Types, Resource Groups, or Environments.

The following table summarizes the differences:

| | `rad initialize` | `rad install` | `helm upgrade radius` |
| --- | --- | --- | --- |
| Installs the control plane | Yes | Yes | Yes |
| Creates common Resource Types | Yes | Yes | No |
| Creates a `default` Resource Group | Yes | Yes | No |
| Creates a `default` Environment | Yes | Yes | No |
| Configures a `default` Workspace | Yes | No | No |
| Creates a `bicepconfig.json` | Yes | No | No |
| Optionally creates a sample `app.bicep` | Yes | No | No |
| Customization | Defaults only | `--set` chart values | Full chart values, version, release name |
| Requires the Radius CLI | Yes | Yes | No |

Each method is described in detail below.

## Using `rad initialize`

[`rad initialize`]({{< ref rad_initialize >}}) is the fastest way to get started. It installs the control plane on the current Kubernetes cluster and configures the local machine in one step:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad initialize --preview
```

### Customizing with `rad initialize --full`

By default, `rad initialize` uses opinionated defaults: it installs into the current Kubernetes context, creates an Environment named `default` that deploys applications into the `default` namespace, and does not configure any cloud providers.

To choose these settings yourself, run `rad initialize` with the `--full` flag:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad initialize --full --preview
```

In full mode, `rad initialize` interactively prompts you for all available configuration options, including:

- The Kubernetes cluster to install onto
- The Environment name
- The namespace that applications are deployed into
- Azure and AWS [cloud providers]({{< ref "/installation/cloud-providers" >}}) and their credentials

Use `--full` when the defaults do not match your setup, for example when you want a non-default Environment or namespace, or when you need to configure cloud providers during initialization.

## Using `rad install`

Use [`rad install kubernetes`]({{< ref rad_install_kubernetes >}}) to install the control plane. It installs the control plane, creates the default Resource Types, and creates a `default` Resource Group and Environment, but it does not create any local files. Optionally use the `--set` flag to customize the installation with [Helm chart options](#customizing-the-installation-with-helm-chart-options):

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
# Install Radius
rad install kubernetes --preview

# Install Radius with tracing and a public endpoint override
rad install kubernetes --preview --set global.zipkin.url=http://jaeger-collector.radius-monitoring.svc.cluster.local:9411/api/v2/spans,rp.publicEndpointOverride=localhost:8081
```

### Use your own root certificate authority certificate

Many enterprises leverage intermediate root certificate authorities (CAs) to enhance security and control over outgoing traffic, particularly when using a firewall or proxy. In this setup, when Radius attempts to connect to an external endpoint such as Azure or AWS, traffic may be blocked by the firewall. Optionally use `--set-file` when installing Radius to inject your root CA certificate into Radius:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad install kubernetes --preview --set-file global.rootCA.cert=/etc/ssl/your-root-ca.crt
```

## Using Helm

For full control over the installation, install Radius directly with Helm. The Radius chart is published as an [OCI artifact](https://helm.sh/docs/topics/registries/) to GitHub Container Registry (GHCR), so there is no Helm repository to add.

Install the chart directly from its OCI registry:

```bash
helm upgrade radius oci://ghcr.io/radius-project/helm-chart --install --create-namespace --namespace radius-system --version {{< param chart_version >}} --wait --timeout 15m0s
```

To install a different version, change the `--version` flag. Inspect the chart before installing with:

```bash
helm show chart oci://ghcr.io/radius-project/helm-chart --version {{< param chart_version >}}
```

## Customizing the installation with Helm chart options

Whether you install with `rad install kubernetes --set` or with Helm directly, the following chart options are available:

| Name | Default | Description |
| --- | --- | --- |
| `global.zipkin.url` | | Zipkin collector URL. If not specified, tracing is disabled. |
| `global.prometheus.enabled` | `true` | Enables Prometheus metrics. Defaults to `true`. |
| `global.prometheus.path` | `"/metrics"` | Metrics endpoint. |
| `global.prometheus.port` | `9090` | Metrics port. |
| `global.rootCA.cert` | | Root CA certificate injected into Radius containers. Use `--set-file global.rootCA.cert=[cert file]`. |
| `rp.image` | `ghcr.io/radius-project/applications-rp` | Location of the Radius resource provider (RP) image. |
| `rp.tag` | `latest` | Tag of the Radius resource provider (RP) image. |
| `rp.publicEndpointOverride` | `""` | Public endpoint of the Kubernetes cluster. Overrides automatic public endpoint detection. |
| `de.image` | `ghcr.io/radius-project/deployment-engine` | Location of the Bicep deployment engine (DE) image. |
| `de.tag` | `latest` | Tag of the Bicep deployment engine (DE) image. |
| `ucp.image` | `ghcr.io/radius-project/ucpd` | Location of the universal control plane (UCP) image. |
| `ucp.tag` | `latest` | Tag of the universal control plane (UCP) image. |

## Next steps

Once the Radius control plane has been installed, Radius can be used to deploy applications to the Kubernetes cluster. In order to deploy resources to AWS or Azure, configure cloud providers.

{{< button text="Next step: How to configure cloud provider credentials" page="installation/cloud-providers" >}}

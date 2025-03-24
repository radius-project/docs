---
type: docs
title: "Radius + Flux"
linkTitle: "Radius + Flux"
description: "Learn about how Radius is integrated with Flux"
weight: 100
tags: ["flux", "gitops", "continuous", "delivery", "deployment"]
---

This guide provides an overview of how to integrate Radius with [Flux](https://fluxcd.io/), a popular GitOps tool. It covers the installation and configuration of Flux, as well as how to deploy your Radius applications using Flux. For a guided tutorial, check out the  [Radius + Flux Tutorial]({{< ref "tutorials/gitops-flux" >}}).

## Overview

With Radius, deployment and management of applications defined in Bicep files can be done using GitOps tools like Flux. This allows for a declarative approach to managing your applications, ensuring that the desired state of your applications is always maintained in your Git repository.

Your Git repository should contain the following:
- Bicep files defining your Radius applications and cloud infrastructure.
- `radius-config.yaml` file that specifies which Bicep files to deploy and how to configure them.
- Any other configuration files required for your applications (such as `.bicepparam` or `bicepconfig.json` files).

Here is an example showing all of the options for the `radius-config.yaml` file:
```yaml
config:
  - name: app.bicep         # name of the Bicep file to deploy
    params: app.bicepparam  # name of the Bicep parameter file
    resourceGroup: default  # name of the Radius resource group to deploy to (will be created if it doesn't exist)
    namespace: default      # name of the Kubernetes namespace
  - name: app2.bicep        # if multiple Bicep files are needed, add them here
                            # the other fields are optional
```

## Flux Installation

For this integration, you will need to install the Flux CLI and the Flux source controller in your Kubernetes cluster.

### Install the Flux CLI

1. Follow the [Flux CLI installation instructions](https://fluxcd.io/docs/installation/#install-the-flux-cli) to install the Flux CLI on your local machine.

1. Verify the installation by running:

   ```bash
   flux version
   ```

### Install the Flux Source Controller

The only required component for this integration is the Flux source controller. This component is responsible for managing the Git repository and syncing it with your Kubernetes cluster.

1. Install Flux in your Kubernetes cluster:

   ```bash
   flux install --namespace=flux-system --version=latest --components=source-controller --network-policy=false
   ```

   {{< alert title="⚠️ Network Policy" color="warning" >}}
   The `--network-policy=false` flag is specified here to disable the network policy for the Flux source controller, since by default access to Flux components is restricted. For a production setup, you can instead remove this flag and configure the network policy to allow `radius-system` namespace access to the source controller. This will ensure that the source controller can communicate with your Git repository and sync changes effectively.
   For more information on the network policy, see the [Flux documentation](https://fluxcd.io/flux/installation/configuration/optional-components/#network-policies).
   {{< /alert >}}

### Troubleshooting

Behind the scenes, Radius will create a custom resource called `DeploymentTemplate` to represent your Bicep deployment. You can check the status of this resource to see if there are any issues with the deployment:

```bash
❯ kubectl get deploymenttemplates -A
NAMESPACE   NAME        STATUS
app         app.bicep   Ready
❯ kubectl describe deploymenttemplate app.bicep -n app
...
```

You can also check the logs of the `radius-controller` pod to see if there are any errors:
```
❯ kubectl logs -n radius-system -l app.kubernetes.io/name=controller -l app.kubernetes.io/part-of=radius
```

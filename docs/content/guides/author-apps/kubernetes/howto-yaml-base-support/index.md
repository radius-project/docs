---
type: docs
title: "How-To: Apply property overrides on Kubernetes resources using Radius"
linkTitle: "Override properties using base YAML"
description: "Learn how to apply property overrides on Kubernetes resources using Radius and existing Kubernetes YAML manifests."
weight: 500
categories: "How-To"
tags: ["containers","Kubernetes"]
---

This guide will provide an overview of how to: 

- Use Radius to apply property overrides on top of a given Kubernetes resource using its base [Kubernetes YAML](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#writing-a-deployment-spec) manifest.
- Migrate your existing Kubernetes resource to Radius using its base [Kubernetes YAML](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#writing-a-deployment-spec) manifest.

## Prerequisites

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [rad CLI]({{< ref getting-started >}})
- [Radius initialized with `rad init`]({{< ref howto-environment >}})

## Step 1: Define a base Kubernetes YAML file

Begin by creating a file named `manifest.yaml` which defines a Kubernetes application named `base-yaml-app` that includes a Deployment with a single container named `log-collector`:

{{< rad file="snippets/manifest.yaml" embed=true lang="yaml">}}

## Step 2: Define a Radius application

Create another file named `app.bicep` which defines a Radius application named `base-yaml-app` along with a container named `base-yaml-app`. Additionally, include a `runtimes` property that references the `manifest.yaml` file as the base Kubernetes YAML manifest on top of which Radius will apply the properties defined in `app.bicep`.

{{< rad file="snippets/app.bicep" embed=true >}}

> **Note**: the names of the Kubernetes Deployment and the Radius container match each other. For more information on namespace and resource name matching, refer to the [containers overview guide]({{< ref "guides/author-apps/containers/overview#base-kubernetes-yaml" >}}).

## Step 3: Deploy the application and containers

Ensure that your `manifest.yaml` and `app.bicep` files are in the same directory, then deploy your application:

```bash
rad deploy app.bicep
```

> **Note**: in the deployment, Radius will override any parameters in the base Kubernetes YAML manifest (i.e. `manifest.yaml` file) with any values specified in the Radius application definition (i.e. `app.bicep` file) for the same parameters.

Once the deployment completes successfully, you should see the following confirmation message:

```
Deployment In Progress... 

Completed            base-yaml-app   Applications.Core/applications
...                  base-yaml-app   Applications.Core/containers

Deployment Complete

Resources:
    base-yaml-app   Applications.Core/applications
    base-yaml-app   Applications.Core/containers
```

## Step 4: Verify the deployment

Run the command below, which uses `grep` to filter for information to verify that both `log-collector` (which was defined in your base Kubernetes YAML manifest) and `base-yaml-app` (which was defined in your Radius application) containers were deployed successfully:

```bash
kubectl describe pods -n base-yaml-app | grep -A6 -E 'log-collector:|base-yaml-app:'
```

Your console output should look similar to:

```
log-collector:
    Container ID:   containerd://86b06b000889d3d35a10d0996aee89989f9edbad2ad00a29a29eb647b49c4bf2
    Image:          ghcr.io/radius-project/fluent-bit:2.1.8
    Image ID:       ghcr.io/radius-project/fluent-bit@sha256:1c8bdb90eb65902a65b7cd32126a621690dc36128fef78951775afbe37dfa01f
    Port:           <none>
    Host Port:      <none>
    State:          Running
--
  base-yaml-app:
    Container ID:   containerd://fb5eebe5e0ad45569235c6d6e5fc14f56e2738e213725fa3bf3078587ef8e7aa
    Image:          ghcr.io/radius-project/magpiego:latest
    Image ID:       ghcr.io/radius-project/magpiego@sha256:cb980dd7acde3edb7173a0f82c3cbcb0addfadd16daef80d8589fa2e067faf3c
    Port:           3000/TCP
    Host Port:      0/TCP
    State:          Running
```

## Clean up

Run the following command to [delete]({{< ref "guides/deploy-apps/howto-delete" >}}) your app and containers:

```bash
rad app delete base-yaml-app
```

## Further reading

- [Kubernetes in Radius containers]({{< ref "guides/author-apps/containers/overview#kubernetes" >}})
- [PodSpec in Radius containers]({{< ref "reference/resource-schema/core-schema/container-schema#runtimes" >}})
- [Container resource schema]({{< ref "container-schema#runtimes" >}})
---
type: docs
title: "How-To: Define Kubernetes resources in Radius"
linkTitle: "Define Kubernetes resources in Radius"
description: "Learn how to define Kubernetes resources in Radius Applications"
weight: 200
categories: "How-To"
tags: ["Kubernetes"]
---

This how-to guide will provide an overview of how to:

- Use Radius-created Kubernetes resources in Radius Applications.

## Prerequisites

- [rad CLI]({{< ref getting-started >}})
- [Radius initialized with `rad init`]({{< ref howto-environment >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Step 1: Define a container

Begin by creating a file named `app.bicep` with a Radius [container]({{< ref "guides/author-apps/containers" >}}):

{{< rad file="snippets/app.bicep" embed=true marker="//CONTAINER">}}

## Step 2: Define your Kubernetes resource

Radius supports creating Bicep definitions of your Kubernetes resources, each with slighlty different schemas which can be found in the [resource references]({{< ref resource-schema >}}).

### Resource provisioning

Kubernetes resources can be defined in 2 main ways in Radius:

{{< tabs "Recipes" "Manual" >}}

{{% codetab %}}

Recipes automate infrastructure provisioning using approved templates. When no Recipe configuration is set, Radius will use the currently registered Recipe as the default in the environment for the given resource. Otherwise, a Recipe name and parameters can optionally be set to override this default.

{{% /codetab %}}

{{% codetab %}}

If you want to manually manage your infrastructure provisioning without the use of Recipes, you can set resourceProvisioning to 'manual' and provide all necessary parameters and values that enable Radius to deploy or connect to the desired infrastructure.

{{% /codetab %}}

{{< /tabs >}}

## Step 3: Deploy your app with the Kubernetes resource added

1. Deploy and run your app:

   ```bash
   rad run ./app.bicep -a demo
   ```


## Cleanup

Run the following command to [delete]({{< ref "guides/deploy-apps/howto-delete" >}}) your app and container:
   
   ```bash
   rad app delete demo
   ```

## Further reading

- [Kubernetes in Radius containers]({{< ref "guides/author-apps/containers/overview#kubernetes" >}})
- [PodSpec configurations in Radius ]({{< ref "guides/author-apps/kubernetes/how-to-patch-pod" >}})

---
type: docs
title: "How-To: Use a Kubernetes resources in your application"
linkTitle: "Add Kubernetes resources"
description: "Learn how to use a Kubernetes resources in your application"
weight: 200
categories: "How-To"
tags: ["Kubernetes"]
---

This how-to guide will provide an overview of how to:

- Leverage Kubernetes resources in your Radius Application directly.

## Prerequisites

- [rad CLI]({{< ref getting-started >}})
- [Radius initialized with `rad init`]({{< ref howto-environment >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Step 1: Define the Kubernetes provider

Begin by creating a new file named `app.bicep`. At the top of your file, import the `kubernetes` provider and add its configuration. This allows you to define and deploy Kubernetes resources within Bicep.
- The `namespace` property determines where to deploy Kubernetes resources by default.
- The `kubeConfig` property is not currently used and can remain as an empty string (`''`):

{{< rad file="snippets/app-kubernetes.bicep" embed=true marker="//KUBERNETES" >}}

## Step 2:  Add a Kubernetes secret resource

Add a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/) to your `app.bicep` file. This secret will contain a small amount of sensitive data such as a password, a token, or a key:

{{< rad file="snippets/app-kubernetes.bicep" embed=true marker="//SECRET" >}}

> Refer to the [Kubernetes overview page]({{< ref "/guides/author-apps/kubernetes/overview#resource-library" >}}) for additional information about available types.

## Step 3: Add a container and use the secret you just defined

Add a Radius [container]({{< ref "guides/author-apps/containers" >}}) to your application:

{{< rad file="snippets/app-kubernetes.bicep" embed=true marker="//APPLICATION" >}}

## Step 4: Deploy your Radius Application

Deploy your application with the `rad` CLI:

```bash
rad run ./app.bicep -a demo
```

Your console output should look similar to:

```
Building ./app.bicep...
Deploying template './app.bicep' for application 'demo' and environment 'default' from workspace 'default'...

Deployment In Progress... 

...                  demo            Applications.Core/containers

Deployment Complete

Resources:
    demo            Applications.Core/containers

Starting log stream...
```

Open [http://localhost:3000](http://localhost:3000) to view the Radius demo container. Then navigate to the `Container Metadata` tab and the `Environment variables` section which are located near the bottom of the Radius demo webpage, there will be row dedicated to your Kubernetes secret object:

{{< image src="demo-secret-object.png" alt="Screenshot of Radius Demo app `Environment variables section" width="700px" >}}

You can also prove the deployed Kubernetes secret was created by using `kubectl`, and running the following command with your specific secret name:

```bash
kubectl describe secret my-secret  -n default-demo
```

Your console output should contain the following section:

```
Name:         my-secret
Namespace:    default-demo
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
my-secret-key:  15 bytes
```

## Cleanup

To delete your Radius specific Kubernetes resources you'll need to run:

```bash
rad app delete -a demo
```

Once your Radius Application has been deleted you can delete the Kubernetes Secret:

```bash
kubectl delete secret my-secret -n default-demo
```

Your console output should look similar to:

```
secret "my-secret" deleted
```

> [`rad app delete`]({{< ref rad_application_delete >}}) does not delete non-Radius resources that are not directly part of a Radius Application, such as Kubernetes resources. These resources require an additional cleanup step.

## Further reading

- [Kubernetes in Radius containers]({{< ref "guides/author-apps/containers/overview#kubernetes" >}})

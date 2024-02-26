---
type: docs
title: "How-To: Use a Kubernetes resources in your application"
linkTitle: "Use a Kubernetes resources in your application"
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

## Step 1: Start with a container

Begin by creating a file named `app.bicep` with a Radius [container]({{< ref "guides/author-apps/containers" >}}):

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 2: Define the Kubernetes provider

At the top of your Bicep file, import the `kubernetes` provider and add its configuration. The `namespace` property determines where to deploy Kubernetes resources by default. The `kubeConfig` property is not currently used and can remain as an empty string (`''`):
`kubeConfig` is leveraged by Radius for information needed to build connections with the user's remote Kubernetes clusters:

{{< rad file="snippets/app-kubernetes.bicep" embed=true marker="//KUBERNETES" >}}

## Step 3:  Add a Kubernetes secret resource

Add a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/) to your `app.bicep` file. This secret will contain a small amount of sensitive data such as a password, a token, or a key:

{{< rad file="snippets/app-kubernetes.bicep" embed=true marker="//APPLICATION" >}}

> Refer to the [Kubernetes overview page]({{< ref "/guides/author-apps/kubernetes/overview#resource-library" >}}) for additional information about available types.

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

Navigate to the `Container Metadata` tab and the `Environment variables` section, there will be row dedicated to your Kubernetes secret object:

<img src="./demo-secret-object.png" alt="Screenshot of Radius Demo app `Environment variables section`" width="600"/>

Users can also prove the deployed Kubernetes secret was created by using `kubectl`, and running the following command with your specific pod name:

```bash
kubectl describe pod demo-xxxx-xxxx -n default-demo
```

Your console output should contain the following section:

```
Containers:
  demo:
    Container ID:   containerd://xxxxxx
    Image:          ghcr.io/radius-project/xxxxxx
    Image ID:       ghcr.io/radius-project/xxxxx
    Port:           3000/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 19 Feb 2024 18:30:03 +0000
    Ready:          True
    Restart Count:  0
    Environment:
      SECRET:  my-secret-value
    Mounts:
```

## Cleanup

To delete your Kubernetes resources created you'll need to run the following command:

```bash
kubectl delete all --all -n default-demo
```

Your console output should look similar to:

```
pod "demo-74794c5b55-jw4db" deleted
service "demo" deleted
deployment.apps "demo" deleted
replicaset.apps "demo-74794c5b55" deleted
```

> Note in most cases you'll be able to run [`rad app delete`]({{< ref rad_application_delete >}}) however Radius does not currently delete Kubernetes resources.

## Further reading

- [Kubernetes in Radius containers]({{< ref "guides/author-apps/containers/overview#kubernetes" >}})

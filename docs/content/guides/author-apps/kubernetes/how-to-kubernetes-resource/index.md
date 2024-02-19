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

Add the following import statement and define your Kubernetes [`namespace` property]({{< ref "/guides/operations/kubernetes/overview#namespace-mapping" >}}) as well as the [`kubeConfig` property](https://kubernetes.io/docs/reference/config-api/kubeconfig.v1/). The 
`kubeConfig` is leveraged by Radius for information needed to build connections with the user's remote Kubernetes clusters:

{{< rad file="snippets/app-kubernetes.bicep" embed=true marker="//KUBERNETES" >}}

## Step 3:  Add a Kubernetes secret resource

A [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/) is an object that contains a small amount of sensitive data such as a password, a token, or a key. To leverage it in a Radius Application you simply need to define the it as a resource and establish its usage in your container resource:

{{< rad file="snippets/app-kubernetes.bicep" embed=true marker="//APPLICATION" >}}

> Note to see a list of all available Kubernetes resources visit the [Kubernetes overview page]({{< ref "/guides/author-apps/kubernetes/overview#resource-library" >}})

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

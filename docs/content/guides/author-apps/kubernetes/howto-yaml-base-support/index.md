---
type: docs
title: "How-To: Incremental onboard from existing Kubernetes resources"
linkTitle: "Incremental onboard from existing Kubernetes resources"
description: "Learn how to load a Kubernetes YAML base manifest into Radius and have Radius override properties on top of the user-given base resources"
weight: 500
categories: "How-To"
tags: ["Kubernetes"]
---

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Radius initialized with `rad init`]({{< ref howto-environment >}})

### Step 1: Author a Radius Application

Define a Radius Application resource that will contain your Kubernetes resource container.

> Application-scoped resources are by default generated in a new Kubernetes namespace with the name format `<envNamespace>-<appname>`. This prevents multiple applications with resources of the same name from conflicting with each other, however users can define their own Kubernetes namespace if they desire.

{{< rad file="snippets/basemanifest.bicep" embed=true marker="//APPLICATION" >}}

### Step 2: Map your Kubernetes base YAML file to a Radius container resource

You'll need to create a Radius container resource that will consume the information found in your Kubernetes base YAML file.

#### Standardize object names

Begin by assuring that your `ServiceAccount`, `Deployment`, and `Service` objects found in your Kubernetes base YAML file have the same name as the Radius container resource that lives inside your application-scoped namespace.

#### Container configurations

Define your Radius container resource port with the port of your Kubernetes `Service` as well as the image container location that your service is dependent on.

#### Runtime configuration

Load your Kubernetes YAML file into your Radius container resource through the `properties.runtimes.kubernetes.base` property which expects a string value containing all your Kubernetes data.

{{< rad file="snippets/basemanifest.bicep" embed=true marker="//CONTAINER" >}}

### Done

You can now deploy your Radius Application and verify that your Kubernetes objects are created in the desired namespace. Visit the Radius [Kubernetes resources authoring overview]({{< ref "/guides/author-apps/kubernetes/overview" >}}) page for more information.

## Further reading

- [Kubernetes authoring resources overview]({{< ref "/guides/author-apps/kubernetes/overview" >}})

---
type: docs
title: "How-To: Migrate from existing Kubernetes resources"
linkTitle: "Migrate from YAML"
description: "Learn how to migrate to a Radius container from existing Kubernetes YAML"
weight: 500
categories: "How-To"
tags: ["containers","Kubernetes"]
---

This guide will provide an overview of how to migrate your existing Kubernetes resources from [Kubernetes YAML](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#writing-a-deployment-spec).

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [rad CLI]({{< ref getting-started >}})
- [Radius initialized with `rad init`]({{< ref howto-environment >}})

### Step 1: Define a base Kubernetes YAML file

In a file named `kubernetes.yaml` define all the Kubernetes resources that correspond to the new Radius container.

Note that the names of the Deployments, Services, and Config Maps all must match each other and the name of the new Radius container. Any other resources can be named differently.

{{< rad file="snippets/basemanifest.yaml" embed=true lang="yaml">}}

### Step 2: Define a Radius container

[Radius containers]({{< ref "/guides/author-apps/containers/overview" >}}) represent a containerized workload within your Radius Application. You can define a Radius container and reference your Kubernetes YAML in order to deploy and manage it within Radius.

In a file named "app.bicep" add a new Container resource, specifying:

- The container image
- The port(s) your container exposes
- The contents of your Kubernetes YAML file


{{< rad file="snippets/basemanifest.bicep" embed=true marker="//CONTAINER" >}}

### Step 3: Deploy your container

Now that you've defined your Radius Container you can deploy it into your Application.

1. Run [`rad deploy`]({{< ref "rad_deploy" >}}) to deploy your application:

    ```bash
    rad deploy -a demo
    ```

2. Run `kubectl get all` to verify the Kubernetes resources were created:

    ```bash
    kubectl get all -n default-demo
    ```
   
   > Radius deploys app resources into a unique namespace for every app. For more information refer to the [Kubernetes docs]({{< ref "/guides/operations/kubernetes/overview#namespace-mapping" >}}).
3. Your console output should look similar to:
```
radius-system   controller-585dcd4c9b-5g2c9        1/1     Running            5 (91s ago)     13m
my-microservice my-microservice-5c464f66d4-s7n7w   0/1     Pending            0               0s
my-microservice my-microservice-5c464f66d4-s4tq8   0/1     Pending            0               0s
my-microservice my-microservice-5c464f66d4-tnvx4   0/1     Pending            0               0s
```
### Step 4: Clean up

1. Run the following command to delete all Pods, Deployments, and Services in the `my-microservice` namespace:

    ```bash
    kubectl delete -n my-microservice -f ./deploy
    ```
2. Run the following command to delete the `my-microservice` namespace:

    ```bash
    kubectl delete namespace my-microservice
    ```

## Further reading

- [Kubernetes authoring resources overview]({{< ref "/guides/author-apps/kubernetes/overview" >}})
- [Container resource overview]({{< ref "guides/author-apps/containers/overview#kubernetes" >}})
- [Container resource schema]({{< ref "container-schema#runtimes" >}})
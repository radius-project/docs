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

### Step 2: Add the Kubernetes base YAML configurations to your Radius application definition
1. Container configurations:

    Define your Radius container resource port with the port of your Kubernetes `Service` as well as the image container location that your service is dependent on.

2. Runtime configuration:

    Load your Kubernetes YAML file into your Radius container resource through the `properties.runtimes.kubernetes.base` property which expects a string value containing all your Kubernetes data.

{{< rad file="snippets/basemanifest.bicep" embed=true marker="//CONTAINER" >}}

You can now deploy your Radius Application and verify that your Kubernetes objects are created in the desired namespace. 

### Step 3: Deploy your container

1. Deploy your application with the command:

    ```bash
    rad deploy -a demo
    ```

2. Run the following command to verify and follow the Kubernetes pod creations: 
    ```bash
    kubectl get pods --namespace my-microservice 
    ```

3. Your console output should look similar to:
```
radius-system   controller-585dcd4c9b-5g2c9        1/1     Running            5 (91s ago)     13m
<your-kubernetes-service>   <your-kubernetes-service>-5c464f66d4-s7n7w   0/1     Pending            0               0s
<your-kubernetes-service>   <your-kubernetes-service>-5c464f66d4-s4tq8   0/1     Pending            0               0s
<your-kubernetes-service>   <your-kubernetes-service>-5c464f66d4-tnvx4   0/1     Pending            0               0s
```

## Further reading

- [Kubernetes authoring resources overview]({{< ref "/guides/author-apps/kubernetes/overview" >}})
- [Container resource overview]({{< ref "guides/author-apps/containers/overview#kubernetes" >}})
- [Container resource schema]({{< ref "container-schema#runtimes" >}})
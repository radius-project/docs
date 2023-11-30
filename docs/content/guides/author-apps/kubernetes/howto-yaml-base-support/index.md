---
type: docs
title: "How-To: Migrate from existing Kubernetes resources"
linkTitle: "Migrate using Kubernetes YAML"
description: "Learn how to migrate to a Radius container using existing Kubernetes YAML configurations"
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

> Note that the names of the Deployments, Services, and Config Maps all must match each other and the name of the new Radius container. Any other resources can be named differently.

{{< rad file="snippets/basemanifest.yaml" embed=true lang="yaml">}}

### Step 2: Define a Radius container

[Radius containers]({{< ref "/guides/author-apps/containers/overview" >}}) represent a containerized workload within your Radius Application. You can define a Radius container and reference your Kubernetes YAML in order to deploy and manage it within Radius.

In a file named "app.bicep" add any missing parameter that isn't found in your manifest file in your new Container resource. This could range from anything like a new such as:

- The container image path
- The port(s) your container exposes
- The contents of your Kubernetes YAML file


{{< rad file="snippets/basemanifest.bicep" embed=true marker="//CONTAINER" >}}

> Radius will override any values found in your Kubernetes manifest file if it finds a value for the same parameter in your `app.bicep` file otherwise it will use the value and only fill in the gaps in your manifest. However if you define a parameter such as  image name in the different container like sidecar, container renderer will not override the image location.

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
   
   > Radius deploys app resources into a unique namespace for every app. For more information refer to the [Kubernetes guide]({{< ref "/guides/operations/kubernetes/overview#namespace-mapping" >}}).
 
3. Your console output should look similar to:
```
NAME                                   READY   STATUS    RESTARTS   AGE
pod/my-microservice-795545bf79-glbhw   1/1     Running   0          21s

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/my-microservice   ClusterIP   10.43.177.210   <none>        3000/TCP   18s

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/my-microservice   1/1     1            1           2m41s

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/my-microservice-795545bf79   1         1         1       21s
replicaset.apps/my-microservice-96dc8569d    0         0         0       2m41s

1. Run the following command to delete all Pods, Deployments, and Services in the `my-microservice` namespace and the associated Radius Application:

    ```
    rad app delete -a demo
    ```

## Further reading

- [Kubernetes authoring resources overview]({{< ref "/guides/author-apps/kubernetes/overview" >}})
- [Container resource overview]({{< ref "guides/author-apps/containers/overview#kubernetes" >}})
- [Container resource schema]({{< ref "container-schema#runtimes" >}})
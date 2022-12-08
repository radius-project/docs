---
type: docs
title: "Set Kubernetes Metadata"
linkTitle: "Kubernetes Metadata"
description: "Learn how to configure Kubernetes labels and annotations for generated objects"
weight: 20
---

## Kubernetes labels and annotations 
[Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) are key/value pairs attached to Kubernetes objects and used to identify groups of related resources by organizational structure, release, process etc. Labels are descriptive in nature and can be queried.

[Annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) attach non-identifying information to Kubernetes objects. They are used to provide  additional information to users and can also be used for operational purposes. Annotations are used to represent behavior that can be leveraged by tools and libraries and often they are not human readable or queried.

## KubernetesMetadata extension
Project Radius enables you to retain or use your own defined tagging scheme for Kubernetes resources using Kubernetes labels and annotations. This enables users to incrementally adopt Radius for microservices built in the Kubernetes ecosystem using the Kubernetes native metadata concepts without having to do additional customizations.

You can set labels and annotations on an environment, application, or container using the KubernetesMetadata extension. The Kubernetes objects output from your resources (Deployments, Pods, etc.) will get the defined metadata.

### Example
Here is an example of how to set labels and annotations at the environment layer. All resources within the environment with Kubernetes object outputs will gain this metadata:

{{< rad file="snippets/env.bicep" embed=true >}}

Once deployed, containers deployed in this environment will gain these labels. You can view the labels and annotations set on your pods using the command below

```bash
kubectl describe pod <podname>
```

```bash
Name:             <podname>
Namespace:        default
Priority:         0
Labels:           app.kubernetes.io/managed-by=radius-rp
                  app.kubernetes.io/name=frontend
                  app.kubernetes.io/part-of=myapp
                  myapp.team.contact=support-operations
                  myapp.team.name=Operations
                  pod-template-hash=874f4f56f
                  radius.dev/application=myapp
                  radius.dev/resource=frontend
                  radius.dev/resource-type=applications.core-containers
Annotations:      prometheus.io/port: 9090
                  prometheus.io/scrape: true
```

## Cascading metadata
Kubernetes metadata can be applied at the environment, application, or container layers. Metadata cascades down from the environment to the application to the container. For example, you can set the labels and annotations at an environment level and all containers within the environment will gain these labels and annotations.

### Overriding behavior

You can also override the labels and annotations set at an environment resource either at an application or container level for the same key(s)

Environment -> Applications -> Container/Service

Container/Service has the highest precedence in overriding, compared to applications and environment

#### Example
Lets consider an example where the service team wants to override the contact information that was set at the environment level.
The infrastructure operator sets up a generic contact at the environment resource for troubleshooting

{{< rad file="snippets/override.bicep" embed=true marker="//ENV" >}}

The developer or any engineer can choose to override this contact information at the container level as they might be supporting only a certain service.

{{< rad file="snippets/override.bicep" embed=true marker="//CONTAINER" >}}

The labels and annotations at the deployment and pod looks like below
``` bash
Labels:           app.kubernetes.io/managed-by=radius-rp
                  app.kubernetes.io/name=frontend
                  app.kubernetes.io/part-of=myapp
                  myapp.team.contact=support-UI
                  myapp.team.name=UI
                  pod-template-hash=874f4f56f
                  radius.dev/application=myapp
                  radius.dev/resource=frontend
                  radius.dev/resource-type=applications.core-containers
Annotations:      prometheus.io/port: 9090
                  prometheus.io/scrape: true
```

### Reserved keys
Certain labels/annotations have special uses to Radius internally and are not allowed to be overriden by user. Labels/Annotations with keys that have a prefix : `radius.dev/` will be ignored during processing.

### Order of extension processing
Other extensions may set Kubernetes metadata. For example, the `daprSidecar` extension sets the `dapr.io/enabled` annotation, as well as some others. This may cause issues in the case of conflicts.

The order in which extensions are executed is as follows, from first to last:

Container -> Dapr Sidecar Extension -> Manual Scale Extension -> Kubernetes Metadata Extension

This implies any labels/annotations defined as part of extensions other than Kubernetes Metadata Extension are also added to the deployments and pods 

When labels/annotation have the same set of key(s) added by two or more extensions, the final value is determined by the order of the extension execution
---
type: docs
title: "Set Kubernetes metadata"
linkTitle: "Kubernetes metadata"
description: "Learn how to configure Kubernetes labels and annotations for generated objects"
weight: 300
---

## Background

[Kubernetes Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) are key/value pairs attached to Kubernetes objects and used to identify groups of related resources by organizational structure, release, process etc. Labels are descriptive in nature and can be queried.

[Kubernetes Annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) attach non-identifying information to Kubernetes objects. They are used to provide  additional information to users and can also be used for operational purposes. Annotations are used to represent behavior that can be leveraged by tools and libraries and often they are not human readable or queried.

## Kubernetes metadata extension

Project Radius enables you to retain or use your own defined tagging scheme for Kubernetes resources using Kubernetes labels and annotations. This enables users to incrementally adopt Radius for microservices built in the Kubernetes ecosystem using Kubernetes metadata concepts.

You can set labels and annotations on an environment, application, or container using the Kubernetes metadata extension. The Kubernetes objects output from your resources (_Deployments, Services, etc._) will now have the defined metadata.

{{< tabs Environment Application Container >}}

{{% codetab %}}
{{< rad file="snippets/env.bicep" embed=true marker="//ENV" >}}
{{% /codetab %}}

{{% codetab %}}
{{< rad file="snippets/env.bicep" embed=true marker="//APP" >}}
{{% /codetab %}}

{{% codetab %}}
{{< rad file="snippets/env.bicep" embed=true marker="//CONTAINER" >}}
{{% /codetab %}}

{{< /tabs >}}

## Cascading metadata

Kubernetes metadata can be applied at the environment, application, or container layers. Metadata cascades down from the environment to the application to the container. For example, you can set labels and annotations at an environment level and all containers within the environment will gain these labels and annotation, without the need for an explicit extension on the containers.

### Supported resources

The following resources will gain the Kubernetes metadata for its [output resources]({{< ref resource-mapping> }}):

- Applications.Core/containers
- Applications.Core/httpRoutes
- Applications.Core/gateways

### Metadata processing order

Labels and annotations are processed in the following order, combining the keys/values at each level:

1. Environment
1. Application
1. Container

### Conflicts and overrides

In the case where layers have conflicting keys (_i.e. Application and Container both specify a `myapp.team.name` label_), the last level to process wins out and overrides other values (container). The metadata specified on the container will override the metadata specified on the application or environment.

## Reserved keys

Certain labels/annotations have special uses to Radius internally and are not allowed to be overridden by user. Labels/Annotations with keys that have a prefix : `radius.dev/` will be ignored during processing.

## Extension processing order

Other extensions may set Kubernetes metadata. For example, the `daprSidecar` extension sets the `dapr.io/enabled` annotation, as well as some others. This may cause issues in the case of conflicts.

The order in which extensions are executed is as follows, from first to last:

1. Dapr sidecar extension 
1. Manual scale extension
1. Kubernetes metadata extension

### Conflicts

When labels/annotation have the same set of key(s) added by two or more extensions, the final value is determined by the last extension that is processed.

## Example

Let's take an example of an application with some labels and annotations. This example shows some generic 'keys', as well as an example of how an organization may use labels to track organization contact information inside labels for troubleshooting scenarios:

{{< rad file="snippets/env.bicep" embed=true marker="//APP" >}}

All resources within this application with Kubernetes outputs will gain these labels. Let's now take a look at a frontend container, where the frontend team has overridden some of the values:

{{< rad file="snippets/env.bicep" embed=true marker="//CONTAINER" >}}

When this file is deployed, the metadata on the `frontend` deployment is:

```bash
$ kubectl describe deployment frontend
Name:             frontend
Namespace:        default-myapp
Labels:           key1=appValue1
                  key2=containerValue2
                  team.contact.name=Frontend
                  team.contact.alias=frontend-eng
                  radius.dev/application=myapp
                  radius.dev/resource=frontend
                  radius.dev/resource-type=applications.core-containers
                  ...
Annotations:      prometheus.io/port: 9090
                  prometheus.io/scrape: true
                  ...
```

The labels & annotations were set based on the following:

| Key | Value | Description |
|-----|-------|-------------|
| **Labels**
| `team.key1` | `appValue1` | Application value is applied
| `team.key2` | `containerValue2` | Container value overrides application value
| `team.contact.name` | `Frontend` | Container value overrides application value
| `team.contact.alias` | `frontend-eng` | Container value overrides application value
| `radius.dev/application` | `myapp` | Radius-injected label
| `radius.dev/resource` | `frontend` | Radius-injected label
| `radius.dev/resource-type` | `applications.core-containers` | Radius-injected label
| **Annotations**
| `prometheus.io/port` | `9090` | Application annotation is applied
| `prometheus.io/scrape` | `true `| Application annotation is applied

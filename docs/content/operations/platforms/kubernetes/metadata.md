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

```yaml
import radius as radius

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'myenv'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'my-ns'
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'myapp.team.name':'Operations'
          'myapp.team.contact':'support-operations@myapp.com'
        }
        annotations: {
          'prometheus.io/scrape': 'true'
          'prometheus.io/port': '9090'
        }
      }
    ]
  }
}
```
Once deployed, containers deployed in this environment will gain these labels. For example:
```
Labels:  myapp.team.name:Operations
         myapp.team.contact':support-operations@myapp.com 
              
Annotations:   prometheus.io/scrape: true
               prometheus.io/port': 9090
```

## Cascading metadata
Kubernetes metadata can be applied at the environment, application, or container layers. Metadata cascades down from the environment to the application to the container. For example, you can set the labels and annotations at an environment level and all containers within the environment will gain these labels and annotations.

<!---can we attach a pic of how all of the resources inside an environment has the labels and annotations!--->

You can also override the labels and annotations set at an environment resource either at an application or container level. 

### Example
Lets consider an example where the service team wants to override the contact information that was set at the environment level.
The infrastructure operator sets up a generic contact at the environment resource for troubleshooting

```yaml
import radius as radius

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'myenv'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'myns'
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'myapp.team.name':'Operations'
          'myapp.team.contact':'support-operations@myapp.com'
        }
        annotations: {
          'prometheus.io/scrape': 'true'
          'prometheus.io/port': '9090'
        }
      }
    ]
  }
}
```
The developer or any engineer can choose to override this contact information at the container level as they might be supporting only a certain service.

```yaml
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'myapp-ui'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: magpieimage
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'myapp.team.name':'myapp-UI'
          'myapp.team.contact':'support-ui@myapp.com'
        }
    ]
  }
}
```

The labels and annotations at the deployment and pod looks like below
```
Labels:  myapp.team.name: myapp-UI
         myapp.team.contact: support-ui@myapp.com 
              
Annotations:   prometheus.io/scrape: true
               prometheus.io/port': 9090
```


When key(s) defined for labels/annotations at different levels are the same, the last level in the order takes precedence. 

Environment -> Applications -> Container/Service

Container/Service has the highest precedence, compared to applications and environment

### Reserved keys
Certain labels/annotations have special uses to Radius internally and are not allowed to be overriden by user. Labels/Annotations with keys that have a prefix : `radius.dev/` will be ignored during processing.

### Order of extension processing
Other extensions may set Kubernetes metadata. For example, the `daprSidecar` extension sets the `dapr.io/enabled` annotation, as well as some others. This may cause issues in the case of conflicts.

The order in which extensions are executed is as follows, from first to last:

Container -> Dapr Sidecar Extension -> Manual Scale Extension -> Kubernetes Metadata Extension

This implies any labels/annotations defined as part of extensions other than Kubernetes Metadata Extension are also added to the deployments and pods 

When labels/annotation have the same set of key(s) added by two or more extensions, the final value is determined by the order of the extension execution
---
type: docs
title: "Kubernetes Metadata"
linkTitle: "Kubernetes Metadata"
description: "Learn how to use Kubernetes concepts of labels and annotations in Radius"
weight: 10
---

## Kubernetes Labels and Annotations 
[Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) are key/value pairs attached to Kubernetes objects and used to identify groups of related resources by organizational structure, release, process etc. Labels are descriptive in nature and can be queried.

[Annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) attach non-identifying information to Kubernetes objects. They are used to provide  additional information to users and can also be used for operational purposes. Annotations are used to represent behavior that can be leveraged by tools and libraries and often they are not human readable or queried.

## Kubernetes Metadata Extension in Radius
Project Radius enables you to retain or use your own defined tagging scheme for Kubernetes resources using Kubernetes labels and annotations. This enables users to incrementally adopt Radius for microservices built in the Kubernetes ecosystem using the Kubernetes native metadata concepts without having to do much customizations

You can set the labels and annotations on an environment or an application or a container resource using the Kubernetes metadata extension type. All the set labels and annotation will be added to the underlying deployment resource and pods associated to your workflow

Below is an example of how to set labels and annotations on an environment. The same can be set at the application or container resource
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
In the above example, the labels at the deployment and pod include :
```
Labels:  myapp.team.name:Operations
         myapp.team.contact':support-operations@myapp.com 
              
Annotations:   prometheus.io/scrape: true
               prometheus.io/port': 9090
```

## Cascading Kubernetes Metadata to Various Resources
Kubernetes metadata are applied to the Radius resources in a cascading order. For eg : You can set the labels and annotations at an environment level and have it cascaded to all of the application and resources in that environment. 

<!---can we attach a pic of how all of the resources inside an environment has the labels and annotations!--->

You can also override the labels and annotations set at an environment resource either at an application or container level. 

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

Container/Service > Applications > Environment

Container/Service has the highest precedence, than applications and environment

## Behavior of Kubernetes metadata in the realm of other things

### Reserved Key Prefix
Certain labels/annotations have special uses to Radius internally and are not allowed to be overriden by user. Labels/Annotations with keys that have a prefix : `radius.dev/` will be ignored during processing.

### Order of Extensions processing
Radius already uses extensions type to add a Dapr sidecar and to manually scale on containers. The order in which they are executed is as follows from first to last:

Container -> Dapr Sidecar Extension -> Manual Scale Extension -> Kubernetes Metadata Extension

This implies any labels/annotations defined as part of extensions other than Kubernetes Metadata Extension are also added to the deployments and pods 

When labels/annotation have the same set of key(s) added by two or more extensions, the final value is determined by the order of the extension execution

### Metadata Tags for Azure Resources
Project Radius allows for users to specify tags on Azure resources. These tags are applied directly on the target resource and do not affect output resources such as Kubernetes deployments or pods.

eg. 
```yaml
...
resource store 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'db-service'
  location: 'global'
  tags: {
    aztag1 : 'aztag.val.1'
    aztag2 : 'aztag.val.1'
  }
  properties: {
    application: app.id
    container: {
      image: magpieimage
    }
    connections: {
      databaseresource: {
        source: databaseAccount.id
      }
    }
  }
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: 'dbacc-${guid(resourceGroup().name)}'
  location: location
  kind: 'MongoDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
  }
}
```



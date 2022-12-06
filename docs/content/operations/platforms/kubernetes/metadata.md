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

Below is an example of how to set labels and annotations on an environment 
```yaml
import radius as radius

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'test-env'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'test-ns'
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        annotations: {
          'myapp.team.name':'Operations'
          'myapp.team.contact':'support-operations@myapp.com'
        }
        labels: {
          'prometheus.io/scrape': 'true'
          'prometheus.io/port': '9090'
        }
      }
    ]
  }
}
```


eg. Kubernetes Metadata at Application level
```yaml
import radius as radius

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'test-app'
  location: 'global'
  properties: {
    environment: env.id
    extensions: [
      {
        kind: 'kubernetesMetadata'
        annotations: {
          'app.ann.1': 'app.ann.val.1'
          'app.ann.2': 'app.ann.val.2'
        }
        labels: {
          'app.lbl.1': 'app.lbl.val.1'
          'app.lbl.2': 'app.lbl.val.2'
        }
      }
    ]
  }

}
```


eg. Kubernetes Metadata at Container/Service level
```yaml
import radius as radius

@description('Specifies the image of the container resource.')
param magpieimage string = 'radiusdev.azurecr.io/magpiego:latest'

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'test-ctnr'
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
        annotations: {
          'cntr.ann.1': 'cntr.ann.val.1'
          'cntr.ann.2': 'cntr.ann.val.2'
        }
        labels: {
          'cntr.lbl.1': 'cntr.lbl.val.1'
          'cntr.lbl.2': 'cntr.lbl.val.2'
        }
      }
    ]
  }
}

```

## Cascading Kubernetes Metadata to Various Resources
Kubernetes extensions are applied to resources in a cascading order. The resource type of the resource where the extension is included determines the order. Labels/Annotations declared at the Environment level and/or Application levels are applied to all associated Containers/Services. 

In the above example, the labels at the deployment and pod include :
```
Labels:       env.lbl.1=env.lbl.val.1
              env.lbl.2=env.lbl.val.2  
              app.lbl.1=app.lbl.val.1
              app.lbl.2=app.lbl.val.2
              cntr.lbl.1=cntr.lbl.val.1
              cntr.lbl.2=cntr.lbl.val.2
              
Annotations:  env.ann.1: env.ann.val.1
              env.ann.2: env.ann.val.2
              app.ann.1: app.ann.val.1
              app.ann.2: app.ann.val.2
              cntr.ann.1: cntr.ann.val.1
              cntr.ann.2: cntr.ann.val.2
```

In case of conflicts, when key(s) defined for labels/annotations at different levels are the same, the last level in the order takes precedence. 

Environment -> Application -> Container/Service

eg. Kubernetes Metadata at Application and Container levels with conflict in keys
```yaml
import radius as radius

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'test-app'
  location: 'global'
  properties: {
    environment: env.id
    extensions: [
      {
        kind: 'kubernetesMetadata'
        annotations: {
          'conflict.ann.1': 'app.level.ann.conflictval'
        }
        labels: {
          'conflict.lbl.1': 'app.level.lbl.conflictval'
        }
      }
    ]
  }
}

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'test-ctnr'
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
        annotations: {
         'conflict.ann.1': 'cntr.level.ann.conflictval'
        }
        labels: {
           'conflict.lbl.1': 'cntr.level.lbl.conflictval'
        }
      }
    ]
  }
}

```

In the above example, the labels at the deployment and pod would include the conflict keys and values specified at the Container/Service level :
```
Labels:       conflict.ann.1: cntr.level.ann.conflictval
              
Annotations:  conflict.lbl.1: cntr.level.lbl.conflictval
```

## Reserved Key Prefix
Certain labels/annotations have special uses to Radius internally and are not allowed to be overriden by user input.
Labels/Annotations with keys that have a prefix : `radius.dev/` will be ignored during processing.

## Order of Extensions processing
Amongst the various extensions, the order in which they are rendered is as follows from first to last:

Container -> Dapr Sidecar Extension -> Manual Scale Extension -> Kubernetes Metadata Extension

This implies any labels/annotations defined in extensions other than Kubernetes Metadata Extension are included in the rendering of Kubernetes Metadata Extension.

## Metadata Tags for Azure Resources
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



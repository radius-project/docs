---
type: docs
title: "Radius.Compute/persistentVolumes@2025-08-01-preview"
linkTitle: "PersistentVolumes"
---

{{< schemaExample >}}

## Description

The Radius.Compute/persistentVolumes Resource Type represents a persistent storage volume. A PersistentVolume can be referenced in the volumes property of a Container. 
To deploy, first add a PersistentVolume resource to the application definition Bicep file.
```
extension radius
param environment string 

resource myApplication 'Radius.Core/applications@2025-08-01-preview' = { ... }

resource myPersistentVolume 'Radius.Compute/persistentVolumes@2025-08-01-preview' = {
  name: 'myPersistentVolume'
  properties: {
    environment: environment
    application: myApplication.id
    sizeInGib: 1
  }
}
```

Then reference the PersistentVolume by ID in the volumes property of the Container. Finally, set the mountPath in the container referencing the volumeName.
```
resource myContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'myContainer'
  properties: {
    environment: environment
    application: myApplication.id
    containers: {
      demo: {
        image: 'ghcr.io/radius-project/samples/demo:latest'
        volumeMounts: [
          {
          volumeName: 'data'
          mountPath: '/app/data'
          } 
        ] 
      }
    }
    volumes: {
      data: {
        persistentVolume: {
          resourceId: myPersistentVolume.id
        }
      }
    }
  }
}
```

PersistentVolumes may be shared across multiple Containers. To mount an existing PersistentVolume in read-only mode, reference the PersistentVolume by name using the `existing` Bicep keyword. For example:
```
resource existingPersistentVolume 'Radius.Compute/persistentVolumes@2025-08-01-preview' existing = {
  name: 'existingPersistentVolume'
}
```

Then add the existing PersistentVolume to the volumes property of a Container with accessMode set to `ReadOnlyMany`.
```
resource myContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'myContainer'
  properties: {
    environment: environment
    application: myApplication.id
    containers: {
      demo: {
        image: 'ghcr.io/radius-project/samples/demo:latest'
        volumeMounts: [
          {
            volumeName: 'readOnlyData'
            mountPath: '/app/data' 
          }
        ]
      }
    }
    volumes: {
      readOnlyData: {
        persistentVolume: {
          resourceId: existingPersistentVolume.id
          accessMode: 'ReadOnlyMany'
        }
      }
    }
  }
}
```

A PersistentVolume may be shared between multiple Containers in read/write mode if the PersistentVolume was created with `accessMode: ReadWriteMany` and the volume is set to ReadWriteMany as well. Note that not all infrastructures support this mode.

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `allowedAccessModes` | string | (Optional) The access modes which are permitted to be requested by a Container. Assumed to be all modes if not specified.<br />Allowed values: `ReadOnlyMany`, `ReadWriteMany`, `ReadWriteOnce`. |
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `sizeInGib` | integer | (Required) The size of the volume in gibibytes. `1` represents 1024 MiB. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

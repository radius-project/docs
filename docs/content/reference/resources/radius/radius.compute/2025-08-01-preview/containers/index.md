---
type: docs
title: "Reference: radius.compute/containers@2025-08-01-preview"
linkTitle: "containers"
description: "Detailed reference documentation for radius.compute/containers@2025-08-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

The Radius.Compute/containers Resource Type is the primary resource type for running one or more containers. It is always part of a Radius Application. To deploy a Container add a resource to the application definition Bicep file.

```bicep
extension radius
param environment string 

resource myApplication 'Radius.Core/applications@2025-08-01-preview' = { ... }

resource myContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'myContainer'
  properties: {
    environment: environment
    application: myApplication.id
    containers: {
      demo: {
        image: 'ghcr.io/radius-project/samples/demo:latest'
      }
    }
  }
}
```

By default, Containers deploys to Kubernetes. In this case, a Kubernetes Deployment named myContainer is deployed which includes a Pod named myContainer. Your Radius environment may deploy to other container platforms such as Azure Container Instances. 

To accept network connections, expose a port on the container.

```bicep
resource myContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'myContainer'
  properties: {
    environment: environment
    application: myApplication.id
    containers: {
      demo: {
        image: 'ghcr.io/radius-project/samples/demo:latest'
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
    }
  }
}
```

When a port is included, a Kubernetes Service of type ClusterIP is created for the container. Its name is `<container-resource-name>-<container-name>`, lowercased to satisfy Kubernetes naming rules — for the example above, `mycontainer-demo`. The recipe publishes each port-exposing container's in-cluster Service DNS name in the read-only `hosts` map, keyed by container name. Peer containers can address a specific container by referencing `<peer>.properties.hosts.<containerName>` instead of hardcoding a Service name.

To create an ephemeral emptyDir shared between two containers add a Containers.properties.volumes.

```bicep
resource myContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'myContainer'
  properties: {
    environment: environment
    application: myApplication.id
    containers: {
      frontend: {
        image: 'frontend:latest'
        volumeMounts: [
          {
            volumeName: 'shared'
            mountPath: '/var/shared' 
          }
        ]
      }
      backend: {
        image: 'backend:latest'
        volumeMounts: [
          {
            volumeName: 'shared'
            mountPath: '/var/shared' 
          }
        ]
      }
    }
    volumes: {
      shared: {
        emptyDir: {}
      }
    }
  }
}
```

To mount a persistent volume or secret see the PersistentVolumes and Secrets Resource Types.

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | true | false | (Required) The Radius Application ID. `myApplication.id` for example. |
| `autoScaling` | [object](#autoscaling) | false | false |  |
| `codeReference` | string | false | false | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | false | false | (Optional) Map of resources this container is dependent upon. `db: { source: db.id } for example. |
| `containers` | [object](#containers) | true | false |  |
| `environment` | string | true | false | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `extensions` | [object](#extensions) | false | false | (Optional) Properties for additional functionality. daprSidecar is the only available option. |
| `hosts` | object | false | true | (Read Only) Map of container name to the in-cluster DNS host of that container's Kubernetes Service. Populated for every container that exposes a port, so a multi-container resource publishes all of its Service hosts. Peer containers address a specific container by referencing `<peer>.properties.hosts.<containerName>`. |
| `platformOptions` | object | false | false | (Optional) If enabled by the platform engineer, properties to be passed to the Recipe for the specified platform. |
| `replicas` | integer | false | false | (Optional) The minimum number of replicas for the set of containers. |
| `restartPolicy` | string | false | false | (Optional) Defines how a containers behave when they terminate. `Always` will restart containers regardless of their exit status. `OnFailure` will restart containers if they return a non-zero exit code.<br />Allowed values: `Always`, `Never`, `OnFailure`. |
| `volumes` | [object](#volumes) | false | false | (Optional) List of volumes that can be mounted by a container. |

## Object Properties

### `autoScaling` {#autoscaling}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `maxReplicas` | integer | false | false | (Optional) The maximum number of replicas for the autoscaler. |
| `metrics` | [object](#autoscaling-metrics)[] | true | false | (Required) The metric to measure and target used to autoscale. |

### `connections` {#connections}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `disableDefaultEnvVars` | boolean | false | false | (Optional) Disables the automatic injection of environment variables from connected resource properties. |
| `source` | string | true | false | (Required) The resource ID of the resource this container is dependent upon. |

### `containers` {#containers}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `args` | string array | false | false | (Optional) Arguments for the command. Overrides the container image CMD. `["echo Hello", "&&", "echo World"]` for example. |
| `command` | string array | false | false | (Optional) Command the container runs. Overrides the container image ENTRYPOINT. `["/bin/sh", "-c"]` for example. |
| `env` | [object](#containers-env) | false | false | (Optional) Environment variables injected into the container. |
| `image` | string | true | false | (Required) The container image. `ghcr.io/radius-project/samples/demo:latest` for example. |
| `initContainer` | boolean | false | false | (Optional) Set to true if container should run and succeed prior to other containers starting. |
| `livenessProbe` | [object](#containers-livenessprobe) | false | false | (Optional) A liveness probe defines a check (a probe) to determine if a container is healthy. |
| `ports` | [object](#containers-ports) | false | false | (Optional) Network ports exposed by the container. A network endpoint is created for each port. For L7 ingress create a Routes resource. |
| `readinessProbe` | [object](#containers-readinessprobe) | false | false | (Optional) A readiness probe defines a check (a probe) to determine when a container is ready to begin accepting traffic. |
| `resources` | [object](#containers-resources) | false | false | (Optional) Compute resource requirements for the container. |
| `volumeMounts` | [object](#containers-volumemounts)[] | false | false | (Optional) Volumes to mount in the container. |
| `workingDir` | string | false | false | (Optional) The working directory inside the container. `/usr/share` for example. |

### `extensions` {#extensions}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `daprSidecar` | [object](#extensions-daprsidecar) | false | false | (Optional) When set the daprSidecar container is configured. |

### `volumes` {#volumes}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `emptyDir` | [object](#volumes-emptydir) | false | false | (Optional) An empty directory. |
| `persistentVolume` | [object](#volumes-persistentvolume) | false | false | (Optional) Mount an existing Radius PersistentVolume resource. |
| `secretName` | string | false | false | (Optional) The Radius Secret resource name. |

### `autoScaling.metrics` {#autoscaling-metrics}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `customMetric` | string | false | false | (Optional) The custom metric exposed by the application. Implementation specific. See platform engineer for further guidance. |
| `kind` | string | true | false | (Required) The metric to measure.<br />Allowed values: `cpu`, `custom`, `memory`. |
| `target` | [object](#autoscaling-metrics-target) | true | false | (Required) When the metric exceeds the target value specified, autoscaling is triggered. Only one target value can be specified dependent upon the type. |

### `containers.env` {#containers-env}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `value` | string | false | false | (Optional) String value of the environment variable. |
| `valueFrom` | [object](#containers-env-valuefrom) | false | false |  |

### `containers.livenessProbe` {#containers-livenessprobe}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `exec` | [object](#containers-livenessprobe-exec) | false | false | (Optional) An exec probe runs a command within a container. If the command succeeds and returns 0 the probe is healthy. |
| `failureThreshold` | integer | false | false | (Optional) Minimum consecutive failures for the probe to be considered failed after having succeeded. Assumed to be 3 if not specified. |
| `httpGet` | [object](#containers-livenessprobe-httpget) | false | false | (Optional) A httpGet probe performs a HTTP GET against the container on the specified port. If the HTTP server returns a code greater than or equal to 200 and less than 400 the probe is healthy. |
| `initialDelaySeconds` | integer | false | false | (Optional) Number of seconds after the container has started before probes are initiated. |
| `periodSeconds` | integer | false | false | (Optional) How often to perform the probe. Assumed to be 10 seconds if not specified. |
| `successThreshold` | integer | false | false | (Optional) Minimum consecutive successes for the probe to be considered successful after having failed. Assumed to be 1 if not specified. |
| `tcpSocket` | [object](#containers-livenessprobe-tcpsocket) | false | false | (Optional) A TCP socket probe establishes a TCP connection to the container on the specified port. If a connection is established the probe is healthy. |
| `terminationGracePeriodSeconds` | integer | false | false | (Optional) Number of seconds the container needs to terminate gracefully upon probe failure. The grace period amount of time between when a container is sent a termination signal and the time when the processes are forcibly halted with a kill signal. |
| `timeoutSeconds` | integer | false | false | (Optional) Number of seconds after which the probe times out. Assumed to be 1 second if not specified. |

### `containers.ports` {#containers-ports}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `containerPort` | integer | true | false | (Required) The network port the container is listening on. `443` for example. |
| `protocol` | string | false | false | (Optional) The protocol. If not specified, `TCP` is assumed.<br />Allowed values: `TCP`, `UDP`. |

### `containers.readinessProbe` {#containers-readinessprobe}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `exec` | [object](#containers-readinessprobe-exec) | false | false | (Optional) An exec probe runs a command within a container. If the command succeeds and returns 0 the probe is healthy. |
| `failureThreshold` | integer | false | false | (Optional) Minimum consecutive failures for the probe to be considered failed after having succeeded. Assumed to be 3 if not specified. |
| `httpGet` | [object](#containers-readinessprobe-httpget) | false | false | (Optional) A httpGet probe performs a HTTP GET against the container on the specified port. If the HTTP server returns a code greater than or equal to 200 and less than 400 the probe is healthy. |
| `initialDelaySeconds` | integer | false | false | (Optional) Number of seconds after the container has started before probes are initiated. |
| `periodSeconds` | integer | false | false | (Optional) How often to perform the probe. Assumed to be 10 seconds if not specified. |
| `successThreshold` | integer | false | false | (Optional) Minimum consecutive successes for the probe to be considered successful after having failed. Assumed to be 1 if not specified. |
| `tcpSocket` | [object](#containers-readinessprobe-tcpsocket) | false | false | (Optional) A TCP socket probe establishes a TCP connection to the container on the specified port. If a connection is established the probe is healthy. |
| `terminationGracePeriodSeconds` | integer | false | false | (Optional) Number of seconds the container needs to terminate gracefully upon probe failure. The grace period amount of time between when a container is sent a termination signal and the time when the processes are forcibly halted with a kill signal. |
| `timeoutSeconds` | integer | false | false | (Optional) Number of seconds after which the probe times out. Assumed to be 1 second if not specified. |

### `containers.resources` {#containers-resources}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `limits` | [object](#containers-resources-limits) | false | false | (Optional) Limits define the maximum amount of CPU or memory the container can consume. |
| `requests` | [object](#containers-resources-requests) | false | false | (Optional) Requests define the minimum amount of CPU or memory that is required by the container. |

### `containers.volumeMounts` {#containers-volumemounts}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `mountPath` | string | true | false | (Required) The path to mount the volume in the container file system. |
| `volumeName` | string | true | false | (Required) The name of the volume defined in Containers.properties.volumes. |

### `extensions.daprSidecar` {#extensions-daprsidecar}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `appId` | string | false | false | (Optional) The unique ID of the Dapr application. Used for service discovery, state encapsulation and the pub/sub consumer ID. |
| `appPort` | integer | false | false | (Optional) The port your application is listening on. |
| `config` | string | false | false | (Optional) The Dapr Configuration resource name. |

### `volumes.emptyDir` {#volumes-emptydir}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `medium` | string | false | false | (Optional) Set to `memory` for a tmpfs (RAM backed filesystem). Note that while tmpfs is very fast storage counts against the memory limit of the container.<br />Allowed values: `disk`, `memory`. |

### `volumes.persistentVolume` {#volumes-persistentvolume}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `accessMode` | string | false | false | (Optional) Set to `ReadWriteOnce` if no other Containers can mount in read/write mode. Set to `ReadOnlyMany` to enable other Containers to mount in read-only mode. Set to `ReadWriteMany` to allow multiple containers to mount in read/write mode. Assumed to be `ReadWriteOnce` if not specified.<br />Allowed values: `ReadOnlyMany`, `ReadWriteMany`, `ReadWriteOnce`. |
| `resourceId` | string | false | false | (Required) The Radius PersistentVolume resource ID. |

### `autoScaling.metrics.target` {#autoscaling-metrics-target}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `averageUtilization` | integer | false | false | (Optional) The average CPU or memory utilization across all containers expressed as a percentage. Kind must be CPU or memory. |
| `averageValue` | integer | false | false | (Optional) The average value of the metric as a quantity. |
| `value` | integer | false | false | (Optional) The absolute value of the metric as a quantity. |

### `containers.env.valueFrom` {#containers-env-valuefrom}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `secretKeyRef` | [object](#containers-env-valuefrom-secretkeyref) | false | false | (Optional) Set the environment variable value based on a Radius Secrets resource. |

### `containers.livenessProbe.exec` {#containers-livenessprobe-exec}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `command` | string array | true | false | (Required) The command to run inside the container. `["cat", "/tmp/healthy"]` for example. |

### `containers.livenessProbe.httpGet` {#containers-livenessprobe-httpget}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `httpHeaders` | [object](#containers-livenessprobe-httpget-httpheaders)[] | false | false | (Optional) Custom HTTP headers to be included in the GET request. |
| `path` | string | true | false | (Required) The path to access on the HTTP server. |
| `port` | integer | true | false | (Required) The TCP port connect to on the container. |
| `scheme` | string | false | false | (Optional) HTTP or HTTPS. Assumes HTTP is not specified.<br />Allowed values: `http`, `https`. |

### `containers.livenessProbe.tcpSocket` {#containers-livenessprobe-tcpsocket}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `port` | integer | true | false | (Required) The TCP port to connect to. |

### `containers.readinessProbe.exec` {#containers-readinessprobe-exec}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `command` | string array | true | false |  |

### `containers.readinessProbe.httpGet` {#containers-readinessprobe-httpget}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `httpHeaders` | [object](#containers-readinessprobe-httpget-httpheaders)[] | false | false | (Optional) Custom HTTP headers to be included in the GET request. |
| `path` | string | true | false | (Required) The path to access on the HTTP server. |
| `port` | integer | true | false | (Required) The TCP port connect to on the container. |
| `scheme` | string | false | false | (Optional) HTTP or HTTPS. Assumes HTTP is not specified.<br />Allowed values: `http`, `https`. |

### `containers.readinessProbe.tcpSocket` {#containers-readinessprobe-tcpsocket}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `port` | integer | true | false | (Required) The TCP port to connect to. |

### `containers.resources.limits` {#containers-resources-limits}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `cpu` | string | false | false | (Optional) The maximum number of vCPUs which can be used by the container. |
| `memoryInMib` | integer | false | false | (Optional) The maximum amount of memory which can be used by the container in MiB. |

### `containers.resources.requests` {#containers-resources-requests}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `cpu` | string | false | false | (Optional) The minimum number of vCPUs required by the container. `0.1` results in one tenth of a vCPU being reserved. |
| `memoryInMib` | integer | false | false | (Optional) The minimum amount of memory required by the container in MiB. `1024` results in 1 GiB of memory being reserved. |

### `containers.env.valueFrom.secretKeyRef` {#containers-env-valuefrom-secretkeyref}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `key` | string | false | false | (Optional) The key of the Radius Secrets resource. The value of the key will be used as the environment variable value. |
| `secretName` | string | false | false | (Optional) The name of the Radius Secrets resource. |

### `containers.livenessProbe.httpGet.httpHeaders` {#containers-livenessprobe-httpget-httpheaders}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `value` | string | true | false | (Required) The header field value. |

### `containers.readinessProbe.httpGet.httpHeaders` {#containers-readinessprobe-httpget-httpheaders}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `value` | string | true | false | (Required) The header field value. |

---
type: docs
title: "API timeout/retry policies"
linkTitle: "Timeout/retry policies"
description: "Learn the timeout/retry policies of the Radius API"
---

## Radius services

There are two main Radius services that will provide the resources described below:

- [Deployment Engine]({{< ref "architecture-concept#bicep-deployments-resource-provider" >}})
- [Resource Provider]({{< ref "architecture-concept#applications-resource-provider" >}})

## Deployment engine behavior

| Operation | Resource Name | Server Timeout (Seconds) | Async Operation retry condition|
|------|:--------:|-------------|---------|------------|
| Default retry timeout for resource deployment | The name of your resource. | 12.5 minutes per resource | Retries on 5xx errors, 50 retry requests
| Default request timeout | | Dependent on [UCP]({{< ref "architecture-concept#ucp-a-general-resource-management-api" >}}) |

### Resource provider behavior

#### Timeout duration

The default timeout times are listed below but be aware that the asynchronous timeout varies per resource type.

- Default synchronous API timeout : 60 seconds. It depends on UCP gateway timeout.
- Default asynchronous API timeout : 120 seconds

#### Asynchronous operation retry policy

Each resource type controller decides whether it will retry to process the operation when it fails, but the current async operation controller immediately marks any errors as a `Failed` operation except for the following scenario:

- Panic happens while processing the async operation by code defect (retry once, then mark the operation Failed)
- Resource provider process exits by unexpected process crashes (such as node failure, memory leak) and redeploying Radius. (retry once , then mark the operation Failed)

#### Applications.Core resource provider

| Resource Type  | Operation | API Type | Server Timeout (Seconds) | Async Operation retry condition|
|------|:--------:|-------------|---------|------------|
| Applications.Core/environments | LIST/GET/PUT/PATCH/DELETE | Synchronous | default | |
| Applications.Core/applications | LIST/GET/PUT/PATCH/DELETE | Synchronous | default | |
| Applications.Core/containers | LIST/GET | Synchronous | default | |
| Applications.Core/containers | PUT/PATCH/DELETE | Asynchronous | 300 | default |
| Applications.Core/gateways | LIST/GET | Synchronous | default | |
| Applications.Core/gateways | PUT/PATCH/DELETE | Asynchronous | default | default |
| Applications.Core/extenders | LIST/GET/PUT/PATCH/DELETE | Synchronous | default | |
| Applications.Core/extenders | POST ListSecret | Synchronous | default | |

#### Applications.Dapr resource providers

| Resource Type  | Operation | API Type | Server Timeout (Seconds) | Async Operation retry condition|
|------|:--------:|-------------|---------|------------|
| Applications.Dapr/pubSubBrokers | LIST/GET/PUT/PATCH/DELETE | Synchronous | default | |
| Applications.Dapr/pubSubBrokers | POST ListSecret | Synchronous | default | |
| Applications.Dapr/secretStores | LIST/GET/PUT/PATCH/DELETE | Synchronous | default | |
| Applications.Dapr/secretStores | POST ListSecret | Synchronous | default | |
| Applications.Dapr/stateStores | LIST/GET/PUT/PATCH/DELETE | Synchronous | default | |
| Applications.Dapr/stateStores | POST ListSecret | Synchronous | default | |


#### Applications.Datastores resource providers

| Resource Type  | Operation | API Type | Server Timeout (Seconds) | Async Operation retry condition|
|------|:--------:|-------------|---------|------------|
| Applications.Datastores/mongoDatabases | LIST/GET/PUT/PATCH/DELETE | Synchronous | default | |
| Applications.Datastores/mongoDatabases | POST ListSecret | Synchronous | default | |
| Applications.Datastores/rabbitMQMessageQueues | LIST/GET/PUT/PATCH/DELETE | Synchronous | default | |
| Applications.Datastores/rabbitMQMessageQueues | POST ListSecret | Synchronous | default | |
| Applications.Datastores/redisCaches | LIST/GET/PUT/PATCH/DELETE | Synchronous | default | |
| Applications.Datastores/redisCaches | POST ListSecret | Synchronous | default | |
| Applications.Datastores/sqlDatabases | LIST/GET/PUT/PATCH/DELETE | Synchronous | default | |
| Applications.Datastores/sqlDatabases | POST ListSecret | Synchronous | default | |

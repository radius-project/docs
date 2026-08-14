---
type: docs
title: "Reference: radius.core/applications@2025-08-01-preview"
linkTitle: "applications"
description: "Detailed reference documentation for radius.core/applications@2025-08-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

The `Radius.Core/applications` Resource Type represents a Radius Application: a logical grouping of the resources that make up a single Application, such as containers, databases, and message queues, along with the connections between them. Radius uses the Application to build the application graph, apply shared configuration, and manage its resources together throughout their lifecycle.

## Defining an Application

An Application is always deployed to a Radius Environment, which is supplied through the `environment` property. To define an Application, add a `Radius.Core/applications` resource to your application definition Bicep file.

```bicep
extension radius

@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string

resource myApp 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'my-app'
  properties: {
    environment: environment
  }
}
```

## Deploying an Application

An Application is deployed with the `rad deploy` command, which deploys the Application together with the resources that belong to it:

```bash
rad deploy ./app.bicep
```

## Adding resources to an Application

Resources are composed into an Application by setting their `application` property to the Application's ID. For example, to add a Container to this Application, add the following to the application definition Bicep file and set `application: myApp.id`:

```bicep
resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    environment: environment
    application: myApp.id
    containers: {
      frontend: {
        image: 'ghcr.io/my-org/frontend:latest'
      }
    }
  }
}
```

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `environment` | string | true | false | (Required) Fully qualified resource ID of the environment the application is deployed to |
| `provisioningState` | string | false | true | (Read Only) The status of the Application resource within the Radius control plane. Does not include the other resources that compose the Application.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `status` | [object](#status) | false | true | (Read Only) Deployment details for the Application, including any output resources Radius created for it. |

## Object Properties

### `status` {#status}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `compute` | [object](#status-compute) | false | false | The compute resource associated with the resource. |
| `outputResources` | [object](#status-outputresources)[] | false | false | Properties of an output resource |
| `recipe` | [object](#status-recipe) | false | true | The recipe data at the time of deployment |

### `status.compute` {#status-compute}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`aci`](#status-compute-aci), [`kubernetes`](#status-compute-kubernetes). |
| `identity` | [object](#status-compute-identity) | false | false | Configuration for supported external identity providers |
| `resourceId` | string | false | false | The resource id of the compute resource for application environment. |

### `status.outputResources` {#status-outputresources}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `id` | string | false | false | The UCP resource ID of the underlying resource. |
| `localId` | string | false | false | The logical identifier scoped to the owning Radius resource. This is only needed or used when a resource has a dependency relationship. LocalIDs do not have any particular format or meaning beyond being compared to determine dependency relationships. |
| `radiusManaged` | boolean | false | false | Determines whether Radius manages the lifecycle of the underlying resource. |

### `status.recipe` {#status-recipe}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `templateKind` | string | true | false | TemplateKind is the kind of the recipe template used by the portable resource upon deployment. |
| `templatePath` | string | true | false | TemplatePath is the path of the recipe consumed by the portable resource upon deployment. |
| `templateVersion` | string | false | false | TemplateVersion is the version number of the template. |

### `status.compute.identity` {#status-compute-identity}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | kind of identity setting<br />Allowed values: `azure.com.workload`, `systemAssigned`, `systemAssignedUserAssigned`, `undefined`, `userAssigned`. |
| `managedIdentity` | string array | false | false | The list of user assigned managed identities |
| `oidcIssuer` | string | false | false | The URI for your compute platform's OIDC issuer |
| `resource` | string | false | false | The resource ID of the provisioned identity |

### `status.compute.aci` {#status-compute-aci}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `resourceGroup` | string | false | false | The resource group to use for the environment. |

### `status.compute.kubernetes` {#status-compute-kubernetes}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `namespace` | string | true | false | The namespace to use for the environment. |

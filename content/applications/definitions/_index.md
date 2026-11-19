---
type: docs
title: "How to model an application definition"
linkTitle: "Model application resources"
description: "Learn how to model an application using Bicep and Radius Resource Types"
weight: 100
---

An application definition is a Bicep file that declares your [Application]({{< ref "/concepts/applications" >}}) and the resources it is made of. You model each resource with a [Resource Type]({{< ref "/concepts/resource-types" >}}), and Radius provisions the backing infrastructure when you deploy the file. This guide builds an `app.bicep` definition from an empty file, adds resources, and references dependencies between them.

When the definition is ready, see [How to deploy applications using Radius]({{< ref "/applications/deploy" >}}) to deploy it to an Environment.

## Step 1: Import the Radius extension

Create a Bicep file for your application and import the Radius Bicep extension. This guide uses `app.bicep`, but the file can have any name. The extension makes the Radius Resource Types available in Bicep:

```bicep
extension radius
```

The `radius` extension is configured in the `bicepconfig.json` created by `rad initialize`. If you have custom resource types to use, see [Add custom resource types to bicepconfig.json]({{< ref "/installation/dev-workstation#configure-bicepconfigjson" >}}).

## Step 2: Declare the Environment parameter

Every Application targets a Radius [Environment]({{< ref "/concepts/environments" >}}). Declare an `environment` parameter so the Radius CLI can supply the selected Environment's resource ID when you deploy:

```bicep
@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string
```

You do not set this value yourself. `rad deploy` passes the Environment from the current [Workspace]({{< ref "/management/workspaces" >}}), or from the `--environment` flag.

## Step 3: Define the Application resource

Declare a `Radius.Core/applications` resource to group the resources that make up your application. Set its `environment` property to the parameter:

```bicep
resource app 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'my-app'
  properties: {
    environment: environment
  }
}
```

The Application records the resources that belong to it and the relationships between them. Radius uses it to build the Application graph and to manage the resources together.

## Step 4: Add resources with Resource Types

Add the resources your application needs. Each resource uses a Resource Type and sets two properties that associate it with the Application:

- `environment` links the resource to the Radius Environment.
- `application` links the resource to the Application, using the Application's `.id`.

The following example adds a container that runs the application's front end:

```bicep
resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    environment: environment
    application: app.id
    containers: {
      web: {
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

Referencing `app.id` creates a symbolic dependency, so Radius creates the Application before the container.

## Step 5: Choose the right Resource Type

Model each part of your application with the Resource Type that best represents it. Radius ships with a set of [out-of-the-box Resource Types]({{< ref "/reference/resources" >}}) for compute, data, messaging, and more, and your platform team can publish [custom Resource Types]({{< ref "/extensibility/resource-types" >}}) for anything specific to your organization.

- Browse the [Resource Types reference]({{< ref "/reference/resources" >}}) for each type's properties, API versions, and examples.
- List the types installed in your control plane with [`rad resource-type list`]({{< ref rad_resource-type_list >}}), or browse them in the [Radius Dashboard]({{< ref "/installation/dashboard" >}}).

The Environment's [Recipe Packs]({{< ref "/concepts/recipe-packs" >}}) must contain a recipe for every Resource Type your definition uses. Without a matching recipe, the deployment fails because Radius does not know how to provision that resource.

## Step 6: Parameterize the definition

Use Bicep parameters for values that change between Environments or deployments, such as an image tag or a resource size. Parameters keep a single definition reusable across `dev`, `test`, and `prod`:

```bicep
@description('Container image tag to deploy.')
param imageTag string = 'latest'

resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    environment: environment
    application: app.id
    containers: {
      web: {
        image: 'ghcr.io/radius-project/samples/demo:${imageTag}'
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

Supply parameter values at deploy time with `--parameters`, or store them in a `.bicepparam` file. Keep the `environment` parameter as is; the Radius CLI supplies it automatically.

## Next steps

With the resources modeled, connect them together to model dependencies within the Application.

{{< button text="Next step: How to model application dependencies using connections" page="/applications/connections" >}}

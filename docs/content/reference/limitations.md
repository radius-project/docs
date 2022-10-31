---
type: docs
title: "Known issues and limitations with the latest Radius release"
linkTitle: "Limitations"
description: "Learn where there are known issues and limitations with the latest Radius release and how to work around them"
weight: 998
---

## Radius control plane

### `rad install kubernetes` and `rad env init kubernetes` installs Dapr and Contour in addition to Radius

Dapr and Contour are also both installed into the `radius-system` namespace to help get you up and running quickly for our quickstarts and tutorial. This is a point-in-time limitation that will be addressed with richer environment customization in a future update.

While Contour is required for Radius gateways and routes, you can manually delete the [Dapr Helm chart](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-deploy/#uninstall-dapr-on-kubernetes) if you do not use Dapr.

## Radius resources

### Resource names must be unique for a given resource type across applications

Resources for a given type must currently have unique names within a [workspace]({{< ref workspaces >}}. For example, if two applications both have a `frontend` container resource, the first application deployment into any environment associated with the workspace will succeed while the second will fail.

As a workaround, use separate workspaces for applications that have repeated resource names for a given type.

This will be addressed further in a future release.

## Bicep & Deployment Engine

### Currently using a forked version of Bicep

While Project Radius is still in the private preview stage, a fork of the Bicep compiler is being used while the Radius team works with the Bicep team and community to build in the proper support to move back into the primary version. This results in:

- The "Bicep" VS Code extension must be disabled in favor of the "Bicep (Project Radius)" extension
- The forked Bicep compiler will be out of date compared to the most recent Bicep public build
- `az bicep` and `bicep` are not supported with Project Radius. Use `rad deploy` instead.

To use the forked build of Bicep directly, you can reference `~/.rad/bin/rad-bicep` (Linux/macOS) or `%HOMEPATH%\.rad\bin\rad-bicep.exe` (Windows).

### Loops are not supported

The Bicep deployment engine does not currently support loops in Bicep. Instead, manually unroll your loops until a fix is deployed.

Refer to https://github.com/project-radius/deployment-engine/issues/172 for more information.

### `environment()` Bicep function collides with `param environment string`

We currently use `param environment string` to pass in the Radius environmentId into your Bicep template. This collides with the Bicep `environment()` function.

To access `environment()`, prefix it with `az.`. For example:

```bicep
import radius as rad

param environment string

var stgSuffixes = az.environment().suffixes.storage
```

This will be addressed in a future release when we change how the environmentId is passed into the file.

## Containers

### Persistent volumes are not supported

Persistent volumes, which are required to mount an Azure Key Vault or an Azure File Share to a Radius container, are not supported in the current version of Radius. This will be addressed in a future release.

## rad CLI

### Application and resource names are lower-cased after deployment

After deploying an application with application name `AppNAME` and container name `CONTAINERname`, casing information about the casing is lost, resulting in names to be lower-cased. The result is:
  
```bash
rad application list
RESOURCE           TYPE
appname            applications.core/applications

rad resource list containers -a appname
RESOURCE                 TYPE
containername            applications.core/containers
```

### Cannot use underscores in resource names

Using an underscore in a resource name will result in an error.

As a workaround do not use underscores in resource names. Additional validation will be added in a future release to help warn against improperly formatted resource names.

See [app name constraints]({{< ref "resource-schema.md#common-values" >}}) for more information.

### Environment creation and last modified times are incorrect

When running `rad env show`, the `lastmodifiedat` and `createdat` fields display `0001-01-01T00:00:00Z` instead of the actual times.

This will be addressed in an upcoming release.

### Environment creation on EKS fails with default values

When running `rad env init kubernetes` on an EKS cluster, the default environment name for EKS is invalid with current env name requirements.

As a workaround, run `rad env init kubernetes -i`. As part of the init prompts, provide a custom name with only alphanumeric/hyphen characters:

```
❯ rad env init kubernetes -i
...
Enter an environment name [arn:aws:eks:region:account:cluster/mycluster]: mycluster
```

This will be addressed in an upcoming release.

## Links

### Dapr resources have application name prefixed to component name

When a user specifies a Dapr component in a resource, the component name is prefixed with the application name. For example, the following Bicep code:

```bicep
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
   name: 'myapp'
}

resource statestore 'Applications.Link/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  location: 'global'
  properties: {
    application: app.id
  }
}
```

results in a Dapr component named 'myapp-statestore'.

In order to consume this Dapr resource from a container, either use the environment variable injected into the container (`CONNECTION_STATESTORE_NAME`), or manually craft an environment variable with `'${app.name}-${statestore.name}'`.

## Connections

### Direct connections to Azure resources with IAM roles are not supported

Managed identity support for AKS clusters is not currently supported. This will be addressed in a future release.

As a workaround, manually enable AKS pod identity and assign RBAC assignments to the target resources vis the Azure portal or via the az CLI. See the [Azure docs](https://docs.microsoft.com/azure/aks/use-azure-ad-pod-identity) for more information.

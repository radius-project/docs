---
type: docs
title: "Known issues and limitations with the latest Radius release"
linkTitle: "Limitations"
description: "Learn where there are known issues and limitations with the latest Radius release and how to work around them"
weight: 998
---

## Radius control plane

### `rad install kubernetes` and `rad init` installs Contour in addition to Radius

Contour is also installed into the `radius-system` namespace to help get you up and running quickly. This is a point-in-time limitation that will be addressed with richer environment customization in a future update.

## Radius resources

### Resource names must be unique for a given resource type across applications

Resources for a given type must currently have unique names within a [workspace]({{< ref workspaces >}}). For example, if two applications both have a `frontend` container resource, the first application deployment into any environment associated with the workspace will succeed while the second will fail.

As a workaround, use separate workspaces for applications that have repeated resource names for a given type.

This will be addressed further in a future release.

### Changing the Kubernetes namespace of an environment or application requires the app to be deleted and redeployed

A Radius Environment allows you to specify Kubernetes as your compute platform, as well as specify the Kubernetes namespace in which Kubernetes objects are deployed. Additionally, you can override the namespace for a specific application using the [kubernetesNamespace extension.]({{< ref "application-schema#kubernetesNamespace" >}}). Currently, changing the namespace of an environment or application requires the application to be deleted and redeployed. If you need to change the namespace of an application, you can do so by deleting the application and/or environment and redeploying it with the new namespace.

### Resource names cannot contain underscores (_)

Using an underscore in a resource name will result in an error.

As a workaround do not use underscores in resource names. Additional validation will be added in a future release to help warn against improperly formatted resource names.

See [app name constraints]({{< ref "resource-schema.md#common-values" >}}) for more information.

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

### Environment creation and last modified times are incorrect

When running `rad env show`, the `lastmodifiedat` and `createdat` fields display `0001-01-01T00:00:00Z` instead of the actual times.

This will be addressed in an upcoming release.

## Recipes

### Kubernetes Bicep resources require manual UCP ID output

The Bicep deployment engine currently does not output Kubernetes resource (UCP) IDs upon completion, meaning Recipes cannot automatically link a Recipe-enabled resource to the underlying infrastructure. This also means Kubernetes resources are not automatically cleaned up when a Recipe-enabled resource is deleted.

To fix this, you can manually build and output UCP IDs, which will cause the infrastructure to be linked to the resource:

```bicep
import kubernetes as k8s {
  kubeConfig: ''
  namespace: 'default'
}

resource deployment 'apps/Deployment@v1' = {...}

resource service 'core/Service@v1' = {...}

output values object = {
  resources: [
    // Manually build UCP IDs (/planes/<PLANE>/local/namespaces/<NAMESPACE>/providers/<GROUP>/<TYPE>/<NAME>)
    '/planes/kubernetes/local/namespaces/${deployment.metadata.namespace}/providers/apps/Deployment/${deployment.metadata.name}'
    '/planes/kubernetes/local/namespaces/${service.metadata.namespace}/providers/core/Service/${service.metadata.name}'
  ]
}
```

## Bicep & Deployment Engine

### Currently using a forked version of Bicep

Radius is currently using a forked version of Bicep compiler to support Radius specific features. This is a point-in-time limitation that will be addressed in the future as the Radius team works with the Bicep team and the community to upstream the extensibility updates. This results in the following limitations:

- The "Bicep" VS Code extension must be disabled in favor of the "Radius Bicep" extension
- The forked Bicep compiler will be out of date compared to the most recent Bicep public build
- `az bicep` and `bicep` are not supported with Radius. Use `rad deploy` instead.

To use the forked build of Bicep directly, you can reference `~/.rad/bin/rad-bicep` (Linux/macOS) or `%HOMEPATH%\.rad\bin\rad-bicep.exe` (Windows).

### `environment()` Bicep function collides with `param environment string`

We currently use `param environment string` to pass in the Radius environmentId into your Bicep template. This collides with the Bicep `environment()` function.

To access `environment()`, prefix it with `az.`. For example:

```bicep
import radius as rad

param environment string

var stgSuffixes = az.environment().suffixes.storage
```

This will be addressed in a future release when we change how the environmentId is passed into the file.

### Radius Bicep AWS limitations

Some of the [AWS resource types](/resource-schema/aws) are 'non-idempotent', this means that this resource type is assigned a primary identifier at deployment time and is currently not supported by Radius Bicep.

We are currently building support for non-idempotent resources in Radius. Please like and comment on this [this issue](https://github.com/radius-project/radius/issues/6227) if you are interested in the same.

As a workaround, you can try using [Terraform Recipes]({{< ref "/guides/recipes/overview" >}}) to deploy and manage those non-idempotent resource types.



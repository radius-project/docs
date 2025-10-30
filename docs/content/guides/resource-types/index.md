---
type: docs
title: "Resource Types Guide"
linkTitle: "Resource Types"
description: "Guide to defining and using Resource Types"
weight: 200
---

Radius Resource Types are the building blocks of Radius. They represent the various types of resources that developers use to build their applications. Radius ships with a number of common Resource Types including containers, secrets, and various databases. But the power of Resource Types is that they can model anything that can be deployed with Infrastructure as Code (IaC). A Resource Type can be a low-level application component such as a log collector or a high-level, abstract component such as a web service. 

This guide will discuss the details of how to define Resource Type and make it available to developers. Remember that Resource Types are only the abstraction, or interface, and not the implementation. The TODO **<u>Recipe guide</u>** TODO goes into details on defining how a Resource Type actually gets deployed.

## What is a Resource Type?

As discussed in the [Concepts]({{< ref "concepts" >}}) page, Resource Types define the abstraction for a resource that will be deployed to a cloud environment. They are:

* **Abstract** in that they do not represent a specific resource that gets deployed, but rather a generalization of a type of resource. 
* **Application oriented** because developers use these resource types to compose their applications
* **Infrastructure agnostic** because developers should not have to be infrastructure experts.
* **Cloud provider agnostic** because one of the goals of using Radius is to ensure portability of applications.

Here are some example resource types which follow these guidelines and ones that do not:

| ✅ Good Examples     | 🚫 Bad Examples                |
| ------------------- | ----------------------------- |
| Container           | Pod                           |
| PostgreSQL database | Azure Database for PostgreSQL |
| Secret              | Hashicorp Vault secret        |
| Environment         | Virtual network               |

## Sources of Resource Types

There is a wide selection of Resource Types available for use, plus, creating your own is very easy.

* **Out of the box**: Radius ships with several Resource Types out of the box including Resource Types for containers and several common databases. After installing Radius, it's easy to see the out-of-the-box Resource Types in the Dashboard or via `rad resource-type list`. 
* **Community maintained**: The Radius project maintains the [`resource-types-contrib`](https://github.com/radius-project/resource-types-contrib/) repository on GitHub which includes many additional Resource Types and associated Recipes. 
* **Custom**: Creating your own Resource Types is very easy and low maintenance. The tutorial demonstrated creating a PostgreSQL Resource Type. This guide will do into more depth in defining a new Resource Type.

## Anatomy of a Resource Type

A Resource Type is defined in a Resource Type definition YAML file with four components:

* **Namespace**: A logical grouping of Resource Types. The convention used by Radius is to set the namespace to `Radius.<Category>`. For example: `Radius.Data/*` or `Radius.Security/*`. 

* **Name**: The name of the Resource Type can be anything but is typically formatted using camelCase and is plural. For example: `redisCaches`, `sqlDatabases`, or `rabbitMQQueues`.

* **Description**: This is the developer documentation for your organization. It is written in Markdown format and appears in the Dashboard. This is a large blob of text where you can write anything that is helpful for your developers. Examples and support email addresses are common.

* **API version**: Each Resource Type can have multiple API versions labeled with a date, and an optional `-preview` suffix. For example: `2025-10-29-preview`.  If material changes to the schema are needed, a new API version should be created to ensure backward compatibility. 

* **Schema**: Each API version has an OpenAPI schema which defines:

  * Required properties
  * Optional properties
  * Read-only properties (also referred to as output properties)
  * Developer documentation for each property
  * Data validation rules such as enums

## Defining a Resource Type

This section of the guide will demonstrate defining the Containers Resource Type starting very basic and building up with increasing complexity. Throughout this guide, example Resource Type definitions that a platform engineer would define will be shown. Accompanying each Resource Type definition is a corresponding example of how a developer would use that Resource Type in their application definition Bicep file, however these examples are collapsed for brevity.

### A bare minimum Containers Resource Type

The bare minimum for a Containers Resource Type would be:

```
namespace: Radius.Compute
types:
  containers:  
    apiVersions:
      '2025-08-01-preview':
        schema: 
          type: object
          properties:
            environment:
              type: string
            application:
              type: string
            container:
              type: object
              properties:
                image:
                  type: string
```

{{< collapsible-code text="developer example" >}}
resource myContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'my-container'
  properties: {
    environment: environment
    application: myApplication.id
    container: {
      image: 'nginx'
    }
  }
}
{{< /collapsible-code >}}

The `schema` property has three properties: `environment`, `application`, and `container`. The `environment` and `application` properties are strings. These two properties are on every Resource Type since they allow the resource to be part of an application and deployed to an environment. The `container` property will ultimately have many child properties so it is an object. Right now, it only has an `image` string property defining what container image to use.

### Adding an array

Containers typically have an array of strings property called `command` and `args`. Developers specify what command the container should run when it starts up, specified as an array of strings. An `command` array property is modeled like:

```
command:
  type: array
  items:
    type: string
args:
  type: array
  items:
    type: string
```

`command` and `args` are simple arrays of strings. A more complex example is `volumeMounts` which has multiple child properties:

```
volumeMounts:
  type: array
  items:
    type: object
      properties:
        volumeName:
          type: string
        mountPath:
          type: string
```

{{< collapsible-code text="developer example" >}}
resource myContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'my-container'
  properties: {
    environment: environment
    application: myApplication.id
    container: {
      image: 'nginx'
      command: ['/bin/sh', ''-c']
      args:  ['nginx', '-g', 'daemon off;']
      volumeMounts: [
        {
          volumeName: 'shared'
          mountPath: '/var/shared'
        }
      ]
    }
  }
}
{{< /collapsible-code >}}


### Maps versus Arrays

Maps and arrays are both collections, however, maps have a key and a value. In the previous example, `volumeMounts` was defined as an array of objects. Each item in `volumeMounts` has a `volumeName`. Let's define the `volumes` property as a map:

```
volumes:
  type: object
  additionalProperties:
    type: object
    properties:
      persistentVolume:
        type: object
        properties:
          resourceId:
            type: string
          accessMode:
            type: string
          secretId:
            type: string
          emptyDir:
            type: object
              properties:
                medium:
                  type: string
```

Rather than `items` as in the array type, the `volumes` map has `additionalProperties` which indicates it is a map. 

{{< collapsible-code text="developer example" >}}
resource myContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'my-container'
  properties: {
    ...
    container: {
      frontend: {
        image: 'frontend:latest'
        volumeMounts: [             // an array so items are in []
          {
            volumeName: 'shared'
            mountPath: '/var/shared' 
          }
        ]
      }
      volumes: {                    // a map with a single item with a key named 'shared'
        shared: {
          emptyDir: {}
        }
      }
    }
  }
}
{{< /collapsible-code >}}

In addition to `volumes` the `container` property should also be a map so that multiple containers can be deployed at once. In the subsequent examples, you will see that `container` has been renamed `containers` and is now a map.

### Required properties

Properties can be designated as required using the `required` array property on an object. Let's make the `containers.image` property required:

```
namespace: Radius.Compute
types:
  containers:  
    apiVersions:
      '2025-08-01-preview':
        schema: 
          type: object
          properties:
            environment:               // Required
              type: string
            application:               // Required
              type: string
            containers:                // Required
              type: object
              additionalProperties:
                type: object
                properties:
                  image:               // Required
                    type: string
                  command:             // Optional
                    type: array
                    items:
                      type: string
                  args:                // Optional
                    type: array
                    items:
                      type: string
                required: [image]
          required: [environment, application, containers]
```

In this example, the top level `environment`, `application`, and `containers` properties are required to be set. Within `containers`, only the `image` property is required. `command` and `args` are optional.

But what if a property is optional but it has child properties which are required, but only if the parent is specified? Let's go back to the `volumes` property and add the required properties.

```
volumes:
  type: object
  additionalProperties:
    type: object
    properties:
      persistentVolume:                         // Optional
        type: object
        properties:
          resourceId:
            type: string
          accessMode:
            type: string
        required: [resourceId, accessMode]      // Required when persistentVolume is specified
      secretId:                                 // Optional
        type: string
      emptyDir:                                 // Optional
        type: object
        properties:
          medium:
            type: string
```

In the `volumes`, the `persistentVolume` property is optional, but if a `persistentVolume` is specified, then `resourceId`, and `accessMode` are required.

### Enums

Enums help by telling developers what the valid values are for a property. Let's add a `restartPolicy` property to the Containers Resource:

```
restartPolicy:
  type: string
  enum: [Always, OnFailure, Never]
```

When developers are defining their applications and have the Bicep extension for VS Code installed, Intellisense provide the developer with the valid values as shown in the screenshot below.

{{< image src="enum-vs-code.png" width="70%" alt="Screenshot of VS Code showing enums" >}}

### Read-only properties

Read-only properties are properties that are set by the Recipe when the resource is deployed. In IaC solutions, these properties are often called *outputs*. When defining a Resource Type, consider what information a developer needs in order to use the deployed resource. Most often this information is connection information such as hostnames and/or credentials. 

In the case of the Containers Resource Type, we will define a read-only property for the fully-qualified domain name for the service that is created when exposing a container port.

```
serviceFQDN:
  type: string
  readOnly: true
```

### Developer documentation

It is important to that Resource Types are well documented for developers. The best practice is to provide long-form developer documentation with examples using the top-level `description` property, and documenting each property. The top-level `description` property should include documentation on how and when to use the Resource Type and multiple examples on using the Resource Type in an application definition Bicep file. The text should be in Markdown format.

For example, the Containers Resource Type developer documentation looks like this snippet:

```
namespace: Radius.Compute
types:
  containers:
    description: |
      The Radius.Compute/containers Resource Type is the primary resource type for 
      running one or more containers. It is always part of a Radius Application. 
      To deploy a Container add a resource to the application definition Bicep file.

      ```
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
...
```

Notice that the example Bicep is in enclosed in a code block.

In addition to the top-level `description` property, each property should be documented as well.

```
...
apiVersions:
  '2025-08-01-preview':
    schema: 
      type: object
      properties:
        environment:
          type: string
          description: (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`.
        application:
          type: string
          description: (Required) The Radius Application ID. `myApplication.id` for example.
...
```

The description includes whether the property is Required, Optional, or Read-only to make the type more obvious in VS Code.

## Creating Resource Types

The final Containers Resource Type incorporating all the techniques demonstrated in this guide is available in the [`resource-types-contrib`](https://github.com/radius-project/resource-types-contrib/blob/main/Compute/containers/containers.yaml) repository on GitHub.

Creating this Resource Type in Radius requires three actions:

1. Creating the Resource Type in the Radius control plane
1. Creating a Bicep extension
1. Creating a bicepconfig.json

Resource Types can be created in Radius using the [`rad resource-type create`]({{< ref "rad_resource-type_create" >}}) command.

In order for the Radius CLI and Bicep extension for VS Code to understand the structure of a Resource Type, a Bicep extension must be created using the [`rad bicep publish-extension`]({{< ref "rad_bicep_publish-extension" >}}) command. The `--target` argument can be either:

* Azure Container Registry
* A local disk or file share

Once the extension is published, the `bicepconfig.json` file on each developer workstations must be updated. For example, if the Bicep extension was published using this command:

```
$ rad bicep publish-extension --from-file containers.yaml --target br:my-company.azurecr.io/containers:latest
```

The bicepconfig.json file should be:

```
{
    "extensions": {
        "radius": "br:biceptypes.azurecr.io/radius:latest",
        "containers": "br:my-company.azurecr.io/containers:latest"
    }
}
```


<br>
<br>
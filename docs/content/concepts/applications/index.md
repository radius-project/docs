---
type: docs
title: "Applications Concepts"
linkTitle: "Applications"
description: "How Radius manages applications"
weight: 40
---

A Radius Application is a resource that is a parent to other resources that make up the application. Radius typically operates on Applications rather individual resources. For example, developers deploy Applications rather than individual resources. Operators and SREs view an Application's deployed resources or view an Application's dependencies. Applications and its resources are defined in an application definition file using the Bicep Infrastructure as Code (IaC) language. 

## Resources

Each application definition file contains an Application resource and a set of application resources such as databases, secrets, and traffic ingress routes. The Application resource itself is simply a parent to the resources defined within the definition file. It has no properties except for the application name. The remainder of the resources are any of the Resource Types that have been created within the Radius control plane.

## Connections

Connections is a unique capability of Radius and enables developers to express a relationship between resources. Connecting two resources has several effects:

- Radius creates an edge in the application graph stored within the Radius control plane.
- If the Resource Type is a Container, environment variables are automatically created for each connected resource's properties.
- The connected resource and its properties are added to the Recipe `context` object under `context.resource.connections.<connected-resource-name>`.

For example, if a Container resource needs a database, a connection may be added by the developer using:

```
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: todolist.id
    container: { ... }
    connections: {
      postgresql: {
        source: postgresql.id
      }
    }
  }
}
```

In this case, the connection name is `postgresql` and the connection is between the frontend container and the PostgreSQL database resource (not pictured). Since the PostgreSQL Resource Type has `host`, `port`, and `username` property, environment variables within the container are automatically created for those properties:

- `CONNECTION_POSTGRESQL_HOST`
- `CONNECTION_POSTGRESQL_PORT`
- `CONNECTION_POSTGRESQL_DATABASE`
- `CONNECTION_POSTGRESQL_USERNAME`

If the connection name was `db` instead of `postgresql` the environment variable would have been `CONNECTION_DB_HOST`.

## The application graph

Radius maintains a graph of all resources. Resources are the nodes in the graph and connections are the edges. When a resource is defined within an application definition file, each of those resources are added to the graph when deployed. If resources belong to the same Application or Environment, they have an edge between them. If a connection is defined between two resources, those resources also get an edge.

But the application graph is not just resources defined by the developer. Deployed resources are also part of the graph. For example, if a developer defines an application with a Container and a PostgreSQL resource, the recipes for those Resource Types will create several deployed resources. The resulting application graph may look similar to:

- Environment
  - Application
    - Container
      - Kubernetes Deployment
      - Kubernetes Service
      - Kubernetes Secret
      - Kubernetes ServiceAccount
      - Kubernetes Role
      - Kubernetes RoleBinding
    - PostgreSQL database
      - Kubernetes Deployment
      - Kubernetes Service

The application graph allows developers to understand what resources got deployed even when they defined their application using high-level Resource Types. It also allows operators and SREs to easily understand what application a deployed resource belongs to. 

<br>
{{< button text="Next step: Complete the tutorial" page="tutorials" >}}

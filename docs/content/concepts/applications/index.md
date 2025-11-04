---
type: docs
title: "Applications Concepts"
linkTitle: "Applications"
description: "How Radius manages applications"
weight: 40
aliases:
    - /content/guides/author-apps/applications
---

A Radius Application is a resource that is a parent to other resources that make up the application. Applications and its resources are defined in an application definition file using the Bicep Infrastructure as Code (IaC) language. Since applications are a first-class Resource Type in Radius, developers perform operations on applications rather than individual resources. When deploying resources, developers simply deploy the Application. Radius also tracks all deployed resources and their dependencies in a graph. Developers can add to the graph by expressing explicit dependencies such as a container relying on a database.

## Resources

Each application definition file contains an Application resource and a set of application resources such as databases, secrets, and traffic ingress routes. The Application resource itself is simply a parent to the resources defined within the definition file. It has no properties except for the application name. The remainder of the resources are any of the Resource Types that have been created within the Radius control plane.

## The application graph

Radius maintains a graph of all resources. Resources are the nodes in the graph and connections are the edges. When a resource is defined within an application definition file, each of those resources are added to the graph when deployed. If resources belong to the same Application or Environment, they have an edge between them.

The application graph is not just resources defined by the developer. Deployed resources are also part of the graph. For example, if a developer defines an application with a Container and a PostgreSQL resource, the recipes for those Resource Types will create several deployed resources. The resulting application graph may look similar to:

{{< image src="app-graph.png" alt="Application graph" >}}

Application graph data can be visualized in the Dashboard, via the `rad application graph` command, or via the Radius API. By enabling developers and SREs to better understand the what resources got deployed, and the dependencies between those resources and other applications, the application graph is useful for operational and troubleshooting purposes.

## Connections

Radius builds the application graph dynamically based on the resources that get deployed. A connection is a method of manually adding an edge to the graph to explicitly express a relationship between two resources. Connecting two resources has several effects:

- Radius creates an edge in the application graph stored within the Radius control plane.
- If the Resource Type is a Container, environment variables are automatically created for each connected resource's properties.
- The connected resource and its properties are added to the Recipe `context` object under `context.resource.connections.<connected-resource-name>`.

Building on the previous example, a connection can be added between the frontend and the database.

{{< image src="app-graph-w-connection.png"  alt="Application graph with connection" >}}

In this example, the connection name is `postgresql` and the connection is specified on the frontend container. The *source* of the dependency is the PostgreSQL database. Since the PostgreSQL Resource Type has `host`, `port`, and `username` properties, environment variables within the container are automatically created for those properties:

- `CONNECTION_POSTGRESQL_HOST`
- `CONNECTION_POSTGRESQL_PORT`
- `CONNECTION_POSTGRESQL_DATABASE`
- `CONNECTION_POSTGRESQL_USERNAME`

If the connection name was `db` instead of `postgresql` the environment variable would have been `CONNECTION_DB_HOST`.

<br>
{{< button text="Next step: Complete the tutorial" page="tutorials" >}}

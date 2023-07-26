---
type: docs
title: Radius Application Graph
linkTitle: Application graph
description: Learn how the Radius application graph allows you to model your entire application
weight: 200
---

## Radius applications

Radius offers an [application resource]({{< ref "/author-apps/application" >}}) which teams can use to define and deploy their entire application, including all of the compute, relationships, and infrastructure within in. Since Radius applications are defined as a graph of relationships between deployed resources, it enables more advanced visualizations than simply a list of resources.

<img src="application.png" alt="A diagram showing an application and all it's resources" width=400px >

## Graphs are better than lists

Within an application deployed with Radius, developers can express both the resources (_containers, databases, message queues, etc._), as well as all the relationships between them. This forms the Radius application graph. This graph is powerful because it allows Radius to understand the relationships between resources, and automate the deployment and configuration of your application. Plus, it allows you to visualize your application in a way that is more intuitive than a list of resources.

<img src="list-to-graph.png" alt="A diagram showing the move from a set of infrastructure lists to a graph of resources" width=600px >

## Automate your application deployment

Because Radius now has all the relationships and requirements of an application, it can be deployed and configured automatically. Developers no longer need to specify all the identity, networking, or other configuration that is normally required, and operators don’t need to write custom deployment scripts.

For example, if you want a container to read from an Azure Storage Account without using Radius, this normally requires creating managed identities, RBAC roles, identity federation, Kubernetes service accounts, and more. With Radius, developers can define a single connection from their container to a Storage Account, and Radius sets up all the required configuration automatically.

<img src="graph-automation.png" alt="A diagram showing a connection from a Radius container to an Azure storage account resulting in managed identities, role-based access control, and CSI drivers." width=600px >

## Self-documenting applications

The Radius application graph also allows your application to be self-documenting, where developers and operators can query and reason about the same application definition. Instead of multiple views of logs, infrastructure, and code, Radius provides a single source of truth for your application.

<img src="dashboard.png" alt="A mockup of a dashboard UI showing an application, its resources, and its connections" width=700px >

> **Note:** A Radius dashboard is still on the roadmap, but in the meantime you can use the [Radius API]({{< ref api-concept >}}) to build your own visual experiences today.

## Mine the app graph API

The Radius application graph is also exposed as an API, allowing you to build your own visualizations, workflows, and more on top of Radius. Learn more in the [API docs]({{< ref api-concept >}}).

For example, I can get the status of my `frontend` container, and get its definition and its connections to other resources:

```bash
GET /planes/radius/local/resourceGroups/default/providers/Applications.Core/containers/frontend
```

```
{
  "name": "frontend",
  "type": "Applications.Core/containers"
  "id": "/planes/radius/local/resourceGroups/default/providers/Applications.Core/containers/frontend",
  "properties": {
    "container": {
      "image": "nginx:latest",
      "env": {...},
      "ports": {...},
    },
    "environment": "myenvironment",
    "application": "myapp"
  },
  "connections": {
      "backend": {
        "source": "/planes/radius/local/resourceGroups/default/providers/Applications.Core/containers/backend",
      },
      "storage": {
        "source": "/planes/azure/subscriptions/ee3dbd5a-68b4-4eea-bc48-f064009e6ff9/resourceGroups/myrg/providers/Microsoft.Storage/storageAccounts/mystorage",
        "iam": {
          "kind": "azure",
          "roles": [
            "Storage Blob Data Reader"
          ]
        }
      }
    },
}
```

## Next step

Now that you have an understanding of the Radius app graph, learn how you can deploy Radius applications to prepared landing zones with Radius Environments:

{{< button text="Radius Environments" page="environments-concept" color="success" >}}

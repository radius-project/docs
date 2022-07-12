---
type: docs
title: Overview for Project Radius 
linkTitle: Overview
description: Learn how Project Radius fits into the app development landscape and it's long-term vision
weight: 100
---

## Building cloud-native apps is too difficult today

App teams today struggle to model and deploy their applicatations. Complex architectures, cross-platform portability requirements, and org-level best-practices all make it difficult to not only model and deploy, but also maintain and troubleshoot large applications.

Apps today are modeled and deployed with Dockerfiles, Kubernetes CRDs, Helm charts, and infrastructure-as-code templates, with scripts to glue it all together. Plus, the range of infrastructure types (cloud, on-premises, serverless) can double or triple the work as teams figure out how to move apps between platforms.

<img alt="Diagram showing all of the technologies needed to model an application today" src="cloud-apps-today.png" width="600px" />

Once deployed, teams don't have a way to view and manage apps holistically. Instead, they're drowning in lists of disjointed resources.

<img alt="Diagram showing long list of infrastructure" src="ui-mockup-list.png" width="800px" /><br />

What's missing is a way to collapse the entire concept of an application into a single entity so it can be deployed, managed, and scaled easily.

## Project Radius empowers teams to focus on their apps

### Build a unified concept of your application

At the heart of Project Radius is a new **application resource**, with an accompanying set of resources and abstractions to describe your app's requirements and capabilities. These resources form the [Radius app model]({{< ref appmodel-concept >}}).

<img alt="Diagram showing modeling an app with Project Radius" src="cloud-apps-radius.png" width="600px" />

These new resources form the **Radius app model**, which allow you to:

- Visualize the entire application, including its dependencies and relationships
- Investigate cross-app health and diagnostics, including dependencies and connections
- Identify ownership and locate artifacts
- Support handoffs between teams as the app matures

The result is no longer just a flat list of resources - it's a fully fledged diagram of how the pieces relate to each other:

<img alt="Diagram showing Radius application in the Azure portal" src="ui-mockup-basic.png" width="700px" /><br />

### Drastically reduce infra ops time

[App environments]({{< ref environments-concept >}}) act as a landing zone for applications. They are the place where you can deploy, manage, and scale your apps.

<img alt="Diagram showing Radius environments" src="environments.png" width="600px" />

Environments allow you to:

- Iterate quickly in a local dev environment, then scale that same app up in Azure or Kubernetes environment
- Stamp out versions of the app to the edge, to multiple geos, or even to multiple clouds
- Follow best practices to be naturally secure by default, even with many teams working together
- Easily layer IT policies across an app (access, backup, ...)

### Model applications as code

With the Radius app model, teams can easily codify and share pieces of an application. For example, a database owned by one team can seamlessly connect to a container with app code owned by a second team.

{{< tabs Bicep >}}

{{< codetab >}}
{{< rad file="snippets/appmodel-concept.bicep" embed=true >}}
{{< /codetab >}}

{{< /tabs >}}

Radius uses the [Bicep language]({{< ref bicep >}}) as its file-format and structure. It offers:

- A high quality authoring experience with modules, loops, parametrization, and templating
- ARM Deployment Stacks as the declarative deployment/rollback mechanism
- Ability to punch through abstractions to platform when necessary
- Extensions to work with other providers (e.g. Kubernetes, Azure Active Directory, etc.)

## Platform strategy

Project Radius aims to support all hosting platform types - from hyperscale cloud, to self-hosted Kubernetes on the edge, to IoT and edge devices.

<img alt="Diagram showing Radius platforms" src="platforms.png" width="800px" />

Our current focus is on delivering robust support for self-hosted environments on Kubernetes. Fully-managed environments on Azure will be supported in the future.

## Next step

Now that you have an overview of Project Radius, learn more about the Radius app model:

{{< button text="Learn about the app model" page="appmodel-concept" size="btn-lg" color="success" >}}

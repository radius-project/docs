---
type: docs
title: Overview for Project Radius 
linkTitle: Overview
description: How Project Radius fits into the app development landscape and the long-term vision for its offerings. 
weight: 100
---

## Cloud-native apps are too difficult today. 

App developers don't have a way to view and manage apps holistically. Instead, they're drowning in lists of disjointed resources and connector information, Helm charts to pass around parameter values, and bash scripts to contain the logic needed to deploy the app. Plus, the range of infrastructure types (cloud, on-premises, serverless) can double or triple the work as teams figure out how to move apps between platforms. 

What's missing is a way to collapse the entire concept of an application into a single entity so it can be deployed, managed, and scaled easily.

## Project Radius empowers app developers to do more.

{{< cardpane >}}

{{< card header="**Build a unified concept of your application**" >}}
- Visualize the end-to-end app model. 
- Investigate cross-app health and diagnostics, including dependencies and connections. 
- Identify ownership and locate artifacts per component. 
- Support handoffs between teams as the app matures. 
{{< /card >}}

{{< card header="**Drastically reduce infra ops time**" >}}
- Iterate quickly in a local dev environment, then scale that same app up in Azure or Kubernetes.
- Stamp out versions of the app to the edge, to multiple geos, or even to multiple clouds. 
- Follow best practices to be naturally secure by default, even with many teams working together. 
- Easily layer IT policies across an app (access, backup, ...).
{{< /card >}}

{{< /cardpane >}}


## Applications as code

With the Radius app model, teams can easily codify and share pieces of an application. For example, a database owned by one team can seamlessly connect to a container with app code owned by a second team.  
{{< rad file="snippets/appmodel-concept.bicep" embed=true >}}

The result is no longer just a flat list of resources - it's a fully fledged diagram of how the pieces relate to each other.
{{< imgproc ui-mockup-basic Fit "700x500">}}
<i>An example app represented as a Radius Application.</i>
{{< /imgproc >}}

We're committed to creating a dev experience users love. Developers can easily debug and iterate on that same app locally via VSCode as well. 
<!-- TODO: make all these diagrams & code show the identically same app -->
{{< imgproc vscode-mockup-basic Fit "700x500">}}
<i>An example Radius Application represented in VSCode.</i>
{{< /imgproc >}}


## A unified app language

The Radius platform is comprised of a human-readable language for describing applications and a suite of supporting tools.  

Radius provides a flexibile model that meets developers where they need it to:  
- Easy out-of-the-box defaults for basic scenarios.
- Ability to tune low-level settings. With Radius, users can access all available properties of Azure Services. 

The Radius API provides a single way to manage applications based on a variety of services like Container Apps and Functions. 

## Platform strategy

Project Radius aims to support all hosting platform types - from hyperscale cloud, to self-hosted Kubernetes on the edge, to IoT and edge devices.

{{< imgproc platform-goals Fit "700x500" >}}
{{< /imgproc >}}

Our current focus is on delivering robust support for the following platforms:

- [Local development]({{< ref local-dev >}}) as part of a developer inner-loop
- [Microsoft Azure]({{< ref deploy-to-azure>}}) as a managed-application serverless PaaS
- [Kubernetes]({{< ref deploy-to-kubernetes >}}) in all flavors and form-factors



<!-- TODO - incorporate the below text pasted from the old App model index page  -->
Project Radius provides a descriptive framework for cloud native applications and their requirements. 

## Deployable architecture diagrams

Cloud-native applications are often designed and described using lines-and-boxes architecture diagrams as the starting point.

<!-- TODO: make this diagram match the app in the mockup below-->
{{< imgproc app-diagram Fit "700x500" >}}
<i>An example app represented as a block diagram.</i>
{{< /imgproc >}}

These diagrams often include:
- Infrastructure resources, including databases, messages queues, API gateways, and secret stores
- Services that run application code, such as containers.
- Relationships between resources, like protocols, settings, and permissions

Project Radius provides a way for developers to translate human-understandable application diagrams into human-understandable application code. 

## App model language

Radius uses the [Bicep language]({{< ref bicep >}}) as its file-format and structure. Bicep is an existing Microsoft language that offers:
- A high quality authoring experience with modules, loops, parametrization, and templating
- ARM Deployment Stacks as the declarative deployment/rollback mechanism
- Ability to punch through abstractions to platform when necessary
- Extensions to work with other providers (e.g. Kubernetes, Azure Active Directory, etc.)
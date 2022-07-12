---
type: docs
title: "Radius environments"
linkTitle: "Environments"
description: "Learn about Radius Environments"
weight: 500
---

## Introduction

Radius environments are a prepared landing zone for applications. They contain a prepared pool of compute, networking, and shared resources. Radius applications deployed to that environment "bind" to that infrastructure. 

Environments provide a grouping structure for applications and the resources they share. For example, an org might choose to setup separate Radius environments for staging and production. When appropriate, mulitple applications can be deployed into the same environment. 

Additionally, environments can be leveraged to realize organizational best practices. 

<img src="env-with-apps-example.png" alt="Diagram of multiple Radius environments deployed to Azure. One environment contains 1 app, the other environment contains multiple apps." width="500" />

## Concerns that environments manage

Today, in a DevOps model, every developer might need to understand every nuance of every resource they're using - which makes it nearly impossible to get apps up and running. With Project Radius, environment definitions can be pre-configured to take that mental load away from developers, letting them run faster but stay within guidelines. 

### Compute runtime

Environments can be configured with a shared compute runtime for applications deployed into it, such as a Kubernetes cluster. Central infrastructure teams can configure the runtime with networking, identity, diagnostics, and other configuration that matches their org's requirements. Developers can then deploy applications into the environment without having to worry about the underlying infrastructure.

{{% alert title="🏗 In development" color="info" %}}
Additional compute runtimes, such as Azure serverless compute, will be available in a future release. Stay tuned for more information.
{{% /alert %}}

### Shared resources

Environment administrators can define shared resources that are available to all applications deployed into it. For example, an environment might define a shared Redis cache connector that can be used by all applications.

### Dynamic connector provisioning with recipes

Recipes allow connectors to automatically provision resources on demand when an application is deployed. Environments can be configured with recipes that match org-level requirments.

{{% alert title="🏗 In development" color="info" %}}
Recipes is currently in development. Check back soon for more details on how to dynamically provision and bind to platform resources using connectors.
{{% /alert %}}

## Handoffs between teams

In some cases a full stack developer might write the app code, author the Radius app defintion, and initialize the Radius environment. However, in some orgs, administrators might build environment templates that the collective group decides to leverage. The separation of an app from an environment makes a separation of concerns possible.

<img src="env-template-example.png" alt="Diagram of the contents of an environment" width="250px" /><br />

For example, a workflow where developers build on templates created by administrators might look like: 

1. An administrator defines a Radius environment template (Bicep/Terraform module)
   - The compute runtime is configured with networking, identity, diagnostics, and other configuration that matches their org's requirements.
   - Connector recipes are defined for how to deploy and configure infrastructure resources, such as for a Redis cache connector
1. The administrator initializes a Radius environment based on the template
1. A developer authors a Radius application template
   - The template includes a Redis cache connector
1. The developer deploys the app template to the Radius environment
   - The app's containers automatially run on the container runtime
   - The Redis cache connector recipe deploys a new Azure Cache for Redis instance and binds it to the connector
   - The connector automatically configures security best practices and injects connection information into the consuming container

When the developer deploys their application, these org-level concerns are automatically wired up based on the environment. Developers don't have to think about credentials or how networking is configured - which enables devs to focus on their applications instead.

## Next step

Now that you've learned about environments, it's time to learn about the Project Radius architecture

{{< button text="Architecture" page="architecture" size="btn-lg" color="success" >}}

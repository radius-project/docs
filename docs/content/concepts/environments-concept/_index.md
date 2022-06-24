---
type: docs
title: "Environments concept"
linkTitle: "Environments"
description: "Learn about Radius Environments"
weight: 300
---

## Introduction
Radius environments are a prepared landing zone for applications. They contain a prepared pool of compute, networking, and dependency resources like databases. Radius applications deployed to that environment can "bind" to that infrastructure. 

Environments provide a grouping structure for applications and the resources they share. For example, an org might choose to setup separate Radius environments for staging and production. When appropriate, mulitple applications can be deployed into the same environment. 

Additionally, environments can be leveraged to realize organizational best practices. 

<img src="env-with-apps-example.png" alt="Diagram of multiple Radius environments deployed to Azure. One environment contains 1 app, the other environment contains multiple apps." width="500" />


## Concerns that environments manage
Today, in a DevOps model, every developer might need to understand every nuance of every component they're using - which makes it nearly impossible to get apps up and running. With Radius, environment definitions can be pre-configured to take that mental load away from developers, letting them run faster but stay within guidelines. 

#### Network configuration
Cloud providers such as Azure and AWS contain infrastructure services that simplify for users the configurations of virtual network, subnets, network security groups and user defined routes. AWS uses services such as Amazon Virtual Private Cloud and Azure uses Azure Virtual Network.

#### Secret management
Teams looking to use cloud services must deal with setting configurations for identity-based access control, setting algorithms for encryption, storing keys and secrets in managed key vault services and rotate keys and other secrets frequently to keep up with security requirements including but not limited to expiring certificates, leaked credentials and dealing with downtime.

#### Dependencies/Storage
Teams must often deal with managing the configurations of their storage services. There could be times were the settings applied to a CosmosDB for example could change rendering a need to update the infrastructure settings.

#### Diagnostics
Teams often use diagnostic settings through leveraging services like Azure Monitor. If a customer uses CosmoDB they have various available ways to choose from to connect to Azure Monitor and have various log settings ranging from retention policy to specific grouping types.

#### Identity Policies
Cloud providers such as Azure allow users to manage identities which provide credentials to access/limit user interactions with other services. If a user sets up a CosmoDB and assigns a managed identity for access today, they encounter that there are many different types of permissions that can be assigned such as the ability to read metadata, execute queries and add new data.

<img src="env-template-example.png" alt="Diagram of example contents for an environment template. It contains dependencies like Dapr, templates for infrastructure, security configuration, diagnostics and logging, and compute runtime." width="200" />

Because environment definitions can be codified, central teams can define environment templates that let their dev teams hydrate fully-functioning environments in a self-service way - while following organization best practices like security configuration. 

## Handoffs between teams
In some cases, a full stack developer might write the app code, write the Radius app defintion, and create the Radius environment. However, in some orgs, administrators might build environment templates that the collective group decides to leverage. The separation of an app from an environment makes a separation of concerns possible. 

For example, a workflow where developers build on templates created by administrators might look like: 
- Administrator defines the Radius environment specs in a template 
- Administrator creates a Radius environment based on the template
  - The environment contains definitions for supporting infrastructure the devs might need, like for a Redis cache
- Developer authors a Radius application template
  - The template includes a Redis cache resource
- Developer deploys the app template to Radius 
  - Radius uses the pre-built Redis cache definition to deploy an Azure Cache for Redis instance on behalf of the user
  - Radius binds that new cache instance to the environment 
  - Radius wires up the connection to the new cache instance, automatically configuring security best practices, injecting ENV variables, etc.
  - Radius creates a vnet for the kubernetes cluster and redis cache based on env config
  - Radius configures diagnostics and monitoring, including App Insights and Azure Monitor based on env config
  - Radius sets up access to a private container registry as defined in env config


When the developer deploys their application, these org-level concerns are automatically wired up based on the environment. Developers don't have to think about credentials, or where logs go, or how networking is configured - which enables devs to focus on their applications instead. [rephrase to pull back to the new intro paragraph about why]

## Creating an environment
Users can initialize a Radius environment into any Kubernetes cluster that has the Radius control plane installed. 
[TODO - new CLI command and related doc comging, e.g. `rad service install`]

When creating an environment, users can either initalize an env based on a template or they may generate a default, empty environment.

### Environments from templates
You can describe an environment's requirements and contents via one of the [supported IaC languages]({{< ref supported-languages >}}). 

### Default environments 
If you choose not to define environment specs, an empty environment will be created. You can install additional services there later if needed. 

- For example environment definitions, see [link coming soon in other PR]
<!-- TODO add that link ^  -->

### 2. Initialization an environment 
To cre
```bash
rad env init kubernetes
```

Note: Radius currently supports Kubernetes as the container runtime. We plan to support additional container runtimes in the future. 

This command will:
- If a Radius control plane is not already installed, install it
    - Install Radius control plane services via a set of Helm charts 
- Create a new environment 
    - Create a namespace to hold the environment resource 
    - Create an environment resource
    - Execute any environment installation templates (e.g. to install Dapr) 
- Walk users through configuring cloud providers to connect to public clouds 

Each AKS or EKS cluster requires 1 Radius control plane, but it may contain multiple Radius environmnents if desired. 

To verify that your environment initialized correctly, you should see it listed in the output of
```bash
rad env list
```

## Maintaining an environment 

env model makes it easier to make updates and to identify envs that need updates 
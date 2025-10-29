---
type: docs
title: "Radius Concepts"
linkTitle: "Concepts"
description: "Radius core concepts and architecture"
weight: 20
---

## Introduction

Radius is a platform for managing application resources deployed to the cloud. It is a central component of a modern-day internal developer platform (IDP) and allows platform engineers to define resource types for developers to use when building their applications, and separately, the implementation of those resource types using existing Infrastructure as Code (IaC) templates and modules. Additionally, Radius enables platform engineers to define logical environments with specific deployment targets (e.g., a specific cloud provider region), each with their own IaC implementation. 

This page is a conceptual overview of Radius. It describes how Radius fit in with other IDP components, its logical components, and its technical architecture. <!-- It is accompanied by additional concept pages focused on each of the core components: Resource Types, Recipes, Environments, and Applications.  --> If you are new to Radius, you are encouraged to complete the [Quick Start]({{< ref "quick-start" >}}). Then, after reading the concept documentation, complete the end-to-end [tutorial]({{< ref "tutorials" >}}).

## IDP reference architecture

Developers are often tasked with writing low-level IaC code. For example, they may author a Helm chart to deploy their containers to Kubernetes then a CloudFormation template to deploy an AWS RDS database. In this reference architecture, cloud resources are defined separately from the deployment implementation. Developers define their applications and application resources abstractly using resource types the platform engineer has defined. Platform engineers then use IaC solutions to implement how the resources are deployed.

The diagram below is a reference architecture for an IDP that incorporates these concepts.

{{< image src="reference-arch.png" width="65%" alt="IDP reference architecture" >}}

Notice that resources are defined separately from the deployment of the resource. These resource types are abstract, application oriented, and infrastructure/cloud provider agnostic. For example, rather than an *Azure Database for PostgreSQL Flexible Server* resource that is obviously only deployable to Azure, an abstract PostgreSQL database resource type is defined. Then a swappable resource deployment IaC implementation is used when deploying to Azure.

By separating resource definition from resource deployment, platform engineers are able to:

* Enforce separation of concerns between application developers and platform engineers
* Define resource types with a higher level of abstraction and are more application oriented
* Eliminate the need for developers to handle low-level infrastructure details
* Ensure portability between cloud providers and container platforms
* Enforce infrastructure security, operational, and cost best practices

## Logical architecture

Radius is designed around a small number of core components. In order to enforce the separation of resource definition from resource deployment, each component is managed by either a platform engineer, or a developer, but never both.

{{< image src="logical-model.png" width="65%" alt="Local model of Radius" >}}

### Platform engineer components

#### Resource Types

Resource Types define the abstraction for a resource that will exist in the real world when deployed. Resource Types represent the **interface**, or contract, between developers and the platform. Since they are abstract and application-oriented, there is only one Resource Type defined within Radius for each application resource. For example, a platform engineer may define a PostgreSQL database Resource Type which is an application-oriented abstraction of a one of the many ways of deploying an PostgreSQL database. Resource Types are defined conceptually by what they represent, but concretely by their name, API version, and their schema. The schema contains the set of required and optional properties which are used by developers when defining their application.

#### Recipes

While Resource Types define the interface, Recipes define the **implementation**. Radius supports using both Terraform and Bicep IaC languages as the Recipe implementation. The term *recipe* is used as a generic term to refer to both a Terraform configuration/module or a Bicep template.

Recipes are not tightly coupled with Radius or the Resource Type. In most circumstances, an existing Terraform module or Bicep template can be used as a Recipe with slight modifications to ensure the properties in the Resource Type map to the Terraform variables or Bicep parameters.

Radius makes it easier to implement Recipes by automatically injecting Recipes with a `context` object which includes *contextual* information needed to deploy the resource. This includes:

- The Application name
- The Environment name as well as Kubernetes, AWS, and Azure details
- Parameters specified in the Environment definition (see Environments below)
- The resource name and all of its properties
- All connected resources and their properties (connections are discussed later)

By using the `context` object, Recipes have all the information needed to deploy the actual resource in the target location.

#### Environments

Radius Environments define the deployment location as well as the set of Recipes to use to deploy resources to that Environment. Environments can be modeled in many ways according to your preferences. They may be logical environments such as dev, test, stage, prod. Or they may be locations such as AWS us-east-1. They may be specific to an application or a team, or shared across the organization. 

When defining an Environment, the deployment location is specified by `provider`:

- **Kubernetes**: The namespace
- **AWS**: The account and region
- **Azure**: The subscription and resource group

When a resource is deployed, these location details are provided to the Terraform module or Bicep template via the `context` object.

The second component of the Environment definition is the set of Recipes for each Resource Type. By assigning Recipes at the Environment level, it is possible for each Environment to have a unique set of Recipes. Take a PostgreSQL database Resource Type as an example, there may be:

- A development environment running on a local workstation that deploys the database to a local Kind or k3d cluster
- A test environment which deploys to a shared Kubernetes cluster but also assigns more CPU and memory to the database
- A staging environment that deploys the database to AWS using RDS
- A production environment that also uses AWS RDS but configures the database with high availability and backups

Finally, each Recipe in an Environment definition can also have Environment-level Recipe parameters. Recipe parameters are useful for injecting additional environmental information into the Recipe. Take, for example, a Recipe which deploys a PostgreSQL database using AWS RDS or Azure Database for PostgreSQL. Ideally, the database is created with an endpoint in an existing VPC/virtual network. The virtual network ID can be passed to the Recipe via a Recipe parameter defined within the Environment. 

#### Resource Groups

All resources are created in one and only one Resource Group. They are analogous to a Kubernetes Namespace or an Azure Resource Group.

#### Credentials

When a developer requests a resource to be deployed, those resources are not deployed using the developers credentials. Rather, Radius uses its own Kubernetes, AWS, or Azure credentials. This enables platform engineers to only allow resources to be deployed via Radius. Radius supports creating credentials for AWS and Azure using either secrets or workload identity.

### Developer components

#### Applications and resources

Developers build applications. But when they deploy those applications to Kubernetes or other container platforms, the notion of an application is typically lost. Developers are left with essentially a flat list of resources. In the best case, the resources are annotated with the application name, but not always. This makes it challenging for developers and SREs to understand what resources belong to what applications. 

Radius takes a different approach and makes the application a first-class resource. With Radius, developers first define an Application resource, then add resources to that Application such as containers and databases. All resources belong to an Application (with some exceptions for resources shared across applications such as shared storage). When an Application is deployed to an Environment, the Application's abstract resource definitions are married with the Environment's cloud-specific Recipes. 

## Technical architecture

The diagram below visualizes the technical components that are created when you install Radius on a Kubernetes cluster.

{{< image src="technical-arch.png" width="65%" alt="Technical architecture of Radius" >}}

### Radius CLI

The Radius CLI, `rad`, is the primary means of interacting with Radius for both developers and platform engineers. The Radius CLI uses the current Kubernetes context in `~/.kube/config` to determine which Radius control plane to communicate with. Additionally, the Radius CLI will read the user's current Workspace, which defines the current Resource Group and Environment, from the `~/.rad/config.yaml`file. 

### Dashboard

The Radius Dashboard is a Backstage-based developer portal. Its primary purpose is to provide developers with organization-specific developer documentation. The Dashboard includes details for developers on what Resource Types are available, as well as a list of Environments they can deploy their application to. Platform engineers can write customized developer documentation for each Resource Type. 

When installing Radius, the Dashboard is installed with a Kubernetes Service of type `ClusterIP`. It is left to the platform engineer to configure ingress to the Dashboard.

### Universal Control Plane

The Universal Control Plane (UCP) is the Radius control plane. It provides a REST API for creating, reading, updating, deleting, and listing resources. When a platform engineer creates a new Resource Type, the UCP API is being extended since each Resource Type has its own API.

UCP is exposed using the Kubernetes API Server via the [Kubernetes API Aggregation Layer](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/apiserver-aggregation/), meaning the Radius control plane endpoint is actually the Kubernetes API Server endpoint. This also means that controlling access to the Radius API is achieved using Kubernetes RBAC.

### Deployment Engine

When an Application is deployed using Radius, UCP makes a request to the Deployment Engine.  Deployment Engine examines the resources in the application definition and calculates the dependencies. For example, if an application definition has a frontend container, a database, and a secret to store the database credentials, Deployment Engine will determine that the secret must be deployed first, then the database which requires the secret value, and finally the frontend container which requires the database hostname and credentials.

### Applications and Dynamic Resource Providers

The Applications and Dynamic Resource Provider (RP) components are internal components that handle the actual deployment of resources. Ultimately, the Terraform or Bicep CLIs are executed within the Dynamic RP container.

### Controller

The Controller component is an internal component that handles miscellaneous functions such as the integration with Flux CI/CD.

### Git repository and OCI registry

When Radius deploys a resource using Terraform or Bicep, the Dynamic RP container must have access to the specified Recipe. Therefore, a Git repository is used to store Terraform configurations and an OCI registry is used to store Bicep templates. Radius does not run recipes off the local workstation's file system. 

<br>
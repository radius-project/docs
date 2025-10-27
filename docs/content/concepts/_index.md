---
type: docs
title: "Radius Concepts"
linkTitle: "Concepts"
description: "Radius core concepts and architecture"
weight: 20
---

## Introduction

Radius is a platform for managing application resources deployed to the cloud. It is a central component of modern-day internal developer platform (IDP) and allows platform engineers to define resource types for developers to use when building their applications, and separately, the implementation of those resource types using existing Infrastructure as Code (IaC) templates and modules. Additionally, Radius enables platform engineers to define logical environments with specific deployment targets (e.g., a specific cloud provider region), each with their own IaC implementation. 

This page is a conceptual overview of Radius. It describes how Radius integrates with other IDP components, its logical components, and its technical architecture. It is accompanied by additional concept pages focused on each of the core components: Resource Types, Recipes, Environments, and Applications. If you are new to Radius, you are encouraged to complete the [Quick Start]({{< ref "quick-start" >}}). Then, after reading the concept documentation, complete the end-to-end [tutorial]({{< ref "tutorials" >}}).

## IDP reference architecture

Developers are often tasked with writing low-level IaC code. For example, they may author a Helm chart to deploy their containers to Kubernetes and, separately, a CloudFormation template to deploy an AWS RDS database. In this reference architecture, cloud resources are defined separately from the deployment implementation. Developers define their applications and application resources abstractly using resource types the platform engineer has defined. Platform engineers then separately use IaC solutions to implement how the resources are deployed.

The diagram below is a reference architecture for an IDP that incorporates these concepts.

{{< image src="idp-reference-arch.png" width="65%" alt="IDP reference architecture" >}}

You will notice that resources are defined separately from the deployment of the resource. These resource types are abstract and application-oriented, and infrastructure and cloud provider agnostic. For example, rather than an Azure Database for PostgreSQL flexible server resource definition and deploy, simply a PostgreSQL database resource type is defined. Then the resource deployment implementation may deploy to Azure.

By separating resource definition from resource deployment, platform engineers are able to:

* Enforce separation of concerns between application developers and platform engineers
* Define resource types which are higher level and more application oriented 
* Eliminate the need for developers to handle low-level infrastructure details
* Ensure portability between cloud providers and container platforms
* Enforce infrastructure security, operational, and cost best practices 

## Logical architecture

Radius is designed around a small number of core components. In order to enforce the separation of resource definition from resource deployment, each component is managed by either a platform engineer, or a developer, but never both.

{{< image src="logical-model.png" width="65%" alt="Local model of Radius" >}}

### Platform engineer components

#### Resource Types

Resource Types define the abstraction, or **interface**, for resource. They are the contract between developers and the platform. They define what the resource is and the required and optional properties used when creating a resource. Since they are abstract, there is a single Resource Type for each resource type in the real world. For example, while Radius may by able to deploy a PostgreSQL database to Kubernetes, AWS, and Azure, there is only one PostgreSQL Resource Type defined within Radius. Platform engineers can use the Resource Types which ship with Radius, community contributed Resource Types in the `resource-type-contrib` repository, or define their own from scratch. 

Resource Types are discussed in detail in the Resource Types concept page.

#### Credentials

When a developer requests a resource to be deployed, those resources are not deployed using the developers credentials. Rather, Radius uses its own Kubernetes, AWS, or Azure credentials. This enables platform engineers to only allow resources to be deployed via Radius. Radius supports creating credentials for AWS and Azure using either secrets or workload identity.

#### Resource Groups

All resources are created in one and only one Resource Group. They are analogous to a Kubernetes Namespace or an Azure Resource Group.

#### Recipes

While Resource Types define the interface, Recipes define the **implementation**. Radius supports both Terraform and Bicep IaC solutions. The term *recipe* is used as a generic term to refer either to a Terraform configuration/module or a Bicep template. A recipe can be an existing Terraform module stored in a Git repository or a Bicep template stored in an OCI registry. For each Resource Type, there may be multiple Recipes. For example, a PostgreSQL Resource Type may have:

1. A Recipe for local development which deploys to Kubernetes
2. A Recipe for the test environment which deploys to Kubernetes with more resources
3. A Recipe for the staging environment that deploys to AWS using AWS RDS
4. A Recipe for the production environment that deploys to AWS using AWS RDS with high availability and backups configured

Multiple recipes are not required. In the example above, the recipe #1 and #2 could be combined into an enhanced Recipe which has an conditional on the Environment name; e.g., if the Environment name is `test` then set the CPU resource requests to 2, else do not set the CPU resource request.

Other examples and how the recipe knows what environment it is using is discussed in the Recipes concept page. 

#### Environments

Because applications defined using Radius do not have infrastructure details in their definitions, platform engineers can define the deployment target without affecting application definitions. In Radius, this deployment target is referred to as an Environment. An Environment is a composed of the target deployment destination (such as what cloud provider and what region) as well as the set of Recipes to use to deploy to that Environment. Environments can also used to configure deployment-time settings for Terraform and Bicep. This is discussed in the Environments concept page.

### Developer components

#### Applications and resources

Developers build applications. But when they deploy those applications to Kubernetes or other container platforms, the notion of an application is typically lost. Developers are left with a sea of resources that are deployed as a flat list of resources. Maybe the resources are annotated with the application name, but maybe not. This makes it challenging to manage for developers and SREs.

Radius takes a different approach and makes the application a first-class resource. With Radius, developers first define an Application resource, then add resources to that Application such as containers and databases. All resources belong to an Application (with some exceptions for resources shared across applications such as shared storage). When an Application is deployed to an Environment, the Application's abstract resource definitions are married with the Environment's cloud-specific Recipes. 

## Technical architecture

Radius is deployed on a Kubernetes cluster and has its own CLI and Dashboard.

{{< image src="technical-arch.png" width="65%" alt="Technical architecture of Radius" >}}

### Radius CLI

The Radius CLI, `rad`, is the primary means of interacting with Radius for both developers and platform engineers. The Radius CLI uses the current Kubernetes context in `~/.kube/config` to determine which Radius control plane to communicate with. Additionally, the Radius CLI will read the user's current Workspace, which defines the current Resource Group and Environment, from the `~/.rad/config.yaml`file. 

### Dashboard

The Radius Dashboard is a developer portal built using Backstage. Its primary purpose is to provide developers with organization-specific developer documentation. The Dashboard includes details for developers on what Resource Types are available for use within their application, as well as a list of Environments they can deploy their application to. Platform engineers can write customized developer documentation for each Resource Type. 

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

## Additional concept pages

This section continues by going into detail on the following topics:

---
type: docs
title: "Frequently asked questions"
linkTitle: "FAQ & Comparisons"
description: "Commonly asked questions about best practices"
weight: 999
---

## General

### Is Kubernetes required to use Radius? 

Currently yes. Although Radius is architected to run on any platform, today Kubernetes is the only hosting platform for Radius for the Radius control-plane and for containerized workloads. In the future, we plan to support other hosting platforms for serverless platforms.

### Can I incrementally adopt, or "try out" Radius?

Yes. The easiest way to add Radius to an existing application is through [Radius annotations](#TODO). Simply add the annotations to your existing Helm chart or Kubernetes YAML and you can use the Radius app graph, connections, and Recipes. [Try the tutorial](#TODO) to learn more.

### Do I have to self-host Radius? Is there a managed service for Radius? 

Open-source Radius requires that you self-host and run your own Radius instance in your Kubernetes cluster. In the future, we hope for providers to include Radius as a part of their managed service offerings.

### What languages does Radius support? 

For application code, Radius supports any programming language as long as it is containerized.

Radius resources (_applications, environments, portable resource_) can be authored in Bicep. See the [Radius resource schema]({{< ref resource-schema >}}) for more details. Additional support for other languages will come in a future release. Stay tuned for updates.

Recipes support both Bicep and Terraform. See the [Recipe docs]({{< ref "/guides/recipes/overview" >}}) for more details.

### When would/should I use more than one environment?

Users can employ multiple environments for isolation and organization, for example based on:

- Permissions (managed at the Resource Group/Subscription level in Azure)
- Purpose (dev vs. prod)
- Difference in hosting (standalone Kubernetes vs Microsoft Azure)

[Workspaces]({{< ref "/guides/operations/workspaces/overview" >}}) can be used to manage multiple environments from one machine.

## Recipes

### What resources do Recipes support?

Recipes currently support the set of [Radius portable resources]({{< ref "/guides/author-apps/portable-resources/overview" >}}): Redis, Mongo, RabbitMQ, SQL, Dapr State Stores, Dapr Secret Stores, Dapr Pub/Sub, and the untyped extender resource. Additional support for other resources (_Azure, AWS, etc._) will come in a future release.

### What infrastructure can Recipes deploy? 

Radius Recipes support any resources that can be modeled in Bicep, or the AWS, Azure, and Kubernetes Terraform providers.

### Can I use any Terraform provider with Recipes?

Yes, however custom provider configuration is not yet supported. It is not recommended to use any Terraform providers that require authentication to a cloud provider (e.g. Oracle, GCP, etc.) as this will require you to store credentials in your Recipe. Support for custom provider configuration is a high priority to address in an upcoming release.

### Do developers need write access to a cloud provider (_Azure subscription, AWS account, etc._) to use Recipes? 

No. Recipes are deployed on-behalf-of the Radius Environment so developers do not need any write access to an Azure subscription, resource group, or AWS account. This allows a least-privilege access model to cloud resources and for IT operators to only allow approved IaC templates to be deployed to their cloud environments. 

## Cloud/platform support

### What AWS services does Radius support?

Radius Applications can include AWS services that are also supported by the AWS cloud control API. See the [AWS resource library]({{< ref "/guides/author-apps/aws/overview#resource-library" >}}) for the complete list of supported AWS resources. Radius does not currently support direct connections to AWS resources, but it is on the backlog.

### What Azure services does Radius support? 

Radius Applications can include any Azure service, with support for direct connections and managed identities. Compute services (Web Apps, Container Apps, App Service, Functions, Logic Apps, and others) can be deployed but cannot currently declare connections to other resources.

### Does Radius support Google Cloud Platform (GCP)? 

Not yet, but it is on the backlog.

### Does Radius support Dapr? 

Yes. Radius has first-class support for [Dapr building blocks]({{< ref "/guides/author-apps/dapr" >}}) such as state stores, secret stores, and pub/sub brokers. Developers can add Dapr resources to their applications and operators can define Recipes that deploy and manage the underlying infrastructure. 

## Comparison to other tools

### How does Radius compare to Kubernetes?

[Kubernetes](https://kubernetes.io/) is an open-source system for automating deployment, scaling, and management of containerized applications and custom resources. =

Radius leverages Kubernetes in two ways:

1. As a hosting platform for the Radius control-plane
2. As a runtime for containerized workloads

While Radius only supports Kubernetes today, it is architected to support other hosting platforms in the future, including serverless platforms. Radius is not a Kubernetes controller and the primary user experience is not through CRDs. Instead, Radius Applications are an abstraction layer on top of Kubernetes and other cloud platforms.

### How does Radius compare to Helm?

[Helm](https://helm.sh/) is a package manager for Kubernetes that allows you to define, install, and upgrade Kubernetes applications. Helm is a great tool for deploying Kubernetes objects, but doesn't provide a way to model dependencies between services and infrastructure, or to define and manage infrastructure-as-code. It also only supports Kubernetes as a targeted platform.

Radius was built to provide a platform for modeling and deploying an entire application, as cloud-native applications are more than just Kubernetes. They include cloud infrastructure, running services, the underlying platforms, and all the connections between them.

Teams looking to leverage existing Helm charts can use the [Radius annotations and Recipe CRD](#TODO) to add Radius capabilities to their existing application. With just a few annotations, you can add the power of the Radius app graph, connections, and Recipes to your existing Helm chart.

Teams building or migrating applications on Radius can use Bicep to model their application and deploy to Kubernetes today, as well as future platforms, including serverless platforms.

### How does Radius compare to Bicep?

[Bicep](https://github.com/Azure/bicep) is a Domain Specific Language (DSL) for deploying infrastructure declaratively. Radius leverages Bicep as one of its supported languages for defining applications and Recipes.

Similar to how you can define Azure resources in Bicep, you can define Radius resources in Bicep.

Radius currently uses a temporary fork of Bicep to add support for the Radius resources, but work is underway to merge extensibility support into the main Bicep repo and eliminate the need for a fork.

### How does Radius compare to Terraform?

[Terraform](https://www.terraform.io/) is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform is a great tool for deploying infrastructure, but doesn't provide a way to model an entire application and the dependencies between services and infrastructure, or act as an abstraction layer for multiple cloud providers.

Teams looking to leverage existing Terraform templates can use [Recipes]({{< ref "/guides/recipes/overview" >}}) to manage infrastructure provisioning, with the application defined in Bicep. The ability to define Radius applications in Terraform in addition to Bicep is on the roadmap.

### How does Radius compare to Dapr?

[Dapr](https://dapr.io/) is a portable, event-driven runtime that makes it easy for developers to build resilient, microservice stateless and stateful applications that run on the cloud and edge. Dapr is a great tool for writing microservice code, but doesn't provide a way to model or deploy an entire application and its infrastructure.

Radius provides [built-in Dapr support]({{< ref "/guides/author-apps/dapr" >}}) to make it easy to model Dapr building blocks and Dapr-enabled services within your app. Like peanut butter and jelly, Radius and Dapr are better together.

### How does Radius compare to Acorn?

[Acorn](https://www.acorn.io/) is a simple application deployment framework built on Kubernetes. Developers can author Acornfiles which describe their application and deploy locally and move to production without having to switch tools or technology stacks.

Radius also provides a simple authoring experience for developers, but it also manages cloud infrastructure via Recipes and is built to target non-Kubernetes platforms in the future. Radius is focused on teams of developers plus operators, providing each with the tools they need to be productive and secure.

### How does Radius compare to Crossplane?

[Crossplane](https://crossplane.io/) is an open source Kubernetes add-on that extends any cluster with the ability to provision and manage cloud infrastructure, services, and applications using kubectl, GitOps, or any tool that works with the Kubernetes API.

Radius is a platform that not only deploys and manages cloud infrastructure, but also provides a way to model and deploy an entire application and its dependencies. Teams can understand their entire application and all the dependencies within it using the Radius app graph, and deploy infrastructure that's secure by default using Recipes.

Crossplane CRDs can be used within Radius Recipes to deploy and manage cloud infrastructure if teams want to leverage existing Crossplane investments. Both Bicep and Terraform templates are able to include Kubernetes resources.

### How does Radius compare to Waypoint?

[HCP Waypoint](https://developer.hashicorp.com/hcp/docs/waypoint) is a HashiCorp-managed application deployment platform that simplifies the process of deploying applications into your infrastructure and helps you standardize your deployment process.

While Radius also is able to model and deploy applications, it also provides an application graph and Recipes to offer an end-to-end platform that is application-focused at every stage. Radius is more than an abstraction and deployment automation. The Radius app graph allows teams to understand their entire application and all the dependencies within it, even after an application is deployed. Recipes are also more than template automation. They provide abstraction + encapsulation so developers never are required to directly interact with cloud infrastructure templates or parameters.

### Does does Radius compare to Tanzu?

[Tanzu](https://tanzu.vmware.com/) is a portfolio of products and services for modernizing applications and infrastructure with a common goal: deliver better software to production, continuously.

Radius is an open-source project that also provides a platform for modeling and deploying applications. Radius acts as an abstraction that allows developers to focus on their application and not the underlying infrastructure. Together with Environments and Recipes, Radius allows applications to bind to any cloud or on-premises infrastructure without a developer needing to directly work with infrastructure templates or parameters. Radius also provides a way to model dependencies and connections between services and infrastructure which can be queried and visualized after deployment.

### How does Radius compare to Azure Deployment Environments?

[Azure Deployment Environments](https://azure.microsoft.com/products/deployment-environments/) allow developers to quickly spin up infrastructure environments with project-based templates. It handles template curation via catalogs of templates, and provides a self-service experience for developers to deploy and manage their environments without needing direct access to the underlying Azure resource groups.

Radius Recipes provide a similar experience for developers to deploy and manage infrastructure, but with a few key differences:

- Recipes are defined on a per-resource basis instead of per-environment. This allows developers to "mix and match" resources in any combination and swap out the backing Recipe depending on which environment they are targeting.
- Recipes support both Bicep and Terraform, allowing operators to leverage existing Terraform templates and modules.
- Recipes support both Azure and AWS, allowing operators to manage infrastructure across multiple cloud providers.

### How does Radius compare to Azure Arc?

[Azure Arc](https://azure.microsoft.com/services/azure-arc/) is a set of technologies that extends Azure management and services to any infrastructure. It brings Azure services and management to any infrastructure.

Radius is an open-source project that provides a platform for modeling and deploying applications that can run across Azure, AWS, or private clouds. Instead of extending an existing cloud platform, Radius is a new platform that sits above existing cloud platforms and provides a consistent way to model and deploy applications across these platforms.

While there isn't direct support for targeting Azure Arc for Radius containers today, Arc services and infrastructure can be modeled and deployed using [Recipes]({{< ref "/guides/recipes/overview" >}}).

### How does Radius compare to Azure Container Apps?

[Azure Container Apps](https://azure.microsoft.com/products/container-apps/) is a service that allows developers to deploy containerized applications to Azure without managing any infrastructure.

While Radius only supports Kubernetes today, it is architected to support other hosting platforms in the future, including serverless platforms such as Azure Container Apps. Serverless support is on our roadmap.

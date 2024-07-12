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

Yes. The easiest way to add Radius to an existing application is through [Radius annotations]({{< ref "/tutorials/tutorial-add-radius#step-3-add-radius-to-the-guestbook-application" >}}). Simply add the annotations to your existing Helm chart or Kubernetes YAML and you can use the Radius app graph, connections, and Recipes. [Try the tutorial]({{< ref "/tutorials/tutorial-add-radius" >}}) to learn more.

### Do I have to self-host Radius? Is there a managed service for Radius?

Open-source Radius requires that you self-host and run your own Radius instance in your Kubernetes cluster. In the future, we hope for providers to include Radius as a part of their managed service offerings.

### What languages does Radius support?

For application code, Radius supports any programming language as long as it is containerized.

Radius resources (_applications, environments, portable resource_) can be authored in Bicep. See the [Radius resource schema]({{< ref resource-schema >}}) for more details. Additional support for other languages (_like Terraform_) is on our backlog.

Recipes support both Bicep and Terraform. See the [Recipe docs]({{< ref "/guides/recipes/overview" >}}) for more details.

### When would/should I use more than one environment?

Users can employ multiple environments for isolation and organization, for example based on:

- Permissions (managed at the Resource Group/Subscription level in Azure)
- Purpose (dev vs. prod)
- Difference in hosting (standalone Kubernetes vs Microsoft Azure)
- Multi-region deployments (deploy an application to multiple regions)

[Workspaces]({{< ref "/guides/operations/workspaces/overview" >}}) can be used to manage multiple environments from one machine.

## Recipes

### What resources do Recipes support?

Recipes currently support the set of [Radius portable resources]({{< ref "/guides/author-apps/portable-resources/overview" >}}): Redis, Mongo, RabbitMQ, SQL, Dapr State Stores, Dapr Secret Stores, Dapr Pub/Sub, and the untyped extender resource. Additional support for other resources (_Azure, AWS, etc._) will come in a future release.

### What infrastructure can Recipes deploy?

Radius Recipes support any resources that can be modeled in Bicep, or the AWS, Azure, and Kubernetes Terraform providers.

### Can I use any Terraform provider with Recipes?

Terraform Recipes currently support the Azure, AWS, and Kubernetes providers, plus any provider that does not require any credentials or configuration to be passed in (_e.g. Oracle, GCP, etc. are not currently supported_).  Support for provider configuration is a high priority we plan to address in an upcoming release.

### Do developers need write access to a cloud provider (_Azure subscription, AWS account, etc._) to use Recipes?

No. Recipes are deployed on-behalf-of the Radius Environment so developers do not need any write access to an Azure subscription, resource group, or AWS account. This allows a least-privilege access model to cloud resources and for IT operators to only allow approved IaC templates to be deployed to their cloud environments.

## Cloud/platform support

### What AWS services does Radius support?

Radius Applications can include AWS services that are also supported by the AWS cloud control API. See the [AWS resource library]({{< ref "/guides/author-apps/aws/overview#resource-library" >}}) for the complete list of supported AWS resources. Connections from a Radius container to an AWS resource are not yet supported. Properties such as hostnames, ports, endpoints, and connection strings need to be manually specified as environment variables. Additional support for Connections to AWS resources is on our backlog.

### What Azure services does Radius support?

Radius Applications can include any Azure service, with support for direct connections and managed identities. Compute services (Web Apps, Container Apps, App Service, Functions, Logic Apps, and others) can be deployed but cannot currently declare connections to other resources.

### Does Radius support Google Cloud Platform (GCP)?

Not yet, but it is on the backlog.

### Does Radius support Dapr?

Yes. Radius has first-class support for [Dapr building blocks]({{< ref "/guides/author-apps/dapr" >}}) such as state stores, secret stores, and pub/sub brokers. Developers can add Dapr resources to their applications and operators can define Recipes that deploy and manage the underlying infrastructure.

## Comparison to other tools

### How does Radius compare to Kubernetes?

[Kubernetes](https://kubernetes.io/) is an open-source system for automating deployment, scaling, and management of containerized applications and custom resources.

Radius leverages Kubernetes in two ways:

1. As a hosting platform for the Radius control-plane
1. As a runtime for containerized workloads

While Radius only supports Kubernetes today, it is architected to support other hosting platforms in the future, including serverless platforms. Radius is not a Kubernetes controller and the primary user experience is not through custom resources (CRDs). Instead, Radius Applications are an abstraction layer on top of Kubernetes and other cloud platforms.

### How does Radius compare to Helm?

[Helm](https://helm.sh/) is a package manager for Kubernetes that allows you to define, install, and upgrade Kubernetes applications. Helm is a great tool for deploying Kubernetes objects, but doesn't provide a way to model dependencies between services and infrastructure, or to define and manage infrastructure-as-code. It also only supports Kubernetes as a targeted platform.

Radius was built to provide a platform for modeling and deploying an entire application, as cloud-native applications are more than just Kubernetes. They include cloud infrastructure, running services, the underlying platforms, and all the connections between them.

Teams looking to leverage existing Helm charts can use the [Radius annotations and Recipe CRD](#TODO) to add Radius capabilities to their existing application. With just a few annotations, you can add the power of the Radius app graph, connections, and Recipes to your existing Helm chart.

### How does Radius compare to Bicep?

[Bicep](https://github.com/Azure/bicep) is a Domain Specific Language (DSL) for deploying infrastructure declaratively. Radius leverages Bicep as one of its supported languages for defining applications and Recipes.

Similar to how you can define Azure resources in Bicep, you can define Radius resources in Bicep.

Radius uses Bicep to add support for Radius resources.  We previously used a temporary fork of Bicep, but have since deprecated it in favor of the main Bicep repo.

Teams building or migrating applications on Radius can use Bicep to model their application and deploy to Kubernetes today, as well as future platforms, including serverless platforms.

### How does Radius compare to Terraform?

[Terraform](https://www.terraform.io/) is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform is a great tool for deploying infrastructure, but doesn't provide a way to model an entire application and the dependencies between services and infrastructure, or act as an abstraction layer for multiple cloud providers.

Teams looking to leverage existing Terraform modules can use [Recipes]({{< ref "/guides/recipes/overview" >}}) to manage infrastructure provisioning, with the application defined in Bicep. The ability to define Radius applications in Terraform in addition to Bicep is on the roadmap.

### How does Radius compare to Dapr?

[Dapr](https://dapr.io/) is a portable, event-driven runtime that makes it easy for developers to build resilient, microservice stateless and stateful applications that run on the cloud and edge. Dapr is a great tool for writing microservice code, but doesn't provide a way to model or deploy an entire application and its infrastructure.

Radius provides [built-in Dapr support]({{< ref "/guides/author-apps/dapr" >}}) to make it easy to model Dapr building blocks and Dapr-enabled services within your app. Like peanut butter and jelly, Radius and Dapr are better together.

### How does Radius compare to Acorn?

[Acorn](https://www.acorn.io/) is a cloud platform to build and share applications ("acorns"). It provides a dev environment with the ability to move to cloud environments as part of a paid service.

Radius is an open-source project that allows you to model, deploy, and manage applications across multiple cloud providers. Radius is not a hosting platform and is not a paid service. Instead, Radius allows you to host your own Radius environments on your own Kubernetes clusters, and deploy applications to any cloud provider or on-premises infrastructure. Radius also offers Recipes and the Application Graph to allow developers and operators to work together on an application.

### How does Radius compare to Crossplane?

[Crossplane](https://crossplane.io/) is an open-source Kubernetes add-on that extends any cluster with the ability to provision and manage cloud infrastructure, services, and applications using kubectl, GitOps, or any tool that works with the Kubernetes API. As Radius is unopinionated about how infrastructure is deployed through Recipes, Crossplane could be used within a Recipe. Both Bicep and Terraform modules are able to include Kubernetes resources and Crossplane CRDs.

Once deployed, Crossplane-managed infrastructure can be included in a Radius application and queried via the Radius application graph.

### How does Radius compare to Open Application Model (OAM)?

[OAM](https://oam.dev) is a specification for describing applications so that the application description is separated from the details of how the application is deployed onto and managed by the infrastructure. It originated from the Azure Incubations team from which Radius also originated.

The key difference between OAM and Radius is that OAM is a spec, whereas Radius is an implementation. The expectation with OAM is that there would be a common spec and if it was successful, there would be multiple (compatible) implementations of OAM for various platforms. [Kubevela](https://github.com/kubevela/kubevela) is one example of an OAM implementation.

Radius is a new project that takes what we learned from OAM and focuses more on the hosting platforms and the developer/operator experience, not just the spec. With Radius we're providing an implementation that's meant to be re-used and hosted in different scenarios. Right now we're focused on Kubernetes. Radius is also taking a more holistic approach with Radius that's bigger than just compute and networking. We're doing more to work with existing tools like Terraform as well that are outside of Kubernetes. Lastly, Radius puts a lot of emphasis on the developer and operator handoff by building features such as Recipes and Environments that bind an application to different cloud providers and runtime platforms.

### How does Radius compare to Waypoint?

[HCP Waypoint](https://developer.hashicorp.com/hcp/docs/waypoint) is a HashiCorp-managed application deployment platform that simplifies the process of deploying applications into your infrastructure and helps you standardize your deployment process.

While Radius also is able to model and deploy applications, it also provides an application graph and Recipes to offer an end-to-end platform that is application-focused at every stage. Radius is more than an abstraction and deployment automation. The Radius app graph allows teams to understand their entire application and all the dependencies within it, even after an application is deployed. Recipes are also more than template automation. They provide abstraction + encapsulation so developers never are required to directly interact with cloud infrastructure templates or parameters.

### How does Radius compare to Tanzu?

[Tanzu](https://tanzu.vmware.com/) is a portfolio of products and services for modernizing applications and infrastructure with a common goal: deliver better software to production, continuously.

Radius is an open-source project that provides a platform for modeling and deploying applications. Radius is not a paid product or service. Instead, Radius allows you to host your own Radius environments on your own Kubernetes clusters, and deploy applications to any cloud provider or on-premises infrastructure. Radius provides differentiated value through Recipes and the Application Graph. Recipes make it easier for developers and platform engineers/IT engineers to collaborate when building cloud native apps. The Application Graph makes it easier to see all of the various components that make up a cloud native application.

### How does Radius compare to Backstage?

[Backstage](https://backstage.io/) is an open platform for building developer portals. It provides a common way to define and manage services, and a central place for developers to discover and connect to those services.

Radius and the application graph could easily fit into Backstage as a plugin. This is on our backlog and is being explored.

### How does Radius compare to Azure Deployment Environments?

[Azure Deployment Environments](https://azure.microsoft.com/products/deployment-environments/) allow developers to quickly spin up infrastructure environments with project-based templates. It handles template curation via catalogs of templates, and provides a self-service experience for developers to deploy and manage their environments without needing direct access to the underlying Azure resource groups.

Radius Recipes provide a similar experience for developers to deploy and manage infrastructure, but with a few key differences:

- Recipes are defined on a per-resource basis instead of per-environment. This allows developers to "mix and match" resources in any combination and swap out the backing Recipe depending on which environment they are targeting.
- Recipes support both Bicep and Terraform, allowing operators to leverage existing Terraform modules.
- Recipes support both Azure and AWS, allowing operators to manage infrastructure across multiple cloud providers.

### How does Radius compare to Azure Arc?

[Azure Arc](https://azure.microsoft.com/services/azure-arc/) is a set of technologies that extends Azure management and services to any infrastructure. It brings Azure services and management to any infrastructure.

Radius is an open-source project that provides a platform for modeling and deploying applications that can run across Azure, AWS, or private clouds. Instead of extending an existing cloud platform, Radius is a new platform that sits above existing cloud platforms and provides a consistent way to model and deploy applications across these platforms.

While there isn't direct support for targeting Azure Arc for Radius containers today, Arc services and infrastructure can be modeled and deployed using [Recipes]({{< ref "/guides/recipes/overview" >}}).

### How does Radius compare to Azure Container Apps?

[Azure Container Apps](https://azure.microsoft.com/products/container-apps/) is a service that allows developers to deploy containerized applications to Azure without managing any infrastructure.

While Radius only supports Kubernetes today, it is architected to support other hosting platforms in the future, including serverless platforms such as Azure Container Apps. Serverless support is on our roadmap.

### How does Radius compare to .NET Aspire?

[.NET Aspire](https://learn.microsoft.com/dotnet/aspire/get-started/aspire-overview) is an opinionated, cloud ready stack for building .NET applications. .NET Aspire is delivered through a collection of NuGet packages that provide a batteries-included experience for building cloud-native applications as well as tools and IDE integration.

Where .NET Aspire is focused on the .NET experience from moving from local development with a debugger to the cloud, Radius is not opinionated about the application runtime and doesn't seek to solve running applications locally as processes. Radius also offers tools for developers and operators to collaborate on an application throughout its lifecycle, such as the application graph and Recipes.

### How does Radius compare to Azure Developer CLI (azd)?

The [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/) is an open-source tool that provides developer-friendly commands to simplify the process of building, deploying, and managing Azure resources. While both azd and Radius are geared towards the development and deployment workflows, the most apparent difference is that azd can be only be used to manage Azure resources, whereas Radius supports multiple cloud providers. Radius also introduces a way to model (and not just deploy) entire applications and automate these through [Recipes]({{< ref "guides/recipes/overview">}}), which allows for complete [separation of concerns]({{< ref "collaboration" >}}) between operators and developers. With azd, even though developers may leverage CLI templates to deploy infrastructure, they still need to understand the underlying infrastructure and how to connect to it.

### How does Radius compare to KubeVela?

[KubeVela](https://kubevela.io/) is an open-source platform that provides a higher level of abstraction for application deployments. Similar to Radius, it allows developers to define applications and their components, deployment across cloud providers or on-prem, and automated infrastructure provisioning with pre-defined templates. However, unlike Radius, KubeVela does not allow for modeling of connections between resources to set environment variables, configure access credentials, and more that make it simpler for developers to deploy and access resources.

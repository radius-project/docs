---
type: docs
title: "Frequently asked questions"
linkTitle: "FAQ"
description: "Commonly asked questions about best practices"
weight: 999
---

## General

### Is Kubernetes required to use Radius? 

Currently yes. Today Kubernetes is the only hosting platform for Radius. We are working on additional hosting platforms and container runtimes, so stay tuned for updates. 

### Can I incrementally adopt, or "try out" Radius?

Yes. Teams can incrementally adopt the Radius platform as they write new applications or add existing applications. Direct connections allow apps with existing platform dependencies (such as Azure and AWS) move to Radius without any code rewrites. Dapr support allows existing Dapr apps to be brought to Radius without any code rewrites as well. Portability and automation can be layered on with Radius portable resources and Recipes. In the future we will add Kubernetes YAML support which enables developers to wrap their existing Kubernetes YAML objects in a Radius container so that they may bring their existing deployments and pods as-is into a Radius application.

### Do I have to self-host Radius? Is there a managed service for Radius? 

Open-source Radius requires that you self-host and run your own Radius instance in your Kubernetes cluster. In the future, we hope for providers to include Radius as a part of their managed service offerings. Stay tuned for updates.

### What languages does Radius support? 

For core application source code, Radius supports any language as long as it is containerized. 

For Radius application and environment definitions, Radius currently only supports Bicep. Terraform is on our backlog and is being investigated. Stay tuned for updates. 

For Recipes, Radius supports both Bicep and Terraform. Recipe templates can be mixed and matched, and may differ from the application definition. For example, a developer may define their application in Bicep, while the Recipe templates for infrastructure are written in Terraform by IT ops. Additional Recipe languages are being investigated and will be added in a future release.

## Environments

### Can I connect to an existing environment?

Yes. When you initialize an environment via `rad init`, you can provide an existing Kubernetes cluster context. Radius will update your `config.yaml` file with the appropriate values.

### When would/should I use more than one environment?

Users can employ multiple environments for isolation and organization, for example based on:
- Permissions (managed at the Resource Group/Subscription level in Azure)
- Purpose (dev vs. prod)
- Difference in hosting (standalone Kubernetes vs Microsoft Azure)

## Recipes

### What resources can Recipes deploy? 

Recipes support any resource that can be modeled in Bicep, or that has an applicable Terraform provider. Radius can use any Terraform provider. 

### What resources do Recipes support?

Recipes currently support the set of Radius portable resources: Redis, Mongo, RabbitMQ, SQL, Dapr State Stores, Dapr Secret Stores, Dapr Pub/Sub, the untyped extender resource, and more to come in the future. See the [Radius resource schema]({{< ref resource-schema >}}) for more details. Additional support for other resources (Azure, AWS, etc.) will come in a future release. Stay tuned for updates. 

### Do developers need contributor or owner access to a cloud provider (Azure subscription, AWS account, etc.) to leverage Radius Recipes? 

No. Recipes are deployed on-behalf-of the Radius environment so developers do not need any write access to an Azure subscription, resource group, or AWS account. This allows a least-privilege access model to cloud resources and for IT operators to only allow approved IaC templates to be deployed to their cloud environments. 

### Why do I need to manually output a Kubernetes UCP ID as part of my Bicep Recipe?

The Bicep deployment engine currently does not output Kubernetes resource (UCP) IDs upon completion, meaning Recipes cannot automatically link a Recipe-enabled resource to the underlying infrastructure. This also means Kubernetes resources are not automatically cleaned up when a Recipe-enabled resource is deleted.

To fix this, you can manually build and output UCP IDs, which will cause the infrastructure to be linked to the resource:

```bicep
import kubernetes as k8s {
  kubeConfig: ''
  namespace: 'default'
}

resource deployment 'apps/Deployment@v1' = {...}

resource service 'core/Service@v1' = {...}

output values object = {
  resources: [
    // Manually build UCP IDs (/planes/<PLANE>/local/namespaces/<NAMESPACE>/providers/<GROUP>/<TYPE>/<NAME>)
    '/planes/kubernetes/local/namespaces/${deployment.metadata.namespace}/providers/apps/Deployment/${deployment.metadata.name}'
    '/planes/kubernetes/local/namespaces/${service.metadata.namespace}/providers/core/Service/${service.metadata.name}'
  ]
}
```

## Bicep templates

### Can one bicep file represent more than one application?

Yes. You can have multiple application resources defined in one file.

### Can a bicep file represent something other than applications?

Yes. Bicep files can contain both Radius resources and Azure resources. Everything in a Bicep file becomes an ARM deployment.

## Resources

### Can I modify a resource after it’s been deployed?

Yes. You will need to modify the resource definition in your .bicep file’s application definition and re-deploy the application.

### What AWS services does Radius support 

Radius applications can include any non-compute AWS service that is also supported by the AWS cloud control API. Compute services (Lambda, Fargate, etc.) will be added in a future release. 

Radius does not currently support direct connections to AWS resources, but it is on the backlog. Stay tuned for updates. 

### What Azure services does Radius support? 

Radius applications can include any non-compute Azure service, with support for direct connections and managed identities. Compute services (Web Apps, Container Apps, App Service, Functions, Logic Apps, and others) will be added in a future release. 

### Does Radius support Google Cloud Platform (GCP)? 

Partially, yes. Radius Recipes can include GCP resources, as long as they provide an API that matches one of the Radius portable resources (SQL, Mongo, Redis, etc.). Radius does not yet support direct connections or identity integration with GCP resources. 

### Does Radius support Dapr? 

Yes. Radius has first-class support for Dapr building blocks such as state stores, secret stores, and pub/sub brokers. Developers can add Dapr resources to their applications and operators can define Recipes that deploy and manage the underlying infrastructure. 
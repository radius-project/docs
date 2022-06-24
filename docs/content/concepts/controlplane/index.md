---
type: docs
title: Project Radius control-plane services
linkTitle: Control-plane
description: Learn how the Project Radius control-plane services deploy and manage your applications
weight: 300
---

## Overview

The Project Radius control-plane is a set of services that accepts a Radius application definition and deploys it to the target platform.

<img src="controlplane-services.png" alt="Diagram of the Project Radius control-plane services" width="700" />

## Services

| Service | Description | Self-hosted | Microsoft Azure |
|---------|-------------|-------------|-----------------|
| **Universal control plane (UCP)/<br />Azure Resource Manager (ARM)** | The "front door" to the control-plane services. Provides authentication, authorization, routing, and other central capabilities. | Self-hosted UCP service | Azure Resource Manager (ARM) |
| **Radius resource provider (RP)** | Manages Radius applications and app-model resources. | Self-hosted RP service | Central `Applications.*` Azure resource provider |
| **Deployment engine (DE)** | Orchestrates UCP and ARM deployments when Bicep or ARM JSON is used to deploy. | Self-hosted DE service | Azure Resource Manager (ARM) |

### Universal control plane

The universal control plane (UCP) provides the front-door endpoint, authentication, authorization, and other central capabilities for a self-hosted Radius environment. When deploying to a Radius environment using a deployment JSON file (Bicep) or through single imperative commands (CLI, Terraform), UCP handles the request and sends it to the appropriate plane.

Learn more about the deployment flows:

{{< tabs "Self-hosted template" "Self-hosted imperative" "Azure template" "Azure imperative" >}}

{{% codetab %}}
When using Bicep to author and deploy Radius applications:

- A template is sent from UCP to the deployment engine (DE) for processing and orchestration
- DE interacts with the Radius RP to manage Radius resources, and with external planes for other resource types (Kubernetes, Azure, etc.)
- The RP handles CRUDL operations for Radius applications, connectors, and other app-model resources

<img src="ucp-selfhosted.png" alt="Diagram of the UCP on a self-hosted environment with template deployment" width="1000" />
{{% /codetab %}}

{{% codetab %}}
When using Terraform or the rad CLI to deploy and interact with Radius applications:

- UCP routes the CRUDL requests directly to the Radius RP.
- The client (CLI, Terraform) acts as the DE in this case, bypassing the built-in DE.

<img src="ucp-selfhosted-imperative.png" alt="Diagram of the UCP on a self-hosted environment with imperative deployment" width="1000" />
{{% /codetab %}}

{{% codetab %}}
In Microsoft Azure environments, Azure Resource Manager (ARM) is used instead of UCP.

- A template is sent from ARM to the deployment engine (DE) for processing and orchestration
- DE interacts with the Radius RP to manage Radius resources, other RPs for other Azure resource types, and with external planes for other resources (Kubernetes)
- The RP handles CRUDL operations for Radius applications, connectors, and other app-model resources

<img src="azure-deployment.png" alt="Diagram of the Azure environment with template deployment" width="1000" />
{{% /codetab %}}

{{% codetab %}}
In Microsoft Azure environments, Azure Resource Manager (ARM) is used instead of UCP.

- ARM routes the CRUDL requests directly to the Radius RP.
- The client (CLI, Terraform) acts as the DE in this case, bypassing the built-in DE.

<img src="azure-imperative.png" alt="Diagram of the Azure environment with imperative deployment" width="1000" />
{{% /codetab %}}

{{< /tabs >}}

### Radius resource provider

The Radius resource provider handles CRUDL requests for Radius applications, connectors, and other app-model resources. The resource provider is split into two namespaces:

- **Applications.Core**: The _core_ resources of an application, including the application itself, containers, gateways, and routes.
- **Applications.Connectors**: The _connector_ resources that can be used within an application.

Backing resources may be created deleted by the Radius RP for some resources. For example, a Radius container creates a backing Pod or Container App on the target platform and container runtime.

### Deployment engine

The DE service is used when Bicep or ARM JSON is used to deploy Radius applications. It parses and builds the dependency graph of resources and orchestrates the CRUDL requests to the respective resource providers.

For imperative commands (CLI, Terraform), the DE is bypassed and the client (CLI, Terraform) acts as the DE.


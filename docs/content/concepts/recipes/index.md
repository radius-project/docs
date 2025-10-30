---
type: docs
title: "Recipes Concepts"
linkTitle: "Recipes"
description: "How Recipes are used to deploy resources"
weight: 20
---

Recipes are how resources are deployed. The generic term *recipe* is used because Radius uses existing Infrastructure as Code (IaC) solutions to perform the actual deployment of resources. Today, Radius supports deploying resources using both Terraform configurations and Bicep templates, but Radius is designed to integrate with other IaC solutions in the future. Just as Resource Types can represent any resource, Recipes can deploy any resource supported by the IaC language. As long as there is a Terraform provider or Bicep extension, Radius can deploy that resource. In fact, if you have an existing Terraform configurations or Bicep template, it can be used as a Recipe with only minor changes.

This concepts page discusses how Radius makes using Terraform and Bicep easier to deploy resources.

## How Recipes are executed

Recipes can be any new or existing Terraform configurations or Bicep template. When a resource is deployed via Radius, the Radius control plane (specifically the Application Resource Provider) cross references the Resource Type and Environment to determine which Recipe to execute. It then executes the Terraform or Bicep binary within the Application RP container and passes the Recipe location as a command-line argument.

When executing the Terraform or Bicep binaries, Radius does several things:

1. Performs `terraform init` if needed and sets up a Terraform backend using a Kubernetes secret.
1. Sets up authentication to OCI registries where Bicep templates are stored using settings in the Environment.
1. Sets up authentication to Git repositories where Terraform configurations are stored using settings in the Environment.
1. Sets environment variables with AWS and Azure credentials. These are well-know environment variables used by AWS and Azure Terraform providers and Bicep.
1. Passes in a Terraform variable or Bicep parameter called `context` which is discussed in detail below.
1. Passes in any Recipe parameters set on the Environment as a Terraform variable or Bicep parameter.
1. Reads the `result` output and updates the resource in Radius (also discussed below).

## The Recipe context object

{{< image src="context.png" width="70%" alt="Recipe context sources" >}}

Radius automatically injects a `context` object when deploying resources. The `context` object is rich with *contextual* information about the Environment, Application, and resource. When Recipes use the information stored in `context`, the amount of information needed from developers is significantly reduced.  needed to deploy the resource. This includes:

- The Application name
- The Environment name as well as Kubernetes, AWS, and Azure details
- Parameters specified in the Environment definition
- The resource name and all of its properties
- All connected resources and their properties

By using the `context` object, Recipes have all the information needed to deploy the actual resource in the target location.

## Recipe outputs

Once the Recipe has been executed, Radius looks for a `result` output. The `result` output should contain output values for each of the read-only properties defined in the Resource Type so that Radius can set the read-only properties for use in the application definition. The `result` output should also include the resources created so Radius can track dependencies and manage deletions.

<br>
{{< button text="Next step: Read about Environments concepts" page="concepts/environments" >}}

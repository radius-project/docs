---
type: docs
title: "Frequently asked questions"
linkTitle: "FAQ"
description: "Commonly asked questions about best practices"
weight: 999
---

## Applications

### Can I incrementally adopt, or "try out" Radius?

**Yes**. You can use the [Bicep `existing` keyword](https://docs.microsoft.com/azure/azure-resource-manager/bicep/resource-declaration?tabs=azure-powershell#existing-resources) to add a Radius application to previously deployed resources. Learn more in the [Radius authoring guide]({{< ref author-apps >}}). In the future we will also support other experiences in Bicep and the Azure portal for adding Radius to existing resources.

## Environments

### Can I connect to an existing environment?

**Yes**. When you initialize an environment via [`rad env init`]({{< ref rad_env_init.md >}}), you can provide an existing Kubernetes cluster context. Radius will update your `config.yaml` file with the appropriate values.

### When would/should I use more than one environment?

Users can employ multiple environments for isolation and organization, for example based on:
- Permissions (managed at the Resource Group/Subscription level in Azure)
- Purpose (dev vs. prod)
- Difference in hosting (standalone Kubernetes vs Microsoft Azure)

## Bicep templates

### Can one bicep file represent more than one application?

**Yes**. You can have multiple application resources defined in one file.

### Can a bicep file represent something other than applications?

**Yes**. Bicep files can contain both Radius resources and Azure resources. Everything in a Bicep file becomes an ARM deployment.

## Resources

### Can I modify a resource after it’s been deployed?

**Yes**. You will need to modify the resource definition in your .bicep file’s application definition and re-deploy the application.

### Is Azure App Service supported?

**Not yet**. For now we're focusing on containers, but in the future we plan on expanding to other Azure services such as App Service, Functions, Logic Apps, and others. Stay tuned for more information.

## Does Radius support all Azure resources?

**Yes**. You can use any Azure resource type by modeling it in Bicep outside the `Applications.Core/applications` resource and defining a connection to the resource from a `Applications.Core/containers`. See the [connections page]({{< ref appmodel-concept >}}) for more details.

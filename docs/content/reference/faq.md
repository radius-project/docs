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

**Yes**. When you initialize an environment via `rad init`, you can provide an existing Kubernetes cluster context. Radius will update your `config.yaml` file with the appropriate values.

### When would/should I use more than one environment?

Users can employ multiple environments for isolation and organization, for example based on:
- Permissions (managed at the Resource Group/Subscription level in Azure)
- Purpose (dev vs. prod)
- Difference in hosting (standalone Kubernetes vs Microsoft Azure)

## Recipes

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

**Yes**. You can have multiple application resources defined in one file.

### Can a bicep file represent something other than applications?

**Yes**. Bicep files can contain both Radius resources and Azure resources. Everything in a Bicep file becomes an ARM deployment.

## Resources

### Can I modify a resource after it’s been deployed?

**Yes**. You will need to modify the resource definition in your .bicep file’s application definition and re-deploy the application.

### Is Azure App Service supported?

**Not yet**. For now we're focusing on containers, but in the future we plan on expanding to other Azure services such as App Service, Functions, Logic Apps, and others. Stay tuned for more information.

### Does Radius support all Azure resources?

**Yes**. You can use any Azure resource type by modeling it in Bicep outside the `Applications.Core/applications` resource and defining a connection to the resource from a `Applications.Core/containers`. See the [connections page]({{< ref application-graph>}}) for more details.

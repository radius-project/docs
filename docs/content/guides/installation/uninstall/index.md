---
type: docs
title: "How-To: Uninstall Radius on Kubernetes"
linkTitle: "Uninstall"
description: "Learn how to uninstall Radius on Kubernetes"
weight: 400
categories: "How-To"
tags: ["Kubernetes"]
aliases: 
- /guides/operations/kubernetes/kubernetes-uninstall
---

## Uninstall Radius 

To uninstall the existing Radius installation, use any of the following commands:

{{< tabs "Uninstall" "Uninstall with purge" >}}

{{% codetab %}}
```bash
rad uninstall kubernetes
```
You should see the Helm releases that will be removed and prompted for user confirmation:

```
About to uninstall Radius. This will remove:
- Helm releases: radius, contour
                                              
Continue uninstalling Radius?                 
  >  1. No                         
```

Select `Yes`. All the Radius services running in the `radius-system` namespace will be removed. Note that the Radius configuration and data will still be persisted in the cluster.

{{% /codetab %}}
{{% codetab %}}

```bash
rad uninstall kubernetes --purge
```

You should see the list of all the Radius resources that will be removed and prompted for user confirmation 

```
About to uninstall Radius. This will remove:
- Helm releases: radius, contour
- Radius environments:
  • /planes/radius/local/resourcegroups/default/providers/Applications.Core/environments/default (namespace default)
- Kubernetes namespaces: radius-system
- Kubernetes namespaces (skipped): default
- Kubernetes API services: v1alpha3.api.ucp.dev
- Kubernetes custom resource definitions: deploymentresources.radapp.io, deploymenttemplates.radapp.io, recipes.radapp.io, queuemessages.ucp.dev, resources.ucp.dev
                                              
Continue uninstalling Radius?                 
  >  1. No                                    
```

Select `Yes`. This will delete all the Radius data from your cluster.

{{% /codetab %}}
{{< /tabs >}}

## Remove the rad CLI

You can remove the rad CLI by deleting the `rad` binary under `/usr/local/bin/` and `~/.rad` folder from your machine.

---
type: docs
title: "Radius application"
linkTitle: "Application"
description: "Learn how to model your application and its services in Radius "
weight: 100
categories: "How-To"
tags: ["application"]
---
## Overview

An [application]({{< ref appmodel-concept >}}) is the parent resource that contains all of your services and relationships. It is the top-level resource in your Bicep file.
{{< rad file="snippets/blank.bicep" embed=true >}}

## Customizations

Extensions allow you to customize how resources are generated or customized as part of deployment.

### Kubernetes Namespace extension

The Kubernetes namespace extension allows you to customize how all of the resources within your application generate Kubernetes resources. See the [Kubernetes mapping guide]({{< ref kubernetes-mapping >}}) for more information on namespace mapping behavior

{{< rad file="snippets/namespace-extension.bicep" embed=true >}}

### Kubernetes Metadata extension

The [Kubernetes Metadata extension]({{< ref "/operations/platforms/kubernetes/kubernetes-metadata">}}) enables you set and cascade Kubernetes metadata such as labels and Annotations on all the Kubernetes resources defined with in your Radius application 

{{< rad file="snippets/metadata-extension.bicep" embed=true >}}

## Resource schema 


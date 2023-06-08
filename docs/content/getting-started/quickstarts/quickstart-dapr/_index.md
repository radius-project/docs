---
type: docs
title: "Quickstart: Dapr Microservices"
linkTitle: "Dapr microservices"
description: "Learn Project Radius by authoring templates and deploying a Dapr application"
weight: 300
no_list: true
slug: "dapr"
categories: "Quickstart"
tags : ["Dapr"]
---

## Overview

This tutorial will teach you how to deploy a Dapr microservices application using Radius. You will learn:  

- The concepts of the Radius application model
- How [Dapr and Radius]({{< ref dapr-resources >}}) seamlessly work together  
- The basic syntax of the [Bicep language]({{< ref bicep >}})

No prior knowledge of Dapr, Radius, or Bicep is needed.

### Quickstart steps

In this tutorial, you will:

1. Review and understand the Radius Dapr microservices application
1. Deploy the backend container
1. Deploy and connect a Dapr statestore resource
1. Add a frontend container to submit orders to the backend

### Project Radius + Dapr

Dapr integrates directly with Project Radius to provide a simple, easy to use, and powerful way to build microservices. Dapr developers can:

- Model Dapr building blocks as [Radius link resources]({{< ref dapr-schema >}})
- Automatically generate Dapr component configuration files based on the source resource
- (coming soon) Automatically configure component scoping and other secure configuration based upon connections to the Dapr links

## Prerequisites

- [Radius CLI]({{< ref "getting-started" >}})
- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/)
- [Visual Studio Code](https://code.visualstudio.com/) (recommended)
  - The [Radius VSCode extension]({{< ref "getting-started" >}}) provides syntax highlighting, completion, and linting.
  - You can also complete this quickstart with any basic text editor.
- [Install Dapr](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-deploy/) 

### Initialize a Radius environment

This tutorial can be completed on any platform Radius supports. To get started, create a new environment:

{{< tabs Kubernetes >}}

{{% codetab %}}
A Radius environment can be created in any [supported Kubernetes cluster]({{< ref "/operations/platforms/kubernetes#supported-clusters" >}}):

```sh
rad init
```

If you wish to deploy an Azure storage account in an upcoming step follow the instructions to setup an Azure [cloud provider]({{< ref providers >}}).

{{% /codetab %}}

{{< /tabs >}}

## Next step

Now that you have a Radius environment setup let's take a look at the Dapr microservices application:

{{< button text="Next: Application overview" page="dapr-microservices-overview.md" >}}

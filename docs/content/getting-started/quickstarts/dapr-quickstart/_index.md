---
type: docs
title: "Dapr Microservices Tutorial"
linkTitle: "Dapr microservices"
description: "Learn Project Radius by authoring templates and deploying a Dapr application"
weight: 100
no_list: true
---

## Overview

This tutorial will teach you how to deploy a Dapr microservices application using Radius. You will learn:  

- The concepts of the Radius application model
- How Dapr and Radius seamlessly work together  
- The basic syntax of the Bicep language

No prior knowledge of Dapr, Radius, or Bicep is needed.

### Tutorial Steps

In this tutorial, you will:

1. Review and understand the Radius Dapr microservices application
1. Deploy the frontend code in a container
1. Connect a Dapr statestore resource
1. Connect a python-based order generator  

## Prerequisites

- [Install Radius CLI]({{< ref "getting-started#install-radius-cli" >}})
- Install CLI for target platform:
  - [kubectl CLI](https://kubernetes.io/docs/tasks/tools/) for local and Kubernetes environments
  
- [Install Visual Studio Code](https://code.visualstudio.com/) (recommended)
  - The [Radius Bicep VSCode extension]({{< ref "getting-started#setup-vscode" >}}) provides syntax highlighting, completion, and linting.
  - You can also complete this tutorial with any basic text editor.

### Initialize a Radius environment

This tutorial can be completed on any platform Radius supports. To get started, create a new environment:

{{< tabs Kubernetes >}}

{{% codetab %}}
A Kubernetes envionment can run in any Kubernetes cluster. Make sure you have set the correct default kubectl context, and then run:

```sh
rad env init kubernetes
```

{{% /codetab %}}

{{< /tabs >}}

<br />
{{< button text="Application overview" page="dapr-microservices-overview.md" >}}

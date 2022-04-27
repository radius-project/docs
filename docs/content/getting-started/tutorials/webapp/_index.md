---
type: docs
title: "Website + database tutorial"
linkTitle: "Website + database"
description: "Learn Project Radius by authoring templates and deploying a website with a database."
weight: 100
no_list: true
---

## Overview

This tutorial will teach you how to deploy a website as a Radius application from first principles. You will learn:  

- The concepts of the Radius application model
- The basic syntax of the Bicep language

No prior knowledge of Radius or Bicep is needed.

### Tutorial steps

In this tutorial, you will:

1. Review and understand the Radius website application
1. Deploy the website frontend in a container
1. Connect a MongoDB resource to your website application

## Prerequisites

- [Install Radius CLI]({{< ref "installing-radius#install-radius-cli" >}})
- Install CLI for target platform:
  - [k3d CLI](https://github.com/k3d-io/k3d/releases) for local environments
  - [az CLI](https://docs.microsoft.com/cli/azure/install-azure-cli) for Azure environments
  - [kubectl CLI](https://kubernetes.io/docs/tasks/tools/) for Kubernetes environments
- [Install Visual Studio Code](https://code.visualstudio.com/) (recommended)
  - The [Radius VSCode extension]({{< ref "getting-started#setup-vscode" >}}) provides syntax highlighting, completion, and linting.
  - You can also complete this tutorial with any basic text editor.

### Initialize a Radius environment

This tutorial can be completed on any platform Radius supports. To get started, create a new environment:

{{< tabs Local Kubernetes Azure >}}

{{% codetab %}}
To create a local dev environment on top of Docker, run:

```sh
rad env init dev
```

{{% /codetab %}}

{{% codetab %}}
A Kubernetes envionment can run in any Kubernetes cluster. Make sure you have set the correct default kubectl context, and then run:

```sh
rad env init kubernetes
```

{{% /codetab %}}

{{% codetab %}}
To deploy an Azure environment to your Azure subscription, run:

```sh
rad env init azure -i
```

{{% /codetab %}}

{{< /tabs >}}

<br>{{< button text="Next: application overview" page="webapp-overview.md" >}}

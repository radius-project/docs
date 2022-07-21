---
type: docs
title: "Tutorial for Project Radius"
linkTitle: "Tutorial"
description: "Walk through an in-depth example to learn more about how to work with Radius concepts"
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

- [Install Radius CLI]({{< ref "getting-started#install-radius-cli" >}})
- Install CLI for target platform:
  - [kubectl CLI](https://kubernetes.io/docs/tasks/tools/) for Kubernetes environments
- [Install Visual Studio Code](https://code.visualstudio.com/) (recommended)
  - The [Radius VSCode extension]({{< ref "getting-started#setup-vscode" >}}) provides syntax highlighting, completion, and linting.
  - You can also complete this tutorial with any basic text editor.

### Initialize a Radius environment

A Radius Kubernetes envionment can run in a Kubernetes cluster running on any platform. 

You can view the current context for kubectl by running
```bash
kubectl config current-context
```

Then run the following command to initialize a Radius Kubernetes environment:
```sh
rad env init kubernetes
```

<br>{{< button text="Next: application overview" page="webapp-overview.md" >}}

---
type: docs
title: "Getting Started"
linkTitle: "Getting Started"
description: "Install Radius, deploy your first application, and add a connection"
weight: 100
aliases:
  - /quick-start/
  - /tutorials/
  - /getting-started/tutorial/
  - /getting-started/install/
  - /getting-started/first-app/
---

Install Radius on a Kubernetes cluster, deploy the Radius Demo sample application, and add a Redis cache connection. This tutorial uses the default Kubernetes Recipe Pack, which deploys the application and its resources to Kubernetes. You can use a local kind or k3d cluster without an AWS account or Azure subscription.

## Deploying to AWS or Azure

Radius also supports [Amazon EKS and Azure Kubernetes Service (AKS)]({{< ref "installation#supported-kubernetes-clusters" >}}). Running this tutorial on either service still deploys its resources through the default Kubernetes recipes.

To use AWS or Azure cloud resources, [configure cloud credentials, an Environment, and Recipe Packs]({{< ref "aws-and-azure" >}}). Recipes determine which cloud services implement the application's Resource Types. See [how application definitions work across AWS and Azure]({{< ref "concepts#deploying-across-aws-and-azure" >}}).

## Organization

This guide is organized into four sequential parts.

After the tutorial, explore the [hands-on labs]({{< ref "getting-started/labs" >}}) for deeper, scenario-based projects.

{{< button text="Get started: Install Radius" page="getting-started/install-radius" >}}

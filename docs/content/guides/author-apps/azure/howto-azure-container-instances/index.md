---
type: docs
title: "How-To: Configure an Environment and deploy an Application to Azure Container Instances"
linkTitle: "Deploy to ACI"
description: "Learn how to configure an Environment and deploy an Application to Azure Container Instances"
weight: 500
slug: 'azure-container-instances'
categories: "How-To"
tags: ["Azure","containers"]
---

This how-to guide will provide an overview of how to:

- TODO

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- Radius installed and initiated on a [supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
<!-- - [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) installed in your cluster, including the [Mutating Admission Webhook](https://azure.github.io/azure-workload-identity/docs/installation/mutating-admission-webhook.html) -->

## Step 1: TODO

## Cleanup

1. Run the following command to delete your app and container:

   ```bash
   rad app delete myapp --yes
   ```
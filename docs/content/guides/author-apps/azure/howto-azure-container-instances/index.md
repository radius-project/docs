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

- Configure and deploy a Radius Environment that uses Azure Container Instances (ACI) as the compute provider.
- Define and deploy a Radius Application to the Environment that provisions the necessary resources to run the application containers in ACI.

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- Radius installed and initiated on a [supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
- Azure provider configured and registered with your Radius control plane, either through [Service Principal](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-sp/) or [Workload Identity](https://docs.radapp.io/guides/operations/providers/azure-provider/howto-azure-provider-wi/)
- A [user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp) that has been [assigned](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal-managed-identity) to the `Contributor` and `Azure Container Instances Contributor` roles on the subscription or resource group where the ACI will be deployed

## Step 1: TODO

## Cleanup

1. Run the following command to delete your app and container:

   ```bash
   rad app delete myapp --yes
   ```
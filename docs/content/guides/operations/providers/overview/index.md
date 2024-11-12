---
type: docs
title: "Overview: Cloud providers"
linkTitle: "Overview"
description: "Deploy across clouds and platforms with Radius cloud providers"
weight: 100
categories: "Overview"
tags: ["AWS","Azure"]
---

Radius cloud providers allow you to deploy and connect to cloud resources across various cloud platforms. For example, you can use the Radius Azure provider to run your application's services in your Kubernetes cluster, while deploying Azure resources to a specified Azure subscription and resource group.

{{< image src="providers-overview.png" alt="Diagram of cloud resources getting forwarded to cloud platforms upon deployment" width="800px" >}}

## Supported cloud providers and identities

| Provider | Identity | Description |
|----------|----------|-------------|
| [Microsoft Azure]({{< ref azure-provider >}}) | [Service Principal](https://learn.microsoft.com/en-us/entra/identity-platform/app-objects-and-service-principals?tabs=browser) | Deploy and connect to Azure resources using Service Principal |
| | [Workload Identity](https://learn.microsoft.com/en-us/entra/workload-id/workload-identities-overview) | Deploy and connect to Azure resources using Workload Identity |
| [Amazon Web Services]({{< ref aws-provider >}}) | [IAM access Key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) | Deploy and connect to AWS resources using IAM Access Key |
| | [IAM Roles for Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) | Deploy and connect to AWS resources using AWS IRSA |

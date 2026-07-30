---
type: docs
title: "How to configure cloud provider credentials"
linkTitle: "Cloud provider credentials"
description: "Learn how to configure cloud provider credentials to enable Radius to deploy applications to AWS or Azure"
weight: 300
aliases:
  - /guides/installation/cloud-providers/
  - /guides/installation/cloud-providers/aws/
  - /guides/installation/cloud-providers/azure/
  - /guides/installation/providers/
  - /guides/installation/providers/overview/
---

Out of the box, Radius deploys all applications and resources to Kubernetes. In order to deploy to AWS or Azure, you must configure credentials that allow Radius to manage resources in your cloud environment.

## Supported cloud providers and identities

| Provider | Identity | Description |
|----------|----------|-------------|
| Amazon Web Services | [IAM access key]({{< ref "/installation/cloud-providers/aws-access-key" >}}) | Deploy and connect to AWS resources using an IAM access key |
| | [IAM Roles for Service Accounts (IRSA)]({{< ref "/installation/cloud-providers/aws-irsa" >}}) | Deploy and connect to AWS resources using AWS IRSA |
| Microsoft Azure | [Service Principal]({{< ref "/installation/cloud-providers/azure-service-principal" >}}) | Deploy and connect to Azure resources using a Service Principal |
| | [Workload Identity]({{< ref "/installation/cloud-providers/azure-workload-identity" >}}) | Deploy and connect to Azure resources using Workload Identity |

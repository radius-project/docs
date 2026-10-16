---
type: docs
title: "How to configure cloud provider credentials"
linkTitle: "Cloud provider credentials"
description: "Register AWS or Azure credentials so Radius can provision cloud resources."
weight: 300
url: /installation/cloud-credentials/
---

Radius uses cloud credentials to provision AWS and Azure resources. Choose a guide below to register an AWS IAM access key, configure IAM Roles for Service Accounts (IRSA), register an Azure service principal, or configure Azure workload identity. The identity needs permission to provision the resources your recipes create.

Credentials authorize access to cloud resources. The Environment and its Recipe Packs determine where and how those resources are deployed. See [Configure AWS and Azure deployments]({{< ref "/aws-and-azure" >}}) for the complete setup path.

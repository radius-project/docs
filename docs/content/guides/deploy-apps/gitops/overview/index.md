---
type: docs
title: "Overview: Radius and GitOps"
linkTitle: "Overview"
description: "Learn about how to leverage GitOps tools to deploy Radius resources"
weight: 100
categories: "Overview"
tags: ["gitops", "continuous", "delivery" "deployment"]
---

Radius integrates seamlessly with GitOps to enhance the continuous deployment and management of cloud-native applications and infrastructure. Currently, Radius supports [Flux](https://fluxcd.io/), with [ArgoCD](https://argoproj.github.io/cd/) support coming in the future.

## What is GitOps?

GitOps is a popular set of practices, implemented as popular tools, like [Flux](https://fluxcd.io/) and [ArgoCD](https://argoproj.github.io/cd/), that mitigates these challenges for enterprise application teams that use git for source control and Kubernetes for orchestration of software containers. The core concept of GitOps is to rely on a git repository that serves as a single source of truth: i.e. it contains current declarative descriptions of the required infrastructure for a given production environment. It also contains a description of the workflow required to prevent drift between the repo and the production environment. Using GitOps, developers and operatations can manage applications in production without needing to write custom scripts or maintain complex CD pipelines.

## Key Features

1. **Declarative Configuration**: Radius allows users to define their infrastructure and application configurations declaratively in Git repositories. This ensures that the desired state of the system is version-controlled and easily auditable.

2. **Continuous Deployment**: With GitOps, any changes pushed to the Git repository automatically trigger deployment processes. Radius integrates with GitOps tools to facilitate continuous deployment, ensuring that the production environment always matches the state defined in the repository.

3. **Drift Detection and Reconciliation**: Radius continuously monitors the production environment for any drift from the desired state defined in the Git repository. If any discrepancies are detected, Radius can automatically reconcile the state to match the repository, maintaining consistency and reliability.

4. **Enhanced Security and Compliance**: By using Git as the single source of truth, Radius ensures that all changes are tracked and auditable. This enhances security and compliance, as every change is documented and can be reviewed.

5. **Scalability and Flexibility**: Radius's integration with GitOps tools supports scalable and flexible deployment strategies. Whether deploying to a single cluster or multiple clusters across different environments, Radius provides a consistent and reliable deployment process.

## Benefits

- **Improved Collaboration**: Teams can collaborate more effectively by using Git repositories to manage configurations. Changes can be reviewed, discussed, and approved through standard Git workflows.
- **Reduced Operational Complexity**: By automating deployments and reconciliations, Radius reduces the operational complexity associated with managing cloud-native applications and infrastructure.
- **Increased Reliability**: Continuous monitoring and automatic reconciliation ensure that the production environment remains consistent with the desired state, increasing the reliability of deployments.

## Getting Started

To get started with Radius and GitOps integration, check out the [how-to guide for Flux](TODO).
---
type: docs
title: "Overview: Radius and GitOps"
linkTitle: "Overview"
description: "Learn about how to leverage GitOps tools to deploy Radius resources"
weight: 100
categories: "Overview"
tags: ["gitops", "continuous", "delivery" "deployment"]
---

Radius integrates seamlessly with GitOps to enhance the continuous deployment and management of cloud-native applications and infrastructure. GitOps is a set of practices that uses Git repositories as the single source of truth for declarative infrastructure and application configurations. By leveraging GitOps tools such as Flux and ArgoCD, Radius provides a robust and efficient way to manage deployments.

### Key Features

1. **Declarative Configuration**: Radius allows users to define their infrastructure and application configurations declaratively in Git repositories. This ensures that the desired state of the system is version-controlled and easily auditable.

2. **Continuous Deployment**: With GitOps, any changes pushed to the Git repository automatically trigger deployment processes. Radius integrates with GitOps tools to facilitate continuous deployment, ensuring that the production environment always matches the state defined in the repository.

3. **Drift Detection and Reconciliation**: Radius continuously monitors the production environment for any drift from the desired state defined in the Git repository. If any discrepancies are detected, Radius can automatically reconcile the state to match the repository, maintaining consistency and reliability.

4. **Enhanced Security and Compliance**: By using Git as the single source of truth, Radius ensures that all changes are tracked and auditable. This enhances security and compliance, as every change is documented and can be reviewed.

5. **Scalability and Flexibility**: Radius's integration with GitOps tools supports scalable and flexible deployment strategies. Whether deploying to a single cluster or multiple clusters across different environments, Radius provides a consistent and reliable deployment process.

### Benefits

- **Improved Collaboration**: Teams can collaborate more effectively by using Git repositories to manage configurations. Changes can be reviewed, discussed, and approved through standard Git workflows.
- **Reduced Operational Complexity**: By automating deployments and reconciliations, Radius reduces the operational complexity associated with managing cloud-native applications and infrastructure.
- **Increased Reliability**: Continuous monitoring and automatic reconciliation ensure that the production environment remains consistent with the desired state, increasing the reliability of deployments.

### Getting Started

To get started with Radius and GitOps integration, follow these steps:

1. **Set Up Git Repository**: Create a Git repository to store your declarative configurations for infrastructure and applications.
2. **Install GitOps Tool**: Install and configure a GitOps tool such as Flux or ArgoCD to manage the continuous deployment process.
3. **Configure Radius**: Integrate Radius with your GitOps tool by configuring the necessary settings and parameters.
4. **Deploy and Monitor**: Push your configurations to the Git repository and let the GitOps tool handle the deployment. Use Radius to monitor and manage the state of your production environment.
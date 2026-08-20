---
type: docs
title: "GitHub Copilot app integration"
linkTitle: "GitHub Copilot app"
weight: 1
new_badge: true
description: "Use Radius with the GitHub Copilot app to model, visualize, and deploy applications"
hide_preview_release_banner: true
---

{{% alert title="Preview Release" color="warning" %}}
Radius integration with the GitHub Copilot app is a preview release. It is only compatible with **containerized applications deployed to Azure**.
{{% /alert %}}

The Radius integration with the GitHub Copilot app helps you understand, model, and deploy applications directly from your source code repository. Ask Copilot to analyze your repository and Radius creates a model of your application that captures your workloads, dependencies, and infrastructure requirements. You can review the model visually, configure a target Environment, and plan and deploy the Application, all from within the GitHub Copilot app.

## How Radius works with GitHub Copilot app

The Radius integration with the GitHub Copilot app is available as the `radius` plugin, which you [install from within the GitHub Copilot app]({{< ref "/getting-started/try-github-copilot-app" >}}). The plugin brings together Radius skills, the Radius Canvas extension, and GitHub Actions workflows.

**Radius skills** let you work with your application through natural language instructions. They help Copilot analyze the source code repository, create and update application definitions, and perform Radius operations on your behalf.

**The Radius Canvas extension** provides the visual experience. It displays the Application graph, shows changes to the application model, previews how the Application will be deployed to an Environment, and enables you to deploy applications.

**GitHub Actions workflows** run the Radius control plane within GitHub Actions to create Environments, verify credentials, deploy applications, and delete deployments. The Radius Canvas extension configures the Radius workflow templates for the Application and Environment, then adds the required workflow files to the application repository.

## What you can do

With the Radius integration for the GitHub Copilot app, you can:

- **Model an application from an existing repository.** Radius analyzes application code and configuration to generate an application definition that captures workloads, resources, and connections.
- **Visualize the application.** Use the Radius Canvas extension to visualize workloads, resources, and connections as an Application graph along with the source code reference for each component.
- **Understand application changes.** Compare application models across branches to see how changes to the source code affect the application architecture and deployment requirements.
- **Configure the Environment.** Create and configure a Radius Environment for the application's deployment target.
- **Preview deployment infrastructure.** See the Application and supporting infrastructure Radius plans to deploy before creating cloud resources.
- **Deploy through GitHub Actions.** Generate a workflow that provisions the required infrastructure and deploys the Application.
- **View deployed applications.** Follow deployment status and inspect the Application running in the selected Environment.
- **Keep deployment artifacts with your code.** Radius artifacts are stored in the repository so the application model and deployment configuration can be versioned and reused across branches and commits.

## From source code to deployed application

The Radius Canvas extension takes your application through four stages:

1. **Model:** Copilot analyzes the repository and creates an application definition in `.radius/app.bicep`.
2. **Plan:** Select an Environment to see how the application's requirements will be fulfilled for that deployment target.
3. **Deploy:** Deploy the Application and its infrastructure through GitHub Actions and view the resulting deployment in the Radius Canvas extension.
4. **Diff:** Compare application models across branches to see how changes to the source code affect the application architecture and deployment requirements.

Because each stage uses the same application definition, the application model you review is also the model Radius uses to plan and deploy the Application.

## Next steps

To install the `radius` plugin and walk through modeling, planning, and deploying an application step by step, follow the hands-on guide.

{{< button text="Get started: Use the GitHub Copilot app" page="/getting-started/try-github-copilot-app" >}}

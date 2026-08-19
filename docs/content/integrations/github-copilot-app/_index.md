---
type: docs
title: "GitHub Copilot App integration"
linkTitle: "GitHub Copilot App"
weight: 1
new_badge: true
description: "Use Radius with the GitHub Copilot App to model, visualize, configure, and deploy applications"
hide_preview_release_banner: true
---

{{% alert title="Public preview" color="info" %}}
Radius Canvas is in public preview and is available only for containerized applications deployed to Azure.
{{% /alert %}}

The Radius integration for the GitHub Copilot App helps you understand, model, and deploy applications directly from your source code repository. Ask Copilot to analyze your repository and Radius creates an application model that captures your workloads, dependencies, connections, and infrastructure requirements. You can review the model visually in Radius Canvas, configure a target Radius Environment, plan and deploy the application all from within the GitHub Copilot App.

## How Radius works with GitHub Copilot App

The Radius integration for the GitHub Copilot App is available as the `radius` plugin. The plugin brings together Radius skills, the Radius Canvas extension, and GitHub Actions workflows.

**Radius skills** let you work with your application through natural language instructions. They help Copilot analyze the source code repository, create and update Radius Application definitions, and perform Radius operations on your behalf.

**Radius Canvas** provides the visual experience. It displays the application graph, shows changes to the application model, previews how the application will be deployed to an Environment, and enables you to deploy applications.

**GitHub Actions workflows** support Environment creation and credential verification, deploy applications, and delete deployments. The Canvas extension configures the Radius workflow templates for the application and Environment, then adds the required workflow files to the application repository.

## What you can do

With the Radius integration for GitHub Copilot, you can:

- **Model an application from an existing repository.** Radius analyzes application code and configuration to generate a Radius Application definition that captures workloads, resources, and connections.
- **Visualize the application.** Use Radius Canvas to visualize workloads, resources, and connections as an application graph along with the source code reference for each component.
- **Understand application changes.** Compare application models across branches to see how changes to the source code affect the application architecture and deployment requirements.
- **Configure the Environment.** Create and configure a Radius Environment for the application's deployment target.
- **Preview deployment infrastructure.** See the application and supporting infrastructure Radius plans to deploy before creating cloud resources.
- **Deploy through GitHub Actions.** Generate a workflow that provisions the required infrastructure and deploys the application.
- **View deployed applications.** Follow deployment status and inspect the application running in the selected Environment.
- **Keep deployment artifacts with your code.** Radius artifacts are stored in the repository so the application model and deployment configuration can be versioned and reused across branches and commits.

## From source code to deployed application

The Radius Canvas extension takes your application through four stages:

1. **Model:** Copilot analyzes the repository and creates a Radius Application definition in `.radius/app.bicep`.
2. **Plan:** Select a Radius Environment to see how the application's requirements will be fulfilled for that deployment target.
3. **Deploy:** Deploy the application and its infrastructure through GitHub Actions and view the resulting deployment in Canvas.
4. **Diff:** Compare application models across branches to see how changes to the source code affect the application architecture and deployment requirements.

Because each stage uses the same Radius Application definition, the application model you review is also the model Radius uses to plan and deploy the application.
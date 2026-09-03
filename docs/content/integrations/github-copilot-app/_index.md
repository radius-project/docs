---
type: docs
title: "GitHub Copilot app integration"
linkTitle: "GitHub Copilot app"
weight: 1
new_badge: true
description: "Use Radius Canvas in the GitHub Copilot app to model, visualize, and deploy applications"
hide_preview_release_banner: true
---

{{% alert title="Preview release" color="info" %}}
The Radius Canvas preview supports containerized applications deployed to Azure.
{{% /alert %}}

The Radius integration for the GitHub Copilot app helps you model, visualize, and deploy applications directly from your source code repository. In Copilot chat, ask Copilot to analyze your repository. Radius creates an application model that captures your workloads, dependencies, connections, and infrastructure requirements. In Radius Canvas, you can review the application graph, configure a target Radius Environment, and plan and deploy the Application to the cloud, all without leaving the GitHub Copilot app.

## How Radius Canvas works

Radius Canvas is bundled with the `radius` plugin for the GitHub Copilot app. The plugin brings together Radius skills, Radius Canvas, and GitHub Actions workflows.

**Radius skills** let you work with your application through natural language instructions. They help Copilot analyze the source code repository, create and update application definitions, and perform Radius operations on your behalf.

**Radius Canvas** visualizes your source code as an **Application graph**, highlights changes to the application, previews the resources planned for an Environment, and lets you deploy Applications.

**GitHub Actions workflows** support Environment creation, credential verification, deploying Applications, and deleting deployments. Radius Canvas configures the Radius workflow templates for the Application and Environment, then adds the required workflow files to the application repository.

## What you can do

With the Radius integration for GitHub Copilot, you can:

- **Model an application from an existing repository.** Radius analyzes application code and configuration to generate an application definition that captures workloads, resources, and dependencies.
- **Visualize the application.** Use Radius Canvas to visualize workloads, resources, and connections in the **Application graph**, along with the source code reference for each component.
- **Understand application changes.** Compare application models across branches to see how source code changes affect the application architecture and deployment requirements.
- **Configure the Environment.** Create and configure a Radius Environment for the application's deployment target.
- **Preview deployment infrastructure.** See the Application and supporting infrastructure that Radius plans to deploy before creating cloud resources.
- **Deploy through GitHub Actions.** Generate a workflow that provisions the required infrastructure and deploys the Application.
- **View deployed Applications.** Follow deployment status and inspect the Application running in the selected Environment.
- **Keep deployment artifacts with your code.** Radius artifacts are stored in the repository so the application model and deployment configuration can be versioned and reused across branches and commits.

## From source code to deployed application

Radius Canvas takes your Application through four stages:

1. **Model:** Copilot analyzes the repository and creates an application definition in `.radius/app.bicep`.
2. **Plan:** Select a Radius Environment to see how the Application's requirements will be fulfilled for that deployment target.
3. **Deploy:** Deploy the Application and its infrastructure through GitHub Actions and view the resulting deployment in Radius Canvas.
4. **Diff:** Compare application graphs across branches to visualize changes to the source code.

Because each stage uses the same application definition, the application model you review is also the model Radius uses to plan and deploy the Application.

## Preview scope

The preview scope focuses on:

- Modeling and deploying containerized applications with a Dockerfile.
- Modeling and deploying one Application from a single repository.
- Deploying Applications to Azure.

Support for additional application structures and cloud providers is planned for future releases.

View the [Radius Canvas roadmap](https://github.com/orgs/radius-project/projects/27/views/1) and vote for the features you would like to see prioritized.

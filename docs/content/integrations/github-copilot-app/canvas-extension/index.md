---
type: docs
title: "How-To: Visualize and deploy applications using Radius Canvas extension"
linkTitle: "Radius Canvas extension"
weight: 100
description: "Install the Radius Canvas extension to model, visualize, and deploy an application from inside the GitHub Copilot app"
aliases:
  - /github-copilot-app/canvas-extension/
  - /github-copilot-integration/use-canvas-extension/
  - /integrations/github-copilot/use-canvas-extension/
  - /github-copilot/use-canvas-extension/
---

This guide walks you through the Radius Canvas extension by modeling and deploying the Docker [Example Voting App](https://github.com/dockersamples/example-voting-app). The sample is a distributed application with voting and results frontends, a worker, Redis, and PostgreSQL.

You install the `radius` plugin, model the sample as a Radius Application, configure an Environment, review the planned deployment, and deploy through GitHub Actions.

## Prerequisites

- The latest version of the [GitHub Copilot app](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app). The canvas runs only in the app.
- An Azure subscription.
- An Azure Kubernetes Service (AKS) cluster.
- `az login` 
- A fork of the [Example Voting App](https://github.com/dockersamples/example-voting-app). [Fork the repository](https://github.com/dockersamples/example-voting-app/fork) into your GitHub account, so Radius can add the Application definition and GitHub Actions workflows.

## Step 1: Install the plugin

1. Open the GitHub Copilot app.
1. Open app settings and select **Plugins**.
1. Select the arrow next to **Install**, and then select **Add marketplace**.
1. Enter `https://github.com/radius-project/ai-extensions`, and then select **Add marketplace**.
1. In the `radius-plugins` marketplace, turn on the `radius` plugin.
1. Restart your Copilot session so the skills and canvas become available.

The plugin bundles the Radius skills and canvas extension into one installation. After installation, use the plugin's three-dot menu to update or uninstall it.

{{% alert title="Preview installation" color="info" %}}
Adding the Radius marketplace manually is temporary. When the extension is released for public preview, the plugin will be available from the `awesome-copilot` marketplace.
{{% /alert %}}

<!-- TODO: screenshot of installing the radius plugin from the GitHub Copilot app Plugins settings. Save the PNG next to this index.md and uncomment:
{{< image src="install-plugin.png" alt="Installing the radius plugin from the GitHub Copilot app plugins settings" width=800px >}}
-->

## Step 2: Model your Application

1. Create a new Copilot session and add your fork of the Example Voting App:

   ```text
   https://github.com/<your-github-user>/example-voting-app
   ```

1. Ask Copilot:

   ```text
   Show me the application graph.
   ```

Copilot runs the Radius app-modeling skill. The skill analyzes your source code, manifests, and Dockerfiles, identifies your workloads and their dependencies, generates a Radius Application definition, and writes it into your repository. The canvas opens and renders the definition as an interactive Application graph.

{{< image src="modeled-application-graph.png" alt="Radius Canvas Modeled view showing the Example Voting App workloads, routes, Redis cache, and PostgreSQL database" width=1000px >}}

{{% alert title="Canvas troubleshooting" color="info" %}}
If Radius Canvas does not open, ask Copilot to `Fix my Radius extension`. This invokes the Radius repair skill, which copies the required Canvas extension files into place.
{{% /alert %}}

The **Modeled** view visualizes the generated `.radius/app.bicep` file. For the Example Voting App, the graph represents the application workloads and backing services identified in the repository, including the `vote`, `worker`, and `result` components and their Redis and PostgreSQL dependencies.

Review the connections in the graph:

- `vote` accepts votes and writes them to Redis.
- `worker` reads votes from Redis and writes the results to PostgreSQL.
- `result` reads the voting results from PostgreSQL.

Each resource can link back to where it is defined or initialized in the source repository. Select a node to open the source file and, when available, the exact line.

Select **Create Environment** next to the Modeled graph to begin configuring the environment to plan the deployment.

## Step 3: Configure your Environment

An Environment defines where your Application runs and the infrastructure available to it.

After you select **Create Environment**, the canvas opens the deployment configuration flow.

1. Under **Cloud credentials**, expand **New credential profile**.
1. Enter a profile name and select Azure as the provider.
1. Enter your Azure tenant ID and subscription ID.
1. Select **Verify credentials**.
1. After verification succeeds, select **Save credential profile**, and then select **Next**.
1. Under **Target environment**, enter a name such as `voting-azure`.
1. Under **Connect GitHub to cloud**, select the GitHub account and the saved credential profile, and then select **Next**.
1. Specify the deployment target.
1. Under **Infrastructure**, verify access, and then select the Azure resource group and AKS cluster. Select an existing Kubernetes namespace or enter a namespace such as `voting`.
1. Create the Environment.

Radius establishes OIDC trust with GitHub Actions, so deployment workflows authenticate with short-lived credentials instead of long-lived secrets stored in the repository.

<!-- TODO: screenshot of the credential profile and Environment creation flow. Save the PNG next to this index.md and uncomment:
{{< image src="configure-environment.png" alt="Creating an Azure credential profile and configuring a Radius Environment in the canvas" width=800px >}}
-->

## Step 4: Plan the deployment

When Environment configuration is complete, the canvas returns to the Application graph and displays the **Planned** view.

1. Confirm that the Example Voting App, your fork's branch, and the `voting-azure` Environment are selected.
1. Review the planned Application and supporting infrastructure.
1. Confirm how Radius will deploy the `vote`, `worker`, and `result` workloads and provide their Redis and PostgreSQL dependencies in the selected Environment.

Viewing the planned graph does not deploy or change cloud resources.

<!-- TODO: screenshot of the Planned graph. Save the PNG next to this index.md and uncomment:
{{< image src="planned-graph.png" alt="The Planned graph for the Example Voting App and its supporting infrastructure" width=800px >}}
-->

## Step 5: Deploy your Application

1. Select **Deploy App**, or ask Copilot:

   ```text
   Deploy the voting application.
   ```

Radius generates a GitHub Actions workflow that provisions the required infrastructure and deploys the Application to the selected Environment. The workflow is committed to your repository, so you review it before it runs and maintain it alongside your Application code.

The canvas opens the **Deployments** area, where you can monitor deployment progress and open the GitHub Actions run. When the deployment completes, return to the Application graph and open the **Deployed** view to see the voting application and its resources running in the Environment.

<!-- TODO: screenshot of the deployment list and the Deployed graph. Save the PNG next to this index.md and uncomment:
{{< image src="deploy.png" alt="Monitoring a Radius deployment and viewing the deployed Application graph" width=800px >}}
-->

## Compare Application changes

The **Diff** view shows how an Application changes between two branches, such as a pull request against `main`. Use it during code review to see which components, connections, and dependencies a change adds, removes, or modifies.

You can generate a Markdown summary of the graph diff and post it as a pull request comment so reviewers can see the architectural impact alongside the code.

## Report bugs and feedback

Before opening an issue, check the [existing Radius AI extensions backlog](https://github.com/orgs/radius-project/projects/23/views/14?layout=table) for a matching report.

Submit bugs and feedback with the [feedback or bug report form](https://github.com/radius-project/ai-extensions/issues/new?template=feedback-or-bug-report.yml). You can also open the form from the feedback button in the canvas.

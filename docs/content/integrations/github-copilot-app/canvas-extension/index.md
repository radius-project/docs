---
type: docs
title: "Model, visualize, and deploy applications with Radius Canvas"
linkTitle: "Radius Canvas"
weight: 2
description: "Use Radius Canvas to model, visualize, and deploy applications in the GitHub Copilot app"
hide_preview_release_banner: true
---

{{% alert title="Preview release" color="info" %}}
The Radius Canvas preview supports containerized applications deployed to Azure.
{{% /alert %}}

## Prerequisites

Before you begin, you need:

- The latest version of the [GitHub Copilot app](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app).
- An Azure subscription. If you don't have one, [create one for free](https://azure.microsoft.com/pricing/purchase-options/azure-account).
- An [Azure Kubernetes Service (AKS) cluster](https://learn.microsoft.com/azure/aks/learn/quick-kubernetes-deploy-cli).
- The [Kubernetes command-line tool (`kubectl`)](https://kubernetes.io/docs/tasks/tools/), installed and configured to access your AKS cluster.
- The [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli), installed and authenticated:

  ```bash
  az login
  ```

- The [GitHub CLI](https://cli.github.com/), installed and authenticated with package and workflow access:

  ```bash
  gh auth login --scopes read:packages,write:packages,workflow
  ```

- A GitHub repository with a containerized application. You must own the repository or have write access to it. Fork the repository if necessary.

### Sample repositories

You can use your own application or fork one of these open-source samples:

- [Docker Example Voting App](https://github.com/dockersamples/example-voting-app)
- [AKS Store Demo](https://github.com/Azure-Samples/aks-store-demo)
- [Example To-do List Application](https://github.com/dockersamples/todo-list-app)
- [Google Cloud Microservices Demo](https://github.com/GoogleCloudPlatform/microservices-demo)

## Step 1: Install the plugin

1. Open the GitHub Copilot app.
2. Open the **Customize** tab in the side menu, and then select **Plugins**.

   {{< image src="open-customize-plugins-tab.png" alt="Customize page with the Plugins tab selected" width=800px >}}

3. Search for `radius`, and then install the plugin.

   {{< image src="search-install-radius-plugin.png" alt="Available plugins filtered to show the Radius plugin with the Install action" width=800px >}}

4. Restart your Copilot session so the skills and Radius Canvas become available.

After installation, use the plugin's three-dot menu to update or uninstall it.

## Step 2: Model your Application

1. Create a new Copilot session. Select **GitHub repository**, and then add the repository you want to model.

   {{< image src="select-github-repository.png" alt="GitHub Copilot app menu for starting a session from a GitHub repository" width=500px >}}

2. In the Copilot chat, enter:

   ```text
   Show the application graph
   ```

   {{< image src="prompt-show-application-graph.png" alt="Copilot chat prompt to show the application graph" width=800px >}}

   Copilot analyzes your source code, manifests, and Dockerfiles, generates an application definition at `.radius/app.bicep`, and opens it in the **Modeled** view of Radius Canvas.

   {{< image src="modeled-application-graph.png" alt="Radius Canvas Modeled view with the Create Environment action" width=800px >}}

   The **Application graph** represents the workloads, routes, backing services, and connections Radius identified in the repository.

   Review the graph to confirm that it includes the expected workloads, backing services, infrastructure dependencies, and connections. Select a resource, and then select **View source code** to open the source file where Radius detected it.

3. Select **Create Environment** next to the **Modeled** view to begin configuring the Environment and planning the deployment.

## Step 3: Configure your Environment

An Environment defines where your Application runs and the infrastructure available to it. After you select **Create Environment**, Radius Canvas opens the Environment configuration flow.

1. Under **Choose Cloud credentials**, open the credential profile dropdown, and then select **Create new profile**.

   A credential profile is a reusable set of Azure tenant and subscription details that Radius uses to authenticate to Azure and configure OIDC trust for GitHub Actions.

   {{< image src="choose-cloud-credentials.png" alt="Choose cloud credentials step with the option to create a credential profile" width=800px >}}

2. Enter a profile name, select **Azure** as the provider, and enter your Azure tenant ID and subscription.

   {{< image src="create-azure-credential-profile.png" alt="Create Credential Profile form for an Azure tenant and subscription" width=800px >}}

3. Select **Verify credentials**.
4. After verification succeeds, select **Save and continue**.
5. Next, enter a name for the Environment and select the GitHub account and the saved credential profile under **Connect GitHub to a cloud**.

   {{< image src="connect-github-to-cloud.png" alt="Create Environment form connecting a GitHub account to an Azure credential profile" width=800px >}}

6. Under **Deploy identity**, the Microsoft Entra app registration name is already populated.
7. Under **Infrastructure**, select the Azure resource group and AKS cluster. Select an existing Kubernetes namespace or enter a namespace such as `my-app`.
8. Select **Create the Environment**. You can follow the status of the Environment configuration.

   {{< image src="environment-creation-progress.png" alt="Environment creation progress showing deploy identity authorization, configuration, and credential verification" width=800px >}}

   Radius establishes OIDC trust with GitHub Actions, so deployment workflows authenticate with short-lived credentials instead of long-lived secrets stored in the repository.

## Step 4: Plan the deployment

When the Environment configuration is complete, Radius Canvas displays **Plan deployment**, which opens the **Planned** view.

1. Confirm that the correct Application, branch, and Environment are selected.

   {{< image src="planned-application-graph.png" alt="Radius Canvas Planned view showing Application workloads and supporting infrastructure" width=800px >}}

2. Review the planned Application and supporting infrastructure.
3. Select a resource to review its Radius resource type, connections, and links to **View source code** or **View app definition**.

Reviewing the plan does not deploy or change cloud resources.

## Step 5: Deploy your Application

In the **Planned** view, select **Deploy Application**.

{{< image src="deploy-application.png" alt="Deployments view for selecting an Application, Environment, and branch to deploy" width=800px >}}

Radius Canvas opens the **Deployments** view and dispatches a GitHub Actions workflow that provisions the required infrastructure and deploys the Application to the selected Environment. Monitor progress in the view, or open the workflow run for details.

The workflow is committed to your repository, so you can review it before it runs and maintain it alongside your application code.

When the deployment completes, return to the **Application graph** and open the **Deployed** view to see the Application and its resources running in the Environment.

{{< image src="deployed-application-graph.png" alt="Deployed view of the Application graph" width=800px >}}

## Step 6: Access your Application

In the Copilot chat, enter:

```text
Access my deployed application
```

Copilot sets up port forwarding and provides a URL. Open the URL to access the deployed Application.

## Step 7: Compare Application changes

Make changes to your Application on a branch, and then open the **Diff** view to compare the updated Application against `main`.

1. Select your Application.
2. Select `main` as the **Base** branch.
3. Select the branch containing your changes as the **Head** branch.
4. Review which components, connections, and dependencies your changes add, remove, or modify.

You can generate a Markdown summary of the **Diff** view and post it as part of a pull request comment, so reviewers can see the architectural impact alongside the code.

{{< image src="application-graph-diff.png" alt="Radius Canvas Diff view comparing Application resources and connections between two branches" width=800px >}}

## Step 8: Clean up

1. In the **Deployments** view, select **Delete Deployment**, and then confirm the deletion.
2. Monitor the deletion workflow until it completes. Radius deletes the Application and the infrastructure resources owned by it.
3. If you no longer need the Radius Environment, open the **Environments** view and delete it.

{{% alert title="Warning" color="warning" %}}
Deleting a deployment can permanently remove infrastructure and data owned by the Application. It does not delete the AKS cluster or Azure resource group.
{{% /alert %}}

## Troubleshooting

- **Radius Canvas does not open.** Ask Copilot to `Fix my Radius Canvas`. This invokes the Radius repair skill, which copies the required Radius Canvas files into place.
- **Modeling cannot find a Dockerfile.** Radius Canvas currently supports only applications with a Dockerfile. Ask Copilot to `Create a Dockerfile for my application`, and then model the Application again.
- **`gh` is not recognized or `command not found: gh`.** Install the [GitHub CLI](https://cli.github.com/) and restart your terminal, then run `gh auth login`.
- **The active GitHub account is missing the `read:packages` or `write:packages` scope.** Run the authentication command shown by Radius Canvas, and then retry. If `GH_TOKEN` controls authentication, use a token that includes both scopes.
- **`Timed out waiting for credential verification to complete`.** If the repository's default branch is protected, Environment setup might have created a pull request for the Radius workflow files. Open and merge that pull request, then retry verification.
- **`Branch not pushed yet` or `Extension "radius" is not recognized`.** Commit and push the complete generated `.radius` directory, including `bicepconfig.json`, to the branch you are deploying, and then deploy again.
- **An image build fails with `exec format error`.** Ask Copilot to review the Dockerfile's target-platform handling and update the application definition with supported build platforms, and then deploy again.
- **A removed resource remains after redeployment.** Radius re-deployments are incremental and do not automatically delete resources removed from the application definition. If the resource is no longer needed, delete it in the Azure portal.

## Report bugs and feedback

Before opening an issue, check the [existing Radius AI extensions backlog](https://github.com/orgs/radius-project/projects/23/views/14?layout=table) for a matching report.

Submit bugs and feedback with the [feedback or bug report form](https://github.com/radius-project/ai-extensions/issues/new?template=feedback-or-bug-report.yml). You can also open the form from the feedback button in the bottom-right corner of Radius Canvas.

{{< image src="feedback.png" alt="Feedback button in Radius Canvas" width=250px >}}

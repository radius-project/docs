---
type: docs
title: "Model, visualize and deploy applications using Radius Canvas extension"
linkTitle: "Radius Canvas extension"
weight: 2
description: "Install the Radius Canvas extension to model, visualize, and deploy an application in the GitHub Copilot app"
hide_preview_release_banner: true

---

## Prerequisites

- The latest version of the [GitHub Copilot app](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app).
- An Azure subscription.
- An [Azure Kubernetes Service (AKS) cluster](https://learn.microsoft.com/azure/aks/learn/quick-kubernetes-deploy-cli).
- The [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli). Run [`az login`](https://learn.microsoft.com/cli/azure/authenticate-azure-cli-interactively) before you begin.
- The [GitHub CLI](https://cli.github.com/), authenticated with package and workflow access. Run:

  ```bash
  gh auth login
  gh auth refresh -s read:packages -s write:packages -s workflow
  ```

- A GitHub repository with a containerized application. You must own the repository or have write access to it. Fork the repository if necessary.

### Sample repositories

You can use your own application or fork one of these open-source samples:

- [Docker Example Voting App](https://github.com/dockersamples/example-voting-app)
- [Docker Todo List App](https://github.com/dockersamples/todo-list-app)
- [AKS Store Demo](https://github.com/Azure-Samples/aks-store-demo)
- [Spring Petclinic Microservices](https://github.com/spring-petclinic/spring-petclinic-microservices)
- [Google Cloud Microservices Demo](https://github.com/GoogleCloudPlatform/microservices-demo)

## Step 1: Install the plugin

1. Open the GitHub Copilot app.
1. Open settings in the bottom left corner and select **Plugins**.
2. Select the dropdown next to **Install**, and then select **Add marketplace**.

   {{< image src="open-add-marketplace-menu.png" alt="Plugins settings with the Install menu open and Add marketplace selected" width=800px >}}

3. Enter `radius-project/ai-extensions`, and then select **Add marketplace**.

   {{< image src="add-radius-marketplace.png" alt="Add marketplace dialog with radius-project/ai-extensions entered as the marketplace source" width=800px >}}

4. In the `radius-plugins` marketplace, install the `radius-edge` plugin.

   {{< image src="install-radius-plugin.png" alt="Radius plugins marketplace showing the radius-edge plugin available to install" width=700px >}}

5. Restart your Copilot session so the skills and canvas become available.

The plugin bundles the Radius skills and canvas extension into one installation. After installation, use the plugin's three-dot menu to update or uninstall it.

{{% alert title="Preview installation" color="info" %}}
Adding the Radius marketplace manually is temporary. When the extension is released for public preview, the plugin will be available from the `awesome-copilot` marketplace.
{{% /alert %}}

## Step 2: Model your Application

1. Create a new Copilot session. Select **GitHub repository**, and then add the repository you want to model.

   {{< image src="select-github-repository.png" alt="GitHub Copilot App menu for starting a session from a GitHub repository" width=500px >}}

1. In the chat, enter **Show me the application graph**.

   {{< image src="prompt-application-graph.png" alt="GitHub Copilot App chat prompt asking Copilot to show the application graph" width=800px >}}

   Copilot runs the Radius app-modeling skill. The skill analyzes your source code, manifests, and Dockerfiles, identifies your workloads and their dependencies, generates a Radius Application definition, and writes it into your repository. The canvas opens and renders the definition as an interactive Application graph.

   {{< image src="modeled-application-graph-create-environment.png" alt="Radius Canvas Modeled graph with the Create Environment action" width=800px >}}

   {{% alert title="Canvas troubleshooting" color="info" %}}
   If Radius Canvas does not open, ask Copilot to `Fix my Radius extension`. This invokes the Radius repair skill, which copies the required Canvas extension files into place.
   {{% /alert %}}

   The **Modeled** view visualizes the generated application definition `.radius/app.bicep` file. The graph represents the workloads, routes, backing services, and connections Radius identified in the repository.

   Review the connections in the graph:

   - Verify that all application workloads appear in the graph.
   - Check that the graph includes the expected backing services and infrastructure dependencies.
   - Ensure that the connections between resources accurately represent the application architecture.
   - Select **View source code** to open the file where Radius detected the service or dependency.

2. Select **Create Environment** next to the Modeled graph to begin configuring the environment to plan the deployment.

## Step 3: Configure your Environment

An Environment defines where your Application runs and the infrastructure available to it. After you select **Create Environment**, the canvas opens the environment configuration flow.

1. Under **Choose Cloud credentials**, select a credential profile dropdown and click **Create new profile**.

   {{< image src="choose-cloud-credentials.png" alt="Choose cloud credentials step with the option to create a credential profile" width=800px >}}
2. Enter a profile name and select Azure as the provider and enter your Azure tenant ID and subscription.

   {{< image src="create-azure-credential-profile.png" alt="Create Credential Profile form for an Azure tenant and subscription" width=800px >}}
3. Select **Verify credentials**.
4. After verification succeeds, select **Save and continue**.
5. Next, enter a name for the environment and select the GitHub account and the saved credential profile under **Connect GitHub to a cloud**.

   {{< image src="connect-github-to-cloud.png" alt="Create Environment form connecting a GitHub account to an Azure credential profile" width=800px >}}
6. Under **Deploy identity**, the Microsoft Entra app registration name is already populated.
7. Under **Infrastructure**, select the Azure resource group and AKS cluster. Select an existing Kubernetes namespace or enter a namespace such as `my-app`.
8. Click **Create the Environment**.
   You can follow along the status of the environment configuration.

   {{< image src="environment-creation-progress.png" alt="Environment creation progress showing deploy identity authorization, configuration, and credential verification" width=800px >}}

   Radius establishes OIDC trust with GitHub Actions, so deployment workflows authenticate with short-lived credentials instead of long-lived secrets stored in the repository.

## Step 4: Plan the deployment

When Environment configuration is complete, the canvas displays **View planned graph** that takes you the **Planned** graph view.

1. Confirm that the correct Application, branch, and Environment are selected.

   {{< image src="planned-application-graph.png" alt="Radius Canvas Planned graph showing application workloads and supporting infrastructure" width=800px >}}
2. Review the planned Application and supporting infrastructure.
3. Confirm how Radius will deploy each workload and provide its infrastructure dependencies in the selected Environment.

Viewing the planned graph does not deploy or change cloud resources.

## Step 5: Deploy your Application

Select **Deploy Application**.

{{< image src="deploy-application.png" alt="Deployments view for selecting an Application, Environment, and branch to deploy" width=800px >}}

The canvas opens the **Deployments** area, where you can monitor deployment progress and open the GitHub Actions run. Radius generates a GitHub Actions workflow that provisions the required infrastructure and deploys the Application to the selected Environment. The workflow is committed to your repository, so you review it before it runs and maintain it alongside your Application code.

When the deployment completes, return to the Application graph and open the **Deployed** view to see the Application and its resources running in the Environment.

{{< image src="deployed-application-graph.png" alt="Deployed view of the application graph" width=800px >}}

## Step 6: Access your Application

In the Copilot chat, enter "Access my deployed application".

Copilot sets up port forwarding and provides a URL to access the deployed Application.

## Step 7: Clean up

1. In the **Deployments** view, click **Delete Deployment** and confirm the deletion.
2. Monitor the deletion workflow until it completes. Radius deletes the Application and the infrastructure resources owned by it.
3. If you no longer need the Radius Environment, open the **Environments** area and delete it.

Deleting the Radius deployment or Environment does not delete the AKS cluster or Azure resource group.

## Compare Application changes

Make changes to your Application on a branch, and then open the **Diff** view to compare the updated Application against `main`.

1. Select your Application.
2. Select `main` as the **Base** branch.
3. Select the branch containing your changes as the **Head** branch.
4. Review which components, connections, and dependencies your changes add, remove, or modify.

You can generate a Markdown summary of the graph diff and post it as part of pull request comment, so reviewers can see the architectural impact alongside the code.

{{< image src="application-graph-diff.png" alt="Radius Canvas Diff view comparing application resources and connections between two branches" width=800px >}}

## Report bugs and feedback

Before opening an issue, check the [existing Radius AI extensions backlog](https://github.com/orgs/radius-project/projects/23/views/14?layout=table) for a matching report.

Submit bugs and feedback with the [feedback or bug report form](https://github.com/radius-project/ai-extensions/issues/new?template=feedback-or-bug-report.yml). You can also open the form from the feedback button in the bottom right corner of the canvas extension.

{{< image src="feedback.png" alt="Feedback button in the canvas extension" width=250px >}}

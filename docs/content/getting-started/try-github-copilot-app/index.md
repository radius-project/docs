---
type: docs
title: "4. Use the GitHub Copilot app"
linkTitle: "4. Use the GitHub Copilot app"
weight: 400
description: "Install the Radius plugin and use it to model, visualize, and deploy an application in the GitHub Copilot app"
hide_preview_release_banner: true
aliases:
  - /integrations/github-copilot-app/canvas-extension/
---

{{% alert title="Preview Release" color="warning" %}}
Radius integration with the GitHub Copilot app is a preview release. It is only compatible with **containerized applications deployed to Azure**.
{{% /alert %}}

In this guide, you will install the Radius plugin for the GitHub Copilot app and use it to model, visualize, and deploy a containerized application to Azure, all from within the app.

The Radius integration with the GitHub Copilot app is completely self-contained and separate from a standalone Radius installation. It runs Radius operations as GitHub Actions workflows in your repository. If you installed Radius on a Kubernetes cluster in the previous pages of this Getting Started guide, this integration does not use that control plane. You do not need a local `rad` installation or an existing Radius control plane to complete this guide.

## Before you begin

Make sure you have:

- The latest version of the [GitHub Copilot app](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app).
- An Azure subscription.
- An [Azure Kubernetes Service (AKS) cluster](https://learn.microsoft.com/azure/aks/learn/quick-kubernetes-deploy-cli).
- The [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli). Run [`az login`](https://learn.microsoft.com/cli/azure/authenticate-azure-cli-interactively) before you begin.
- The [GitHub CLI](https://cli.github.com/). Run [`gh auth login`](https://cli.github.com/manual/gh_auth_login) with package and workflow access before you begin:

  ```bash
  gh auth login --scopes read:packages,write:packages,workflow
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
2. Open **Settings** in the bottom-left corner, and then select **Plugins**.
3. Select the dropdown next to **Install**, and then select **Add marketplace**.

   {{< image src="open-add-marketplace-menu.png" alt="Plugins settings with the Install menu open and Add marketplace selected" width=800px >}}

4. Enter the following under **Add marketplace**:

   ```text
   radius-project/ai-extensions
   ```

   {{< image src="add-radius-marketplace.png" alt="Add marketplace dialog with radius-project/ai-extensions entered as the marketplace source" width=800px >}}

5. Expand the **`radius-plugins`** marketplace and install the `radius-edge` plugin.

   {{< image src="install-radius-plugin.png" alt="Radius plugins marketplace showing the radius-edge plugin available to install" width=700px >}}

6. Restart your Copilot session so the skills and the Radius Canvas extension become available.

## Step 2: Model your Application

1. Create a new Copilot session. Select **GitHub repository**, and then add the repository you want to model.

   {{< image src="select-github-repository.png" alt="GitHub Copilot app menu for starting a session from a GitHub repository" width=500px class="d-block mb-4" >}}

2. In the chat, type:

   ```text
   Show me the application graph
   ```

   Copilot analyzes your source code, manifests, and Dockerfiles, identifies your workloads and their dependencies, and generates an application definition. It writes the definition to `.radius/app.bicep` in your repository, creating the `.radius/` directory if it does not already exist. The Radius panel opens and renders the definition as an interactive Application graph.

   The **Modeled** view visualizes the generated application definition `.radius/app.bicep` file. The graph represents the workloads, routes, backing services, and connections Radius identified in the repository. Select a resource on the graph and **View source code** to open the file where Radius detected the service or dependency.

## Step 3: Configure your Environment

An Environment defines where your Application is deployed to.

1. Select **Create Environment** next to the **Modeled** graph to begin configuring the Environment and planning the deployment.

2. Under **Choose Cloud credentials**, open the credential profile dropdown, and then select **Create new profile**. A credential profile is a reusable, named set of cloud credentials—the provider, Azure tenant, and subscription—that Radius uses to authenticate to your cloud and establish OIDC trust with GitHub Actions.

   {{< image src="choose-cloud-credentials.png" alt="Choose cloud credentials step with the option to create a credential profile" width=800px class="d-block mb-4" >}}

3. Enter a profile name, select **Azure** as the provider, enter your Azure tenant ID and subscription, then click **Verify credentials**.

   {{< image src="create-azure-credential-profile.png" alt="Create Credential Profile form for an Azure tenant and subscription" width=800px class="d-block mb-4" >}}

4. After verification succeeds, select **Save and continue**.
5. Enter a name for the Environment and select the GitHub account and the saved credential profile under **Connect GitHub to a cloud**.

   {{< image src="connect-github-to-cloud.png" alt="Create Environment form connecting a GitHub account to an Azure credential profile" width=800px >}}

6. Under **Deploy identity**, the Microsoft Entra app registration name is already populated.
7. Under **Infrastructure**, select the Azure resource group and AKS cluster. Select an existing Kubernetes namespace or enter a new namespace.
8. Select **Create the Environment**. Radius then configures OIDC authentication between GitHub Actions and Azure.

## Step 4: Plan the deployment

When the Environment configuration is complete, the panel displays the **Planned** graph view.

1. Confirm that the correct Application, branch, and Environment are selected.

   {{< image src="planned-application-graph.png" alt="Radius Canvas Planned graph showing application workloads and supporting infrastructure" width=800px class="d-block mb-4" >}}

2. Review the Planned graph to verify that it includes the expected Application resources, connections, and supporting infrastructure for the selected Environment.
3. Select any resource on the graph to see additional details, such as its Radius resource type, its connections to other resources, and links to **View source code** where the resource is defined in your repository or **View app definition** to open its entry in `.radius/app.bicep`.

## Step 5: Deploy your Application

Select **Deploy Application** and the **Deployments** panel opens, where you can monitor deployment progress and open the GitHub Actions workflow run for more details. Radius dispatches a GitHub Actions workflow run that deploys the Application to the selected Environment and provisions the required infrastructure. The workflow is committed to your repository, so you review it before it runs and maintain it alongside your Application code.

{{< image src="deploy-application.png" alt="Deployments view for selecting an Application, Environment, and branch to deploy" width=800px class="d-block mb-4" >}}

When the deployment completes, return to the Application graph and open the **Deployed** view to see the Application and its resources running in the Environment.

{{< image src="deployed-application-graph.png" alt="Deployed view of the application graph" width=800px >}}

## Step 6: Access your Application

In the Copilot chat, type:

```text
Access my deployed application
```

Copilot sets up port forwarding and provides a URL to access the deployed Application.

## Step 7: Compare Application changes

Make changes to your Application on a branch, and then open the **Diff** view to compare the updated Application against `main`.

1. Select your Application.
2. Select `main` as the **Base** branch.
3. Select the branch containing your changes as the **Head** branch.
4. Review which components, connections, and dependencies your changes add, remove, or modify.

You can generate a Markdown summary of the graph diff and post it as part of a pull request comment, so reviewers can see the architectural impact alongside the code.

{{< image src="application-graph-diff.png" alt="Radius Canvas Diff view comparing application resources and connections between two branches" width=800px >}}


## Step 8: Clean up

1. In the **Deployments** view, select **Delete Deployment**, and then confirm the deletion.
2. Monitor the deletion workflow until it completes. Radius deletes the Application and the infrastructure resources.
3. If you no longer need the Radius Environment, open the **Environments** view and delete it.

Deleting the Radius deployment or Environment does not delete the AKS cluster or Azure resource group.

## Troubleshooting

If the Radius panel does not open, ask Copilot to `Fix my Radius extension`. This invokes the Radius repair skill, which copies the required Radius Canvas extension files into place.

## Report bugs and feedback

Submit bugs and feedback with the [feedback or bug report form](https://github.com/radius-project/ai-extensions/issues/new?template=feedback-or-bug-report.yml). You can also open the form from the feedback button in the bottom right corner of the panel.

{{< image src="feedback.png" alt="Feedback button in the canvas extension" width=250px >}}

## Next steps

You have modeled, deployed, and inspected an application with the GitHub Copilot app. Continue with the hands-on labs for deeper, real-world scenarios.

{{< button text="Next step: Explore the labs" page="getting-started/labs" >}}

---
type: docs
title: "Tutorial: Integrate Radius with Flux"
linkTitle: "Integrate with Flux"
description: "Learn how to integrate Radius with Flux for GitOps"
weight: 100
categories: "Tutorial"
---

This tutorial will guide you through integrating Radius with Flux for GitOps. You will learn how to:

1. Install Flux in your Kubernetes cluster
1. Configure Flux to manage your Radius application
1. Deploy your application using Flux

By the end of the tutorial, you will have a Radius application defined in a Git repository managed by Flux.

## Prerequisites

- [Supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview" >}})
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Flux CLI](https://fluxcd.io/docs/installation/)
- A remote Git repository (e.g., GitHub, GitLab, etc.) to store your application files

## Step 1: Create a Git Repository

1. Create a new directory for your application:

   ```bash
   mkdir radius-flux-app
   cd radius-flux-app
   ```

1. Initialize a new Git repository and sync it with your remote repository:

   ```bash
   git init
   git add .
   git remote add origin <your-repo-url>
   ```

## Step 2: Install Flux source controller

1. Install Flux in your Kubernetes cluster:

   ```bash
   flux install --namespace=flux-system --version=latest --components=source-controller --network-policy=false
   ```

   {{< alert title="💡 Required Flux Components" color="info" >}}
   The Flux source controller is required for this Radius + Flux integration. The `--components=source-controller` flag ensures that the source controller is installed in your cluster. This component is responsible for managing the Git repository and syncing it with your Kubernetes cluster.
   {{< /alert >}}

   {{< alert title="⚠️ Network Policy" color="warning" >}}
   The `--network-policy=false` flag is specified here to disable the network policy for the Flux source controller, since by default access to Flux components is restricted. For a production setup, you can instead remove this flag and configure the network policy to allow `radius-system` namespace access to the source controller. This will ensure that the source controller can communicate with your Git repository and sync changes effectively.
   For more information on the network policy, see the [Flux documentation](https://fluxcd.io/flux/installation/configuration/optional-components/#network-policies).
   {{< /alert >}}

## Step 3: Initialize a Radius Environment and Application

1. Initialize a new Radius Environment with [`rad init`]({{< ref rad_initialize >}}):

   ```bash
   rad init
   ```

   When asked if you want to create a new application select "Yes". This will create a new file named `app.bicep` in your directory where your application will be defined. It will also create a [`bicepconfig.json`]({{< ref "/guides/tooling/bicepconfig/overview" >}}) file that will contain the necessary setup to use Radius types with Bicep.

## Step 3: Prepare Application for Deployment by Flux

1. Open `app.bicep` and see the scaffolded application created by `rad init`:

   {{% rad file="snippets/1-app.bicep" embed=true %}}

1. Update the `app.bicep` file. We want to link the default environment and specify an application to deploy Radius resources to.

   {{% rad file="snippets/2-app-with-environment.bicep" embed=true %}}

   This Radius application is now ready to be deployed. Instead of using the `rad deploy` CLI command, we will use Flux to detect changes in the Git repository and deploy the application automatically.

   Next, we will create a configuration file to inform Radius about which Bicep files to compile and deploy. This file is called `radius-gitops-config.yaml` and it will be created in the same directory as your `app.bicep` file.

   Create a new file named `radius-gitops-config.yaml` and add the following content:

   {{% rad file="snippets/2-radius-gitops-config.yaml" embed=true %}}

   Finally, commit and push your changes to the Git repository:

   ```bash
   git add app.bicep radius-gitops-config.yaml
   git commit -m "Add Radius application and configuration for Flux"
   git push origin main
   ```

## Step 4: Configure Flux to Manage Your Application

1. Register your Git repository with Flux:

   ```bash
   flux create source git radius-flux-app \
     --url=<your-repo-url> \
     --branch=main
   ```

   Now, Flux will monitor your Git repository for changes and Radius will deploy the application automatically when changes are detected. 

   {{< alert title="💡 Flux Sync" color="info" >}}
   You can manually trigger a sync in Flux by running the following command:

   ```bash
   flux reconcile source git radius-flux-app
   ```
   This will force Flux to check for changes in the Git repository and deploy any updates to your Kubernetes cluster.
   {{< /alert >}}
   
   After some time, you should be able to see the resources in your Kubernetes cluster:

   ```bash
   ❯ kubectl get pods -A
   ...
   NAMESPACE            NAME                                         READY   STATUS    RESTARTS        AGE
   default-app          demo-56d7fd6b64-q95sl                        1/1     Running   0               27s
   ...
   ```

   You can also use [`rad app graph`]({{< ref rad_application_graph >}}) to visualize the resources created by your application:

   ```bash
   ❯ rad app graph -a app
   Displaying application: app

   Name: demo (Applications.Core/containers)
   Connections: (none)
   Resources:
   demo (apps/Deployment)
   demo (core/Service)
   demo (core/ServiceAccount)
   demo (rbac.authorization.k8s.io/Role)
   demo (rbac.authorization.k8s.io/RoleBinding)

   ```

   {{< alert title="💡 Debugging Radius + GitOps" color="info" >}}
   Behind the scenes, Radius will create a custom resource called `DeploymentTemplate` to represent your Bicep deployment. You can check the status of this resource to see if there are any issues with the deployment:

   ```bash
   ❯ kubectl get deploymenttemplates -A
   NAMESPACE   NAME        STATUS
   app         app.bicep   Ready
   ❯ kubectl describe deploymenttemplate app.bicep -n app
   ...
   ```
   {{< /alert >}}

## Step 5: Update Your Application

Now that your application is registered with Flux, you can make changes to your application definitions and push them to your Git repository. Flux and Radius will do the rest - automatically detecting the changes and deploying them to your Kubernetes cluster.

1. Open `app.bicep` and make some changes to the application definition. For example, you can specify parameters and increase the number of replicas for the demo container:

   {{% rad file="snippets/3-app-add-replicas.bicep" embed=true %}}

1. Add a new file `app.bicepparam` to define the parameters for your application:

   {{% rad file="snippets/3-app.bicepparam" embed=true %}}

1. Update the `radius-gitops-config.yaml` file to include the new parameter file:

   {{% rad file="snippets/3-radius-gitops-config.yaml" embed=true %}}

1. As before, commit and push your changes to the Git repository:

   ```bash
   git add app.bicep app.bicepparam radius-gitops-config.yaml
   git commit -m "Update application definition and parameters"
   git push origin main
   ```

   After some time (Flux needs to reconcile the Git repository), you should be able to see that the application has been scaled up to 3 replicas:

   ```bash
   ❯ kubectl get pods -A
   NAMESPACE            NAME                                         READY   STATUS    RESTARTS      AGE
   ...
   default-app          demo-56d7fd6b64-6zwj7                        1/1     Running   0             2m19s
   default-app          demo-56d7fd6b64-n9rqz                        1/1     Running   0             2m19s
   default-app          demo-56d7fd6b64-q95sl                        1/1     Running   0             13m
   ...
   ```

   Congratulations! You have successfully integrated Radius with Flux for GitOps. You can now manage your Radius applications using Git as the single source of truth.
   

## Next steps

Check out the [Radius + GitOps overview]({{< ref "guides/deploy-apps/gitops/overview" >}}) for more detailed information on how to use Radius with GitOps.

You can also explore the rest of the [Radius documentation]({{< ref "/" >}})to learn more about other features and capabilities of Radius.

---
type: docs
title: "How-To: Set up Radius with Flux"
linkTitle: "Flux"
description: "Learn how to set up Radius to work with Flux for GitOps"
weight: 200
categories: "How-To"
tags: ["gitops", "flux", "continuous", "delivery", "deployment"]
---

This guide will provide an overview of how to:

1. Set up Radius with Flux for GitOps
1. Configure Flux to manage your Radius application
1. Deploy your Radius application using Flux

## Prerequisites

- [Supported Kubernetes cluster]({{< ref "/guides/installation/overview" >}})
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})
- A remote Git repository (e.g., GitHub, GitLab, etc.) to store your application files
- [Flux CLI](https://fluxcd.io/docs/installation/)
- [Flux control plane components](https://fluxcd.io/flux/installation/#install-the-flux-controllers) installed in your Kubernetes cluster
   {{< alert title="⚠️ Flux Network Policy" color="warning" >}}
   When installing Flux using the `flux bootstrap` or `flux install` commands, ensure that the `--network-policy false` flag is specified, or that the network policy is configured to allow access from `radius-system` namespace to the source controller. This is important for the Flux source controller to be able to communicate with your Git repository and sync changes effectively.
   For more information on the network policy, see the [Flux documentation](https://fluxcd.io/flux/installation/configuration/optional-components/#network-policies).
   {{< /alert >}}

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

## Step 2: Prepare Application for Deployment by Flux

1. Create a new Bicep file named `app.bicep` in the `radius-flux-app` directory. This file will define your application resources. Here is an example of a simple application that deploys a demo container:

   {{% rad file="snippets/2-app-with-environment.bicep" embed=true %}}

   Next, we will create a configuration file in our repository to inform Radius about which Bicep files to deploy. This file is named `radius-gitops-config.yaml` and it will be created in the same directory as your `app.bicep` file.

   Create a new file named `radius-gitops-config.yaml` and add the following content:

   {{% rad file="snippets/2-radius-gitops-config.yaml" embed=true %}}

   Finally, commit and push your changes to the Git repository:

   ```bash
   git add app.bicep radius-gitops-config.yaml
   git commit -m "Add Radius application and configuration for Flux"
   git push origin main
   ```

## Step 3: Configure Flux to Manage Your Application

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

## Done

Congratulations! You have successfully integrated Radius with Flux for GitOps. You can now manage your Radius applications using Git as the single source of truth.

## Cleanup

To cleanup the resources created in this guide, you can update the `radius-gitops-config.yaml` to remove the Bicep file entries in the `radius-gitops-config.yaml` file.

Before:
```yaml
config:
  - name: app.bicep
    params: app.bicepparam
    resourceGroup: default
```

After:
```yaml
config: 
   # intentionally empty - no Bicep files to deploy.
```

Then, commit the changes:
```

```bash
rm app.bicep
rm app.bicepparam
git add app.bicep app.bicepparam radius-gitops-config.yaml
git commit -m "Remove application files"
git push origin main
```

After some time, you should see that the resources have been removed from your Kubernetes cluster.

---
type: docs
title: "Manage Radius Kubernetes environments"
linkTitle: "Manage environments"
description: "Learn how to manage Radius Kubernetes environments"
weight: 100
---

## Manage environments

These steps will walk through how to deploy, manage, and delete environments in a Kubernetes cluster.

### Pre-requisites

- Install [rad CLI]({{< ref "getting-started#install-radius-cli" >}})
- Set up a Kubernetes Cluster. There are many different options here, including:
  - [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster)
    - Note that [AKS-managed AAD](https://docs.microsoft.com/en-us/azure/aks/managed-aad) is not supported currently
  - [Kubernetes in Docker Desktop](https://www.docker.com/blog/docker-windows-desktop-now-kubernetes/), however it does take up quite a bit of memory on your machine, so use with caution.
  - [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
  - [K3s](https://k3s.io), a lightweight single-binary certified Kubernetes distribution from Rancher.
  - Another Kubernetes provider of your choice.

{{% alert title="Warning" color="warning" %}}
If you choose a container registry provided by a cloud provider (other than Dockerhub), you will likely have to take some steps to configure your Kubernetes cluster to allow access. Follow the instructions provided by your cloud provider.
{{% /alert %}}

### Initialize an environment
The convenient way of [initializing an environment]({{< ref "environments-concept.md#creating-an-environment">}}) is via `rad env init kubernetes`. Below are some of the alternate options available to understand what goes into an environment initialization

1. Install Radius control plane on kubernetes cluster:

   {{< tabs "rad CLI" "Helm" >}}

   {{% codetab %}}
   Use the [`rad install kubernetes` command]({{< ref rad_env_init_Kubernetes >}}) to install Radius control plane on the kubernetes cluster.
   ```bash
   rad install kubernetes
   ```
   {{% /codetab %}}

   {{% codetab %}}
   ```sh
   helm repo add radius https://radius.azurecr.io/helm/v1/repo
   helm repo update
   helm upgrade radius radius/radius --install --create-namespace --namespace radius-system --version {{< param chart_version >}} --wait --timeout 15m0s
   ```
   {{% /codetab %}}

   {{< /tabs >}}

   {{% alert title="💡 About namespaces" color="success" %}}
   When Radius initializes a Kubernetes environment, it will deploy the system resources into the `radius-system` namespace. These aren't part your application. The namespace specified in interactive mode will be used for future deployments by default.
   {{% /alert %}}

1. Verify initialization

   To verify the installation succeeded, you can run the following command:

   ```bash
   kubectl get deployments -n radius-system
   ```

   The output should look like this:

   ```bash
   NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
   ucp                       1/1     1            1           53s
   appcore-rp                1/1     1            1           53s
   bicep-deployment-engine   1/1     1            1           53s
   bicep-de                  1/1     1            1           53s
   contour-contour           1/1     1            1           46s
   dapr-dashboard            1/1     1            1           35s
   radius-rp                 1/1     1            1           53s
   dapr-sidecar-injector     1/1     1            1           35s
   dapr-sentry               1/1     1            1           35s
   dapr-operator             1/1     1            1           35s
   ```

   An ingress controller is automatically deployed to the `radius-system` namespace for you to manage gateways. In the future you will be able to deploy your own ingress controller. Check back for updates.

1. Use `rad env init kubernetes` to create an environment resource and configure [cloud provider]({{<ref providers>}}) if needed
    {{% alert title="💡 rad command" color="success" %}}`rad env init kubernetes` also installs Radius control plane if not already installed  .
    {{% /alert %}}

### Delete an environment

Use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}):

```bash
rad env delete -e <ENVIRONMENT_NAME> --yes
```

This will currently remove the entry for the kubernetes environment in your config file. It will *NOT* remove the resources created in the kubernetes cluster. In future updates, a better story around uninstalling/deletion will be provided.

## Additional resources

- [Kubernetes Bicep resources]({{< ref kubernetes-resources >}})

---
type: docs
title: "Initialize Radius Kubernetes environments"
linkTitle: "Initialize Radius environments"
description: "Learn how to initialize Radius Kubernetes environments"
weight: 100
---

## Pre-requisites

- Install [rad CLI]({{< ref "getting-started#install-radius-cli" >}})
- Set up a Kubernetes Cluster. There are many different options here, including:
  - [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster)
    - Note that [AKS-managed AAD](https://docs.microsoft.com/en-us/azure/aks/managed-aad) is not supported currently
  - [Kubernetes in Docker Desktop](https://www.docker.com/blog/docker-windows-desktop-now-kubernetes/), however it does take up quite a bit of memory on your machine, so use with caution.
  - [K3s](https://k3s.io), a lightweight single-binary certified Kubernetes distribution from Rancher.
  - Another Kubernetes provider of your choice.

{{% alert title="Warning" color="warning" %}}
If you choose a container registry provided by a cloud provider (other than Dockerhub), you will likely have to take some steps to configure your Kubernetes cluster to allow access. Follow the instructions provided by your cloud provider.
{{% /alert %}}

## Initialize an environment (Recommended)

A Radius [Kubernetes environment]({{<ref environments-concept>}}) can run in a Kubernetes cluster running on any platform. This step is usually done either by an infra-admin person or a developer depending upon the setup of an enterprise. 

You can view the current context for kubectl by running
```bash
kubectl config current-context
```

[`rad env init kubernetes` command]({{< ref rad_env_init_Kubernetes >}}) is the convenient way to initialize a new environment into your current kubectl context.
```bash
rad env init kubernetes -i
```

Follow the prompts to configure:

1. **Namespace** - When an application is deployed, this is the namespace where your containers and other Kubernetes resources will be run.
{{% alert title="💡 About namespaces" color="success" %}} When you initialize a Radius Kubernetes environment, Radius installs the control plane resources within the `radius-system` namespace in your cluster, separate from your applications. The namespace specified in this step will be used for your application deployments.
{{% /alert %}}

1. **Add Azure provider** - An [Azure cloud provider]({{<ref providers>}}) allows you to deploy and manage Azure resources as part of your application. If you have have an Azure subscription add an Azure cloud provider to use it later in the tutorial.

      - *Subscription and Resource group* - Pick or enter the Azure subscription and resource group where the azure resources will be deployed 
      - *Location* - Pick the region where the azure resource will be deployed
      - *Service principal* - A service principal is required to authenticate with Azure and create Azure resources. You can use the below command to create a service principal or use an  existing one.
         ```bash 
         az ad sp create-for-rbac --role Owner --scope /subscriptions/<subscription name>/resourceGroups/<resource group name>
         ```
         Enter the appID, passwd and the tenant of the service principal

1. **Environment name** - The name of the environment to create. Eg:`contoso-prod`.

Below is depiction of a eg: `contoso-prod` environment initialized
<img src="env-init.png" alt="Diagram of an example Radius environment initialized. Depicts a workspace that references a Kubernetes cluster which has the Radius control plane services installed and running under radius-system namespace. The radius control plane services holds the contoso-prod environment resource and the Azure cloud provider config. The environment maps to a contoso-prod namespace which is the landing zone for the contoso application" width="1000" />

- **Control Plane installation** - Radius installs the control plane services on the kubernetes cluster under the `radius-system` namespaces
- **Creation of an environment** - An environment resource is created in the Radius control plane and it maps to an environment namespace. The environment namespace eg: `contoso-prod` is the landing space for the application to be deployed to
- **Azure Cloud Provider configuration** - Azure cloud provider configurations are saved in the radius-control plane to enable deployments of Azure resources 
- **Creation of Workspace** - A workspace is created locally which contains reference to your environment. These configurations are saved to a configuration file (`~/.rad/config.yaml` on Linux and macOS, `%USERPROFILE%\.rad\config.yaml` on Windows).


### Verify initialization

   To verify the environment initialization succeeded, you can run the following command:

   ```bash
   kubectl get deployments -n radius-system
   ```

   The output should look like this:

   ```bash
   NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
   ucp                       1/1     1            1           53s
   appcore-rp                1/1     1            1           53s
   bicep-de                  1/1     1            1           53s
   contour-contour           1/1     1            1           46s
   dapr-dashboard            1/1     1            1           35s
   dapr-sidecar-injector     1/1     1            1           35s
   dapr-sentry               1/1     1            1           35s
   dapr-operator             1/1     1            1           35s
   ```

An ingress controller is automatically deployed to the `radius-system` namespace for you to manage gateways. In the future you will be able to deploy your own ingress controller. Check back for updates.

You can also use `rad env list` to see if the created environment gets listed
```bash
rad env list
```

## Initialize an environment (Advanced)

Below are some of the alternate options available to do a step by step environment initialization. 

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

1. Use `rad env init kubernetes` to create an environment resource and configure an Azure [cloud provider]({{<ref providers>}}) if needed. Either the `-i` interactive setup or `--provider` flags can be used to specify the Azure connection information.
    {{% alert title="💡 rad command" color="success" %}}`rad env init kubernetes` also installs Radius control plane if not already installed  .
    {{% /alert %}}

## Delete an environment

Use the rad CLI to [delete an environment]({{< ref rad_env_delete.md >}}):

```bash
rad env delete -e <ENVIRONMENT_NAME> --yes
```

This will currently remove the entry for the kubernetes environment in your config file. It will *NOT* remove the resources created in the kubernetes cluster. In future updates, a better story around uninstalling/deletion will be provided.

## Additional resources

- [Kubernetes Bicep resources]({{< ref kubernetes-resources >}})

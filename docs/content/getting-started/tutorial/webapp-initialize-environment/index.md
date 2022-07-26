---
type: docs
title: "Initialize an environment"
linkTitle: "Initialize an environment"
description: "Initialize a Radius environment to deploy your tutorial application to"
weight: 200
slug: tutorial-env
---

## Initialize a Radius environment

A Radius [Kubernetes environment]({{<ref environments-concept>}}) can run in a Kubernetes cluster running on any platform. This step is usually done either by an infra-admin person or a developer depending upon the setup of an enterprise. 

In this step we will be initializing a Radius Kubernetes environment.

You can view the current context for kubectl by running
```bash
kubectl config current-context
```

Use the [`rad env init kubernetes` command]({{< ref rad_env_init_Kubernetes >}}) to initialize a new environment into your current kubectl context.
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

1. **Environment name** - The name of the environment to create. Use `webapp-tutorial-environment`.

Radius installs the control plane resources, creates an environment resource, creates a workspace and updates the configuration to /.rad/config.yaml

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

<br>{{< button text="Next: Author app definition" page="webapp-initial-deployment" newline="false" >}} {{< button text="Previous step: App overview" page="webapp-overview" >}}
---
type: docs
title: "How-To: Pull Bicep Recipes from private OCI container registry."
linkTitle: "Private bicep registries"
description: "Learn how to setup your Radius environment to use Bicep Recipe templates published to a private OCI container registry."
weight: 500
categories: "How-To"
tags: ["recipes", "bicep"]
---

This guide will describe how to:

- Configure a Radius environment to utilize Bicep Recipe templates that are stored in a private OCI (Open Container Initiative) complaint container registry. This setup will ensure the templates are securely stored within a private OCI registry and accessed by Radius using required credentials.

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Radius initialized with `rad init`]({{< ref howto-environment >}})

## Step 1: Obtain private OCI container registry authentication credentials
Radius supports three authentication methods for accessing private container registries:
- Basic Authentication: This method uses a username and password for authentication and is applicable to all OCI complaint registries. Obtain the `username` and `password` details used to login to private registry.
- Azure Workload Identity: This federated identity-based authentication is used for connecting to Azure Container Registry (ACR). [Here]({{< ref howto-azure-provider-wi >}}) is the guide to setup Azure Workload Identity for Radius. Obtain `clientId` and `tenant ID` used during the setup.
- AWS IRSA: This federated identity-based authentication is used for accessing Amazon Elastic Container Registry (ECR). [Here]({{< ref howto-aws-provider-irsa >}}) is the guide to setup the AWS IRSA for Radius. Obtain `roleARN` from the role created during the setup.

## Step 2: Define a secret store resource

Create a [Radius Secret Store]({{< ref "/guides/author-apps/secrets/overview" >}}) to securely store and manage the secrets information required for authenticating with a private registry. Define the namespace for the cluster that will contain your [Kubernetes Secret](https://kubernetes.io/docs/concepts/configuration/secret/) with the `resource` property and specify the type of secret e.g. `basicAuthentication`, `azureWorkloadIdeneity`, `awsIRSA`. 

> While this example shows a Radius-managed secret store where Radius creates the underlying secrets infrastructure, you can also bring your own existing secrets. Refer to the [secrets documentation]({{< ref "/guides/author-apps/secrets/overview" >}}) for more information.

Secret store example for secret type `awsIRSA`:
{{< rad file="snippets/env.bicep" embed=true marker="//SECRETSTORE" >}}

## Step 3: Configure authentication for private bicep registries and add a Bicep recipe

`recipeConfig` allows you to configure how Recipes should be setup and run. One available option is to specify the registry secrets for pulling Bicep Recipes from private registries. For more information refer to the [Radius Environment schema]({{< ref environment-schema >}}) page.

In your `env.bicep` file add an Environment resource that includes a `recipeConfig` which leverages the previously defined secret store for private OCI registry authentication.

{{< rad file="snippets/env.bicep" embed=true marker="//ENV" >}}


## Step 5: Deploy your Radius Environment

Deploy your new Radius Environment:

```
rad deploy ./env.bicep
```

## Done

Your Radius Environment is now ready to utilize your Radius Recipes stored inside your private registry. For more information on Radius Recipes visit the [Recipes overview page]({{< ref "/guides/recipes/overview" >}}).

## Cleanup

You can delete a Radius Environment by running the following command:

```
rad env delete my-env
```

## Further reading

- [Recipes overview]({{< ref "/guides/recipes/overview" >}})
- [Radius Environments]({{< ref "/guides/deploy-apps/environments/overview" >}})
- [`rad recipe CLI reference`]({{< ref rad_recipe >}})
- [`rad env CLI reference`]({{< ref rad_env >}})
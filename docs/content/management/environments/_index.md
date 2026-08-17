---
type: docs
title: "How to design and manage Environments"
linkTitle: "Manage Environments"
description: "Learn how to design an Environment layout and manage Environments with the Radius CLI and Bicep"
weight: 200
aliases:
  - /guides/environments/
  - /guides/environments/manage-environments/
  - /guides/environments/environments/
  - /guides/environments/environments/howto-environment/
---

Environments are prepared landing zones that define where applications deploy and how their resources are provisioned. Every Radius Application targets one Environment, but the Application and Environment do not need to belong to the same Resource Group.

This guide explains how to design an Environment layout, create and target an Environment, and manage its configuration. For more background, see the [Environments concepts documentation]({{< ref "concepts/environments" >}}).

## Design an Environment layout

Use Environments to represent meaningful differences in deployment configuration. Common layouts include:

- **Default Environment:** Use the `default` Environment created by `rad initialize`. This is the simplest layout for evaluating Radius, local development, or a small installation with one deployment target.
- **Lifecycle-based:** Create Environments such as `dev`, `test`, and `prod`. Each Environment must use a different Kubernetes namespace and can use different cloud provider accounts, Recipe Packs, and recipe parameters.
- **Location-based:** Create Environments for regions or clusters, such as `east-us` and `west-us`, when deployment location is the primary difference.
- **Team- or application-based:** Create dedicated Environments when teams or applications require different deployment targets, Recipe Packs, or platform policies.

Create a new Environment when applications need different deployment destinations or provisioning behavior. Avoid creating an Environment only to separate resource names or ownership; use [Resource Groups]({{< ref "/management/groups" >}}) for those boundaries.

### Plan Environment configuration

An Environment brings together four areas of configuration:

- **Cloud providers (`providers`)** select the Kubernetes namespace and the AWS or Azure account details where resources are deployed. Cloud provider credentials are registered separately with [`rad credential register`]({{< ref rad_credential_register >}}).
- **Recipe Packs** select the recipes used to provision infrastructure for Radius Resource Types.
- **Recipe parameters** override Recipe Pack defaults for a Resource Type across the Environment. The available parameters are defined by each recipe.
- **Bicep and Terraform settings** configure the infrastructure engines, including authentication for private module sources.

An Environment is a deployment target, not a resource naming scope. Applications deployed to different Environments can still conflict when they have the same name, Resource Type, and Resource Group. See [How to design and manage Resource Groups]({{< ref "/management/groups#plan-resource-names" >}}) for naming guidance.

{{% alert title="Kubernetes namespace uniqueness" color="warning" %}}
A Kubernetes namespace can be assigned to only one Environment in a Radius installation. Creating an Environment fails if another Environment already uses the namespace, even when the Environments belong to different Resource Groups.
{{% /alert %}}

## Create an Environment

Create the Resource Group first if it does not exist:

```bash
rad group create dev
```

Run [`rad environment create`]({{< ref rad_environment_create >}}) to create a `dev` Environment in the `dev` Resource Group. The Kubernetes cloud provider deploys workloads into the `dev` namespace:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment create dev \
  --group dev \
  --kubernetes-namespace dev \
  --preview
```

When you omit `--recipe-packs`, `rad environment create` assigns the `default` Recipe Pack from the `default` Resource Group to the new Environment.

Confirm that the Environment exists with [`rad environment show`]({{< ref rad_environment_show >}}):

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment show dev --group dev --preview
```

## Create an Environment with a specific Recipe Pack

A [Recipe Pack]({{< ref "/management/recipe-packs" >}}) determines which recipes provision infrastructure for the Environment. To assign one or more Recipe Packs at creation, pass `--recipe-packs` with a comma-separated list:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment create dev \
  --group dev \
  --kubernetes-namespace dev \
  --recipe-packs data-recipes \
  --preview
```

Applications deployed to `dev` now provision their resources using the recipes in `data-recipes`. To change the Recipe Packs on an existing Environment, see [Update an Environment](#update-an-environment).

## Target the Environment

Pass `--environment` (or `-e`) and `--group` (or `-g`) to deploy an application to a specific Environment and Resource Group:

```bash
rad deploy app.bicep --environment dev --group dev
```

The Environment controls how and where the application resources are deployed. The Resource Group controls the scope within the Radius control plane where resources are stored and named.

Specifying both flags makes the target explicit and is useful in scripts and automation.

## Update an Environment

Use [`rad environment update`]({{< ref rad_environment_update >}}) to update cloud provider configuration. For example, add or replace the AWS cloud provider on `dev`:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment update dev \
  --group dev \
  --aws-account-id 123456789012 \
  --aws-region us-west-2 \
  --preview
```

Add or replace the Azure cloud provider on `dev` with the subscription ID and resource group where Azure resources are deployed:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment update dev \
  --group dev \
  --azure-subscription-id 00000000-0000-0000-0000-000000000000 \
  --azure-resource-group my-resource-group \
  --preview
```

The CLI can update cloud provider configuration and, in preview, the Recipe Pack list. Manage advanced properties declaratively in Bicep. Review changes to an Environment carefully because they affect subsequent deployments that target it.

When you change the Recipe Pack list, `--recipe-packs` replaces the complete list; it does not append to it. Include every Recipe Pack the Environment should continue to use each time you run the command. To assign a Recipe Pack stored in a different Resource Group, see [Reference a Recipe Pack across Resource Groups](#reference-a-recipe-pack-across-resource-groups).

## Reference a Recipe Pack across Resource Groups

When you use `--group`, a bare Recipe Pack name in `--recipe-packs` resolves in that Resource Group. To resolve bare names against a different Resource Group, add `--recipe-pack-group`. This helps when Recipe Packs live in a shared Resource Group separate from your Environments.

For example, configure the `production` Environment in the `production` Resource Group to use `data-recipes` from the `default` Resource Group:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment update production \
  --group production \
  --recipe-packs data-recipes \
  --recipe-pack-group default \
  --preview
```

`--recipe-pack-group` applies to every bare name in `--recipe-packs` and must be used together with `--recipe-packs`. The same flag works with `rad environment create`.

To mix Recipe Packs from different Resource Groups in one command, pass a full Radius resource ID for any pack outside the `--recipe-pack-group` scope:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment update production \
  --group production \
  --recipe-packs production-recipes,/planes/radius/local/resourceGroups/default/providers/Radius.Core/recipePacks/data-recipes \
  --preview
```

The `production-recipes` name resolves in the `production` Resource Group selected by `--group`, while the full resource ID selects `data-recipes` from `default`. Ensure that the selected Recipe Packs do not define recipes for the same Resource Type.

## Delete an Environment

Run [`rad environment delete`]({{< ref rad_environment_delete >}}) when the Environment is no longer needed:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment delete dev --group dev --preview
```

The command prompts for confirmation. Verify that applications no longer target the Environment before deleting it.

## Define advanced configuration with Bicep

Use `Radius.Core` resources when an Environment needs Recipe Packs, recipe parameters, or settings that are easier to manage declaratively. The following example creates a `data-recipes` Recipe Pack and configures the Environment to use it:

```bicep
extension radius

resource devEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'dev'
  properties: {
    providers: {
      kubernetes: {
        namespace: 'dev'
      }
    }
    recipePacks: [
      dataRecipes.id
    ]
    // Keys are Radius Resource Types. Values are parameters defined by that type's Recipe.
    recipeParameters: {
      'Radius.Data/postgreSqlDatabases': {
        sku: 'development'
      }
    }
  }
}

resource dataRecipes 'Radius.Core/recipePacks@2025-08-01-preview' existing = {
  name: 'data-recipes'
}
```

Deploy the Environment definition into its Resource Group:

```bash
rad deploy environment.bicep --group dev
```

See the [`Radius.Core/environments` reference]({{< ref "/reference/resources/radius.core/2025-08-01-preview/environments" >}}) for all supported properties. See the [cloud provider guides]({{< ref "/installation/cloud-providers" >}}) before configuring AWS or Azure cloud providers.

## Configure TerraformSettings and BicepSettings

Use `Radius.Core/terraformSettings` and `Radius.Core/bicepSettings` resources to configure the infrastructure engines that run recipes. These resources are separate from an Environment, so you can define the settings once and reference them from each Environment that needs the same configuration.

Use **BicepSettings** when Bicep recipes pull templates from a private OCI registry. The settings map registry hostnames to authentication configuration. Reference the BicepSettings resource ID from the Environment's `bicepSettings` property, and Radius applies the authentication whenever a Bicep recipe pulls from a matching registry. See the [`Radius.Core/bicepSettings` reference]({{< ref "/reference/resources/radius.core/2025-08-01-preview/bicepsettings" >}}) for an example that configures private registry authentication and attaches it to an Environment.

Use **TerraformSettings** to configure the Terraform CLI that runs Terraform recipes. Common use cases include:

- Authenticating to a private Terraform registry with a token stored in a Radius Secret.
- Installing Terraform providers from an internal network mirror, including in air-gapped environments.
- Setting environment variables for Terraform CLI behavior or troubleshooting.

Reference the TerraformSettings resource ID from the Environment's `terraformSettings` property. Radius applies the configuration to every Terraform recipe run in that Environment. Registry credentials configured in TerraformSettings authenticate Terraform CLI registries; they do not authenticate Git-based module sources. See the [`Radius.Core/terraformSettings` reference]({{< ref "/reference/resources/radius.core/2025-08-01-preview/terraformsettings" >}}) for private registry, provider mirror, environment variable, and Environment reference examples.

## Next steps

Now that Environments are configured, learn how to control provisioning with Recipe Packs.

{{< button text="Next step: How to manage Recipe Packs" page="/management/recipe-packs" >}}

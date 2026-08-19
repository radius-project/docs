---
type: docs
title: "How to model application resources"
linkTitle: "Model application resources"
description: "Learn how to model an application using Bicep and Radius Resource Types"
weight: 100
---

An application definition is a Bicep file that declares your [Application]({{< ref "/concepts/applications" >}}) and the resources it is made of. You model each resource with a [Resource Type]({{< ref "/concepts/resource-types" >}}), and Radius provisions the backing infrastructure when you deploy the file. This guide walks through the Radius Demo `app.bicep` definition and explains how it models resources and dependencies.

When the definition is ready, see [How to deploy applications using Radius]({{< ref "/applications/deploy" >}}) to deploy it to an Environment.

## Step 1: Import the Radius extension

Begin by importing the Radius Bicep extension. The extension makes the Radius Resource Types available in Bicep:

{{< rad file="/static/samples/demo/app.bicep" embed=true startLine=1 endLine=1 >}}

The `radius` extension is configured in the `bicepconfig.json` created by `rad initialize`. If you have custom resource types to use, see [Add custom resource types to bicepconfig.json]({{< ref "/installation/dev-workstation#configure-bicepconfigjson" >}}).

## Step 2: Declare the Environment parameter

Every Application targets a Radius [Environment]({{< ref "/concepts/environments" >}}). Declare an `environment` parameter so the Radius CLI can supply the selected Environment's resource ID when you deploy:

{{< rad file="/static/samples/demo/app.bicep" embed=true startLine=3 endLine=4 >}}

You do not set this value yourself. `rad deploy` passes the Environment ID from the current [Workspace]({{< ref "/management/workspaces" >}}), or from the `--environment` flag.

## Step 3: Name your resources

Every resource in your definition needs a `name`, and names must be unique per Resource Type within a Resource Group. You have two options:

- **Static names.** Give each resource a simple, unique name per Resource Type. This works well when you deploy the application to a single Environment.
- **Environment-suffixed names.** If you deploy the same definition to multiple Environments that share a Resource Group, add the Environment name as a suffix so the names do not collide.

The demo uses the second option. It derives the Environment name from the `environment` parameter's resource ID:

{{< rad file="/static/samples/demo/app.bicep" embed=true startLine=11 endLine=11 >}}

It then interpolates `environmentName` into each resource name, such as `demo-${environmentName}`, so the same definition deploys cleanly to `dev`, `test`, and `prod`.

## Step 4: Define the Application resource

Declare a `Radius.Core/applications` resource to group the resources that make up your application. Its name applies the pattern from the previous step:

{{< rad file="/static/samples/demo/app.bicep" embed=true startLine=13 endLine=18 markdownConfig=`{hl_lines=[2]}` >}}

The Application records the resources that belong to it and the relationships between them. Radius uses it to build the Application graph and to manage the resources together.

## Step 5: Add resources with Resource Types

Add the resources your application needs. Each resource uses a Resource Type and sets two properties that associate it with the Application:

- **`environment`** links the resource to the Radius Environment. Each resource sets this to the `environment` parameter, whose value the Radius CLI supplies at deploy time.
- **`application`** links the resource to the Application, using the Application's `.id`.

The demo adds a container that runs the application's front end:

{{< rad file="/static/samples/demo/app.bicep" embed=true startLine=20 endLine=36 markdownConfig=`{hl_lines=["4-5"]}` >}}

Referencing `demoApp.id` creates a symbolic dependency, so Radius creates the Application before the container.

## Step 6: Choose the right Resource Type

Model each part of your application with the Resource Type that best represents it. Radius ships with a set of [out-of-the-box Resource Types]({{< ref "/reference/resources" >}}) for compute, data, messaging, and more, and your platform team can publish [custom Resource Types]({{< ref "/extensibility/resource-types" >}}) for anything specific to your organization.

- Browse the [Resource Types reference]({{< ref "/reference/resources" >}}) for each type's properties, API versions, and examples.
- List the types installed in your control plane with [`rad resource-type list`]({{< ref rad_resource-type_list >}}), or browse them in the [Radius Dashboard]({{< ref "/installation/dashboard" >}}).

The Environment's [Recipe Packs]({{< ref "/concepts/recipe-packs" >}}) must contain a recipe for every Resource Type your definition uses. Without a matching recipe, the deployment fails because Radius does not know how to provision that resource.

## Step 7: Parameterize the definition

Use Bicep parameters for values that change between Environments or deployments, such as a container image or a resource size. Parameters keep a single definition reusable across `dev`, `test`, and `prod`. The demo declares an `image` parameter with the published image as its default:

{{< rad file="/static/samples/demo/app.bicep" embed=true startLine=6 endLine=7 >}}

The container uses the parameter instead of hard-coding the image:

{{< rad file="/static/samples/demo/app.bicep" embed=true startLine=20 endLine=36 markdownConfig=`{hl_lines=[8]}` >}}

Supply parameter values at deploy time with `--parameters`, or store them in a `.bicepparam` file. Keep the `environment` parameter as is; the Radius CLI supplies it automatically.

## Next steps

With the resources modeled, connect them together to model dependencies within the Application.

{{< button text="Next step: How to model application dependencies using connections" page="/applications/connections" >}}

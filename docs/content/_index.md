---
type: docs
title: "Radius Documentation"
linkTitle: "Home"
description: "Build and deploy applications on AWS, Azure, and local Kubernetes with Radius."
weight: 1
no_list: true
---

{{% alert color="primary" %}}
{{< image src="radius-logo.svg" alt="Radius logo" width="400px" >}} <br /><br />
Radius is an open-source application platform for AWS, Azure, and local Kubernetes, as well as edge and on-premises environments. Developers define applications and their dependencies. Platform engineers use recipes to control how and where those resources are deployed.
{{% /alert %}}

{{< button text="Get started with Radius 🚀" page="getting-started" color="success" size="btn-lg" >}}

## What you can do with Radius

{{< cardpane >}}
  {{% card header="**🔍 Understand and operate your applications**" %}}
  See your whole application, including services, infrastructure, and their connections, as a live graph to onboard faster, debug issues, and manage changes with confidence.

  [**Explore applications →**]({{< ref "concepts/applications" >}})
  {{% /card %}}
  {{% card header="**🏗️ Standardize how your teams build and deploy**" %}}
  Define reusable Resource Types, Recipes, and environments so every team follows the same golden paths and meets your cost, security, and operations requirements.

  [**Discover Resource Types →**]({{< ref "concepts/resource-types" >}})
  {{% /card %}}
{{< /cardpane >}}
{{< cardpane >}}
  {{% card header="**🧰 Give developers self-service infrastructure**" %}}
  Let application teams provision the databases, caches, and messaging they need on demand, while platform engineers control how that infrastructure is created with Recipes.

  [**Learn about Recipes →**]({{< ref "concepts/recipe-packs" >}})
  {{% /card %}}
  {{% card header="**🚀 Deploy across environments**" %}}
  Use the same application definition in local, AWS, and Azure Environments when their recipes implement the Resource Types your application uses. Each Environment selects its deployment targets and Recipe Packs.

  [**Understand environments →**]({{< ref "concepts/environments" >}})
  {{% /card %}}
{{< /cardpane >}}

## Deploy to AWS and Azure

{{< cardpane >}}
  {{% card header="**🟨 Amazon Web Services (AWS)**" %}}
  Run the Radius control plane on [Amazon EKS]({{< ref "installation#supported-kubernetes-clusters" >}}). To provision AWS resources through recipes, register an IAM access key or use IAM Roles for Service Accounts (IRSA).

  [**Configure an IAM access key →**]({{< ref "installation/cloud-providers/aws-access-key" >}})

  [**Configure IRSA →**]({{< ref "installation/cloud-providers/aws-irsa" >}})
  {{% /card %}}
  {{% card header="**🟦 Microsoft Azure**" %}}
  Run the Radius control plane on [Azure Kubernetes Service (AKS)]({{< ref "installation#supported-kubernetes-clusters" >}}). To provision Azure resources through recipes, register a service principal or use workload identity.

  [**Configure a service principal →**]({{< ref "installation/cloud-providers/azure-service-principal" >}})

  [**Configure workload identity →**]({{< ref "installation/cloud-providers/azure-workload-identity" >}})
  {{% /card %}}
  {{% card header="**🎯 Configure deployment targets**" %}}
  Cloud credentials authorize Radius to provision resources. Each Environment selects the target cloud configuration and Recipe Packs. Reuse an application definition across clouds when their recipes implement the Resource Types it uses.

  [**Configure AWS and Azure deployments →**]({{< ref "aws-and-azure" >}})

  [**Understand cross-cloud deployment →**]({{< ref "concepts#deploying-across-aws-and-azure" >}})
  {{% /card %}}
{{< /cardpane >}}

## Integrations

{{< cardpane >}}
  {{% card header="**🤖 GitHub Copilot app** <span class='badge bg-primary rounded-pill ms-1'>New</span>" %}}
  Model, visualize, and deploy applications directly from your source code repository with Radius Canvas.

  [**Use Radius with GitHub Copilot →**]({{< ref "integrations/github-copilot-app" >}})
  {{% /card %}}
  {{% card header="**🧱 Use your existing Infrastructure as Code**" %}}
  Use the infrastructure-as-code tools you already know, Bicep and Terraform, to author Radius applications and Recipes.

  [**Author Recipes →**]({{< ref "extensibility/custom-recipes" >}})
  {{% /card %}}
  {{% card header="**🔄 GitOps**" %}}
  Deploy and manage Radius applications through your GitOps workflows using tools like Flux.

  [**Deploy with GitOps →**]({{< ref "integrations/gitops" >}})
  {{% /card %}}
  {{% card header="**📊 Backstage-based Dashboard**" %}}
  Visualize and interact with your applications, environments, and Recipes in the Radius dashboard, built on Backstage.

  [**Explore the dashboard →**]({{< ref "installation/dashboard" >}})
  {{% /card %}}
{{< /cardpane >}}

## Get involved

{{< cardpane >}}
  {{% card header="**🤝 Contribute**" %}}
  Help improve Radius through code, docs, or by sharing your experience.

  [**Start contributing →**]({{< ref contributing >}})
  {{% /card %}}
  {{% card header="**🗺️ Roadmap**" %}}
  See what's planned for Radius and where the project is headed.

  [**View the roadmap →**](https://aka.ms/radius-roadmap)
  {{% /card %}}
  {{% card header="**💬 Community**" %}}
  Connect with the Radius community to ask questions and stay up to date.

  [**Join us on Discord →**](https://aka.ms/Radius/Discord)
  {{% /card %}}
{{< /cardpane >}}

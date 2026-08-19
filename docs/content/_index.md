---
type: docs
title: "Radius Documentation"
linkTitle: "Home"
description: "Radius enables developers and the platform engineers that support them to build cloud-native applications"
weight: 1
no_list: true
---

{{% alert color="primary" %}}
{{< image src="radius-logo.svg" alt="Radius logo" width="400px" >}} <br /><br />
Radius is an open-source, multi-cloud application platform that helps developers and the platform engineers who support them build, deploy, and manage cloud-native applications. Teams get a clear view of their applications and how they run across environments, from dev to cloud, edge, and on-prem, while making sure their infrastructure meets cost, operations, and security requirements.
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
  {{% card header="**🚀 Ship your app to any environment**" %}}
  Define your application once and run it consistently across dev, cloud, edge, and on-prem, without rewriting it for each target.

  [**Understand environments →**]({{< ref "concepts/environments" >}})
  {{% /card %}}
{{< /cardpane >}}

## Integrations

{{< cardpane >}}
  {{% card header="**🧱 Use your existing Infrastructure as Code**" %}}
  Use the infrastructure-as-code tools you already know, Bicep and Terraform, to author Radius applications and Recipes.

  [**Author Recipes →**]({{< ref "extensibility/custom-recipes" >}})
  {{% /card %}}
  {{% card header="**☁️ Run on your platforms**" %}}
  Run Radius on Kubernetes and connect it to your cloud platforms, including Azure and AWS.

  [**Configure providers →**]({{< ref "installation/cloud-providers" >}})
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

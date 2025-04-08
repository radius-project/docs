---
type: docs
title: "Overview: Radius Dashboard"
linkTitle: "Overview"
description: "Learn about using the Radius Dashboard to visualize your application graph, environments, and recipes"
weight: 100
categories: "Overview"
tags: ["dashboard"]
---

## What is the Radius Dashboard?

The Radius Dashboard is the frontend experience for Radius and provides a graphical interface for visualizing your [Application Graph]({{< ref "guides/author-apps/application/overview#query-and-understand-your-application-with-the-radius-application-graph" >}}), [Environments]({{< ref "guides/deploy-apps/environments/overview" >}}), and [Recipes]({{< ref "guides/recipes/overview" >}}). It provides both textual and visual representations of your Radius Applications and resources, as well as a directory of Recipes that are available in each Environment.

{{< image src="dashboard-home.png" alt="screenshot of an example Radius Dashboard home page" width=800 >}}

## Built with extensibility in mind

The Radius Dashboard is built on [Backstage](https://backstage.io/), an open-source platform for building developer portals that provides a rich set of components to accelerate UI development. It is a skinned deployment of Backstage that includes a set of plugins that provide the Radius experience. The components that make up the dashboard are built with extensibility in mind so that they can be used in other contexts beyond Backstage in the future.

## Key features

The Radius Dashboard currently provides the following features:

- **Application graph visualization**: A visualization of the [application graph]({{< ref "guides/author-apps/application/overview#query-and-understand-your-application-with-the-radius-application-graph" >}}) that shows how resources within an application are connected to each other and the underlying infrastructure.
- **Resource overview and details**: Detailed information about resources within Radius, including [applications]({{< ref "guides/author-apps/application/overview" >}}), [environments]({{< ref "guides/deploy-apps/environments/overview" >}}), and infrastructure.
- **Recipes directory**: A listing of all the Radius [Recipes]({{< ref "guides/recipes/overview" >}}) available to the user for a given environment.

## Installation

The Radius Dashboard is installed by default as a part of your Radius initialization and deployment.

{{< alert title="Opting-out" color="warning" >}}
To opt-out of installing the dashboard, you can use the `--set dashboard.enabled=false` flag when running `rad init` or `rad install kubernetes`. See more instructions in the Radius [initialization]({{< ref "installation#step-3-initialize-radius" >}}) and [installation]({{< ref "guides/operations/kubernetes/kubernetes-install" >}}) guides.
{{< /alert >}}

To remove the dashboard from your existing installation of Radius on your cluster, you can run:

```bash
rad install kubernetes --reinstall --set dashboard.enabled=false
```

## Accessing the Dashboard

When you run your application with the `rad run` command, Radius creates a port-forward from `localhost` to port `7007` inside the container that you may use to access your Radius Dashboard by visiting [http://localhost:7007](http://localhost:7007) in a browser.

Alternatively, you can manually create a port-forward from `localhost` to the port number of your choice to provide access to your Radius Dashboard:

```bash
kubectl port-forward --namespace=radius-system svc/dashboard 7007:80
```

## Reference documentation

Visit the [API reference documentation]({{< ref "concepts/technical/api" >}}) to learn more about the underlying [Radius Application Graph]({{< ref "guides/author-apps/application/overview#query-and-understand-your-application-with-the-radius-application-graph" >}}) data on which the dashboard visualizations are built.

To get started with trying the Radius Dashboard, see the [getting started guide]({{< ref "getting-started" >}}):

{{< button text="Getting started" page="getting-started" >}}

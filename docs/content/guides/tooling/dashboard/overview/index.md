---
type: docs
title: "Overview: Radius Dashboard"
linkTitle: "Overview"
description: "Learn about using the Radius Dashboard to visualize your application graph, environments, and recipes"
weight: 100
categories: "Overview"
tags: ["dashboard"]
---

Radius Dashboard is the frontend experience for Radius and built on [Backstage](https://backstage.io/), an open-source platform for building developer portals that provides a rich set of components to accelerate UI development. The Radius Dashboard is a skinned deployment of Backstage that includes a set of plugins that provide the Radius experience. The components that make up the dashboard are built with extensibility in mind so that they can be used in other contexts beyond Backstage in the future.

Key features of the Radius Dashboard currently include:

- _Application graph visualization_: A visualization of the [application graph]({{< ref "guides/author-apps/application/overview#query-and-understand-your-application-with-the-radius-application-graph" >}}) that shows how resources within an application are connected to each other and the underlying infrastructure.
- _Resource overview and details_: Detailed information about resources within Radius, including [applications]({{< ref "guides/author-apps/application/overview" >}}), [environments]({{< ref "guides/deploy-apps/environments/overview" >}}), and infrastructure.
- _Recipes directory_: A listing of all the Radius [Recipes]({{< ref "guides/recipes/overview" >}}) available to the user for a given environment.

{{< alert title="Dashboard installation" color="warning" >}}
The Radius Dashboard is installed by default as a part of your Radius initialization and deployment. To opt-out of installing the dashboard, you can use the `--TODO` flag when running `rad init`, `rad deploy`, or `rad run`. See more instructions in the [CLI reference documentation]({{< ref "/reference/cli" >}}).
{{< /alert >}}

When you run your application with the `rad run` command, Radius creates a port-forward from `localhost` to port `TODO` inside the container that you may use to access your Radius Dashboard.

Alternatively, you can manually create a port-forward from `localhost` to the port number of your choice to provide access to your Radius Dashboard:

```bash
kubectl port-forward svc/TODO 3000:80
```

{{< image src="dashboard-home.png" alt="screenshot of an example Radius Dashboard home page" width=800 >}}

## Reference documentation

Visit the [API reference documentation]({{< ref "concepts/technical/api" >}}) to learn more about the underlying [Radius Application Graph]({{< ref "guides/author-apps/application/overview#query-and-understand-your-application-with-the-radius-application-graph" >}}) on which the dashboard visualizations are built.

{{< button text="API reference" page="concepts/technical/api" >}}

---
type: docs
title: "Getting started with Radius: Run your first app"
linkTitle: "Getting started"
weight: 10
description: "Take a tour of Radius by getting started with your first app"
aliases:
    - /getting-started/tutorial/
    - /getting-started/install/
    - /getting-started/first-app/
---

This guide will show you how to quickly get started with Radius. You'll walk through both installing Radius and running your first Radius app.

**Estimated time to complete: 10 min**

{{< image src="diagram.png" alt="Diagram of the application and its resources" width="500px" >}}

<!-- commenting until we enable free minutes to try Codepaces
{{< alert title="🚀 Run in a <b>free</b> GitHub Codespace" color="primary" >}}
The Radius getting-started guide can be [run **for free** in a GitHub Codespace](https://github.blog/changelog/2022-11-09-codespaces-for-free-and-pro-accounts/). Visit the following link to get started in seconds:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/radius-project/samples)
{{< /alert >}}-->

## 1. Have your Kubernetes cluster handy

Radius runs inside [Kubernetes]({{< ref "guides/operations/kubernetes" >}}). However you run Kubernetes, get a cluster ready.
> *If you don't have a preferred way to create Kubernetes clusters, you could try using [k3d](https://k3d.io/), which runs a minimal Kubernetes distribution in Docker. Make sure to apply the [recommended configuration]({{< ref "guides/operations/kubernetes/overview#supported-kubernetes-clusters" >}}).*

Ensure your cluster is set as your current context:

```bash
kubectl config current-context
```

## 2. Install Radius CLI

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## 3. Initialize Radius

Create a new directory for your app and navigate into it:

```bash
mkdir first-app
cd first-app
```

Initialize Radius. For this example, accept all the default options (press ENTER to confirm):

```bash
rad init
```

Example output:

```
Initializing Radius...

✅ Install Radius {{< param version >}}
    - Kubernetes cluster: k3d-k3s-default
    - Kubernetes namespace: radius-system
✅ Create new environment default
    - Kubernetes namespace: default
    - Recipe pack: local-dev
✅ Scaffold application docs
✅ Update local configuration

Initialization complete! Have a RAD time 😎
```

In addition to starting Radius services in your Kubernetes cluster, this initialization command creates a default application (`app.bicep`) as your starting point. It contains a single container definition (`demo`). `rad init` also creates a [`bicepconfig.json`]({{< ref "/guides/tooling/bicepconfig/overview" >}}) file in your application's directory that has the necessary setup to use Radius with the official Bicep compiler.

{{< rad file="snippets/app.bicep" embed=true markdownConfig="{linenos=table,linenostart=1}" >}}

> This file will run the `ghcr.io/radius-project/samples/demo:latest` image. This image is published by the Radius team to a public registry, you do not need to create it.

## 4. Run the app

Use the below command to run the app in your environment, then access the application by opening [http://localhost:3000](http://localhost:3000) in a browser.

```bash
rad run app.bicep
```

This command:

- Runs the application in your Kubernetes cluster
- Creates a port-forward from localhost to port 3000 inside the container so you can navigate to the app's frontend UI
- Creates a port-forward from localhost to port 7007 inside the container so you can navigate to your Radius Dashboard
- Streams container logs to your terminal

<br>
In your browser you should see the demo app:

{{< image src="demo-screenshot.png" alt="Screenshot of the demo container" width=600px >}}
<br>

Access your Radius Dashboard by opening [http://localhost:7007](http://localhost:7007/resources/default/Applications.Core/applications/demo/application) in a browser. In your browser, you should see the Radius Dashboard, which includes visualizations of the application graph, environments, and recipes:

{{< image src="demo-dashboard-appgraph.png" alt="screenshot of an example Radius Dashboard home page" width=800 >}}
<br><br>

> Congrats! You're running your first Radius app. <br> When you're ready to move on to the next step, use <kbd>CTRL</kbd>+ <kbd>C</kbd> to exit the command.

## 5. Add Database

This step will add a database (Redis Cache) to the application.

You can create a Redis Cache using [Recipes]({{< ref "guides/recipes/overview" >}}) provided by Radius. The Radius community provides Recipes for running commonly used application dependencies, including Redis.

In this step you will:

- Add Redis to the application using a Recipe.
- Connect to Redis from the `demo` container using environment variables that Radius automatically sets.

Open `app.bicep` in your editor and get ready to edit the file.

First add some new code to `app.bicep` by pasting in the content below at the end of the file. This code creates a Redis Cache using a Radius Recipe:

{{< rad file="snippets/app-with-redis-snippets.bicep" embed=true marker="//REDIS" markdownConfig="{linenos=table,linenostart=21}" >}}

Next, update your container definition to include `connections` inside `properties`. This code creates a connection between the container and the database. Based on this connection, Radius will [inject environment variables]({{< ref "/guides/author-apps/containers/overview#connections" >}}) into the container that inform the container how to connect. You will view these in the next step.

{{< rad file="snippets/app-with-redis-snippets.bicep" embed=true marker="//CONNECTION" markdownConfig="{linenos=table,hl_lines=[\"13-17\"],linenostart=7}" >}}

Your updated `app.bicep` will look like this:

{{< rad file="snippets/app-with-redis.bicep" embed=true markdownConfig="{linenos=table}" >}}

## 6. Rerun the application with a database

Use the command below to run the updated application again, then open the browser to [http://localhost:3000](http://localhost:3000).

```sh
rad run app.bicep
```

You should see the Radius Connections section with new environment variables added. The `demo` container now has connection information for Redis (`CONNECTION_REDIS_HOST`, `CONNECTION_REDIS_PORT`, etc.):

{{< image src="demo-with-redis-screenshot.png" alt="Screenshot of the demo container" width=800px >}}
<br /><br />

Navigate to the Todo List tab and test out the application. Using the Todo page will update the saved state in Redis:

{{< image src="demo-with-todolist.png" alt="Screenshot of the todolist" width=700px >}}
<br /><br />

Access your Radius Dashboard again by opening [http://localhost:7007](http://localhost:7007/resources/default/Applications.Core/applications/demo/application) in a browser. You should see a visualization of the application graph for your `demo` app, including the connection to the `db` Redis Cache:

{{< image src="demo-dashboard-appgraph-db.png" alt="screenshot of an example Radius Dashboard home page" width=800 >}}
<br><br>

> Press <kbd>CTRL</kbd>+ <kbd>C</kbd> when you are finished with the websites.

## 7. View the application graph

Radius Connections are more than just environment variables and configuration. You can also access the "application graph" and understand the connections within your application with the following command:

```bash
rad app graph
```

You should see the following output, detailing the connections between the `demo` container and the `db` Redis Cache, along with information about the underlying Kubernetes resources running the app:

```
Displaying application: demo

Name: demo (Applications.Core/containers)
Connections:
  demo -> db (Applications.Datastores/redisCaches)
Resources:
  demo (kubernetes: apps/Deployment)
  demo (kubernetes: core/Secret)
  demo (kubernetes: core/Service)
  demo (kubernetes: core/ServiceAccount)
  demo (kubernetes: rbac.authorization.k8s.io/Role)
  demo (kubernetes: rbac.authorization.k8s.io/RoleBinding)

Name: db (Applications.Datastores/redisCaches)
Connections:
  demo (Applications.Core/containers) -> db
Resources:
  redis-r5tcrra3d7uh6 (kubernetes: apps/Deployment)
  redis-r5tcrra3d7uh6 (kubernetes: core/Service)
```

## 8. Cleanup

To delete your app, run the [rad app delete]({{< ref rad_application_delete >}}) command to cleanup the app and its resources, including the Recipe resources:

```bash
rad app delete first-app -y
```

## Next steps

Now that you've run your first Radius app, you can learn more about Radius by reading the following guides:

- [Tutorials]({{< ref tutorials >}}) - Learn how to build and deploy a variety of applications with Radius

<br>
{{< button text="Next step: Radius Tutorials" page="tutorials" >}}

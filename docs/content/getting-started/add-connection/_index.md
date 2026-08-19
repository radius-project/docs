---
type: docs
title: "3. Add a connection"
linkTitle: "3. Add a connection"
description: "Add a PostgreSQL database and connect the Radius Demo container to it"
weight: 300
---

The Radius Demo application runs on its own, but most applications depend on other resources such as databases and caches. In this step you will add a PostgreSQL database to the application and create a *connection* from the container to it.

## Add a PostgreSQL database and connection

The `app-postgresql.bicep` definition builds on `app.bicep` by adding a `Radius.Data/postgreSqlDatabases` resource, a `@secure()` password parameter, and a `connections` entry on the container. The highlighted lines are the additions:

<div class="td-max-width-on-larger-screens" style="margin-bottom: -2rem;"><a href="https://github.com/radius-project/samples/blob/{{< param version >}}/samples/demo/app-postgresql.bicep" target="_blank" rel="noopener">samples/demo/app-postgresql.bicep</a></div>

{{< rad file="/static/samples/demo/app-postgresql.bicep" embed=true markdownConfig=` {hl_lines=["6-8","36-40","44-54"]}` >}}

The `postgresql` resource is provisioned by the PostgreSQL recipe in the default Recipe Pack. The `password` parameter is declared with `@secure()`, which keeps its value out of deployment logs and history and lets you supply the password at deploy time instead of hardcoding it. Because the `password` property is `x-radius-sensitive` on the Resource Type, Radius also encrypts it and redacts it from reads.

The `connections` entry tells Radius that the container depends on the database. Radius provisions the database first, then injects its connection details into the container as environment variables named `CONNECTION_POSTGRESQL_<PROPERTY>`, such as `CONNECTION_POSTGRESQL_HOST` and `CONNECTION_POSTGRESQL_PORT`.

## Redeploy the application

Deploy the updated definition from its published URL. The `--parameters password=` flag sets the database password, and `$(openssl rand -hex 16)` generates a random value on each deploy. This works in Bash and Zsh; in PowerShell, generate the value separately and pass it in:

{{< rad-deploy path="samples/demo/app-postgresql.bicep" args="--parameters password=$(openssl rand -hex 16)" >}}

Radius creates the database and updates the container with the connection. Forward a local port to the container and open the application again:

```bash
kubectl port-forward svc/demo-default-web 3000:3000
```

Open [http://localhost:3000](http://localhost:3000). The Radius Connections section now lists the `postgresql` connection.

{{< image src="todolist.png" alt="The Radius Demo application showing the PostgreSQL connection" width=800px >}}

## View the connection in the Dashboard

Start port forwarding for the Dashboard:

```bash
kubectl port-forward svc/dashboard 7007:80 -n radius-system
```

Open [http://localhost:7007](http://localhost:7007) and select the `demo-default` application. The graph shows the `demo-default` container connected to the `postgresql-default` database.

{{< image src="dashboard.png" alt="The Radius Dashboard showing the container connected to the PostgreSQL database" width=800px >}}
<br/>

To learn more about modeling dependencies between resources, see [How to model application dependencies using connections]({{< ref "/applications/connections" >}}).

## Clean up

Delete the Radius Demo application:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application delete demo-default --preview
```

Optionally, uninstall Radius and remove all of its data:

```bash
rad uninstall kubernetes --purge
```

## Next steps

You have installed Radius, deployed the Radius Demo application, and connected it to a PostgreSQL database. Continue with the hands-on labs for deeper, real-world scenarios.

{{< button text="Next step: Explore the labs" page="getting-started/labs" >}}

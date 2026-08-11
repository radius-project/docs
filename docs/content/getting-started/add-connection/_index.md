---
type: docs
title: "3. Add a connection"
linkTitle: "3. Add a connection"
description: "Add a database and connect the Todo List container to it"
weight: 300
---

The Todo List application runs on its own, but most applications depend on other resources such as databases and caches. In this step you will add a PostgreSQL database to the application and create a *connection* from the container to the database.

## Add a database

Open `app.bicep` and add a `Radius.Data/postgreSqlDatabases` resource:

```bicep
@description('The password for the PostgreSQL database. Example: `rad deploy app.bicep -p password=$(openssl rand -hex 16)`.')
@secure()
param password string

resource db 'Radius.Data/postgreSqlDatabases@2025-08-01-preview' = {
  name: 'db'
  properties: {
    environment: environment
    application: application
    username: 'myadmin'
    // From a @secure() password parameter passed in via the CLI
    password: password
    size: 'S'
  }
}
```

The `db` resource is provisioned by the PostgreSQL recipe in the default Recipe Pack.

The `password` parameter is declared with `@secure()`, which keeps its value out of deployment logs and history and lets you supply the password at deploy time instead of hardcoding it. Because the `password` property is `x-radius-sensitive` on the Resource Type, Radius also encrypts it and redacts it from reads.

## Connect the container to the database

Add a `connections` entry to the `frontend` container. The highlighted lines are the only change:

```bicep {hl_lines=["16-20"]}
resource demo 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'demo'
  properties: {
    environment: environment
    application: application
    containers: {
      demo: {
        image: 'ghcr.io/radius-project/samples/demo:latest'
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
    }
    connections: {
      postgresql: {
        source: db.id
      }
    }
  }
}
```

The `connections` entry tells Radius that the container depends on the database. Radius provisions the database first, then injects its connection details into the container as environment variables named `CONNECTION_DB_<PROPERTY>`, such as `CONNECTION_DB_HOST` and `CONNECTION_DB_PORT`.

## Redeploy the application

```bash
rad deploy app.bicep --application todolist -p password=$(openssl rand -hex 16) --preview
```

The `-p password=` flag sets the `password` parameter for the database. `$(openssl rand -hex 16)` is a shell command that generates a random secure string, so a new password is used on each deploy. This syntax works in Bash and Zsh. In PowerShell, generate the value separately and pass it in.

Radius creates the database and updates the container with the connection. Forward a local port to the container and open the application again:

```bash
kubectl port-forward svc/demo-demo 3000:3000
```

Open [http://localhost:3000](http://localhost:3000). The Radius Connections section now lists the `db` connection.

{{< image src="todolist.png" alt="The Todo List application showing the database connection" width=800px >}}

## View the connection in the Dashboard

Start port forwarding for the Dashboard:

```bash
kubectl port-forward svc/dashboard 7007:80 -n radius-system
```

Open [http://localhost:7007](http://localhost:7007) and select the Todo List application. The graph shows the `frontend` container connected to the `db` database.

{{< image src="dashboard.png" alt="The Radius Dashboard showing the frontend container connected to the database" width=800px >}}
<br/>

To learn more about modeling dependencies between resources, see [How to model application dependencies using connections]({{< ref "/applications/connections" >}}).

## Clean up

Delete the Todo List application:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application delete todolist --preview
```

Optionally, uninstall Radius and remove all of its data:

```bash
rad uninstall kubernetes --purge
```

## Next steps

You have installed Radius, deployed the Todo List application, and connected it to a database. Continue with the Radius Labs for deeper, real-world scenarios.

{{< button text="Next step: Explore the Labs" page="getting-started/labs" >}}

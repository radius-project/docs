---
type: docs
title: "3. Add a connection"
linkTitle: "3. Add a connection"
description: "Add a Redis cache and connect the Radius Demo container to it"
weight: 300
---

The Radius Demo application runs on its own, but most applications depend on other resources such as databases and caches. In this step you will add a Redis cache to the application and create a *connection* from the container to it.

## Add a Redis cache and connection

The `app-redis.bicep` definition builds on `app.bicep` by adding a `Radius.Data/redisCaches` resource and a `connections` entry on the container. The highlighted lines are the additions:

<div class="td-max-width-on-larger-screens" style="margin-bottom: -2rem;"><a href="https://github.com/radius-project/samples/blob/{{< param version >}}/samples/demo/app-redis.bicep" target="_blank" rel="noopener">samples/demo/app-redis.bicep</a></div>

{{< rad file="/static/samples/demo/app-redis.bicep" embed=true markdownConfig=` {hl_lines=["32-36","40-47"]}` >}}

The `redis` resource is provisioned by the Redis recipe in the default Recipe Pack. The `connections` entry tells Radius that the container depends on the cache. Radius provisions the cache first, then injects its connection details into the container as environment variables named `CONNECTION_REDIS_<PROPERTY>`, such as `CONNECTION_REDIS_HOST` and `CONNECTION_REDIS_PORT`.

## Redeploy the application

Deploy the updated definition from its published URL:

{{< rad-deploy path="samples/demo/app-redis.bicep" >}}

Radius creates the cache and updates the container with the connection. Forward a local port to the container and open the application again:

```bash
kubectl port-forward svc/demo-default-web 3000:3000
```

Open [http://localhost:3000](http://localhost:3000). The Radius Connections section now lists the `redis` connection.

<!-- TODO: reshoot this screenshot for the Redis connection (currently shows the old PostgreSQL example). -->
{{< image src="todolist.png" alt="The Radius Demo application showing the Redis connection" width=800px >}}

## View the connection in the Dashboard

Start port forwarding for the Dashboard:

```bash
kubectl port-forward svc/dashboard 7007:80 -n radius-system
```

Open [http://localhost:7007](http://localhost:7007) and select the `demo-default` application. The graph shows the `demo-default` container connected to the `redis-default` cache.

<!-- TODO: reshoot this screenshot for the Redis connection (currently shows the old PostgreSQL example). -->
{{< image src="dashboard.png" alt="The Radius Dashboard showing the container connected to the Redis cache" width=800px >}}
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

You have installed Radius, deployed the Radius Demo application, and connected it to a Redis cache. Continue with the hands-on labs for deeper, real-world scenarios.

{{< button text="Next step: Explore the labs" page="getting-started/labs" >}}

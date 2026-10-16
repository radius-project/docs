---
type: docs
title: "3. Add a connection"
linkTitle: "3. Add a connection"
description: "Add a PostgreSQL database and connect the Radius Demo container to it"
weight: 300
---

The Radius Demo application runs on its own, but most applications depend on other resources such as databases and caches. In this step you will add a PostgreSQL database and an authored Secret to the application, then connect the container to both resources.

> **Private development only:** This Kubernetes demo explicitly sets the database's `tls` policy to `disabled` and the existing PostgreSQL client's `PGSSLMODE` to `disable`. Password authentication remains enabled, but database traffic is unencrypted and credentials and queries can be exposed in transit. Use only a disposable, private development cluster, never a production database. No TLS Secret or client CA is needed for this mode.

The Resource Type's default remains `required`. Both `required` and `optional` need operator-provided certificates; `optional` is not a certificate-free alternative. The guarded Azure Recipe rejects `disabled`. For secure deployments and migration, see the [PostgreSQL operator guide](https://github.com/radius-project/resource-types-contrib/blob/67b77684cc165f069a392b7d3e9151318feab062/Data/postgreSqlDatabases/README.md#kubernetes-tls-prerequisites). Complete the [compatible-artifact prerequisite]({{< ref "/getting-started/install-radius#prerequisites" >}}) before proceeding; the linked policy is a candidate, not proof of published support.

The Kubernetes database Recipes have no explicit durable database volume. Pod replacement can lose all demo data. Do not use this tutorial to change the policy of an existing database.

## Add a PostgreSQL database and connections

The `app-postgresql.bicep` definition builds on `app.bicep` by adding a `Radius.Data/postgreSqlDatabases` resource, a `Radius.Security/secrets` resource, a `@secure()` password parameter, and two `connections` entries on the container. It also explicitly disables TLS on the server and client. The highlighted lines are the additions:

<div class="td-max-width-on-larger-screens" style="margin-bottom: -2rem;"><a href="https://github.com/radius-project/samples/blob/{{< param version >}}/samples/demo/app-postgresql.bicep" target="_blank" rel="noopener">samples/demo/app-postgresql.bicep</a></div>

{{< rad file="/static/samples/demo/app-postgresql.bicep" embed=true markdownConfig=` {hl_lines=["6-11","32-36","44-51","55-66","68-79"]}` >}}

The `postgresql` resource is provisioned by the PostgreSQL Recipe in the Environment's Recipe Pack. The `password` parameter is declared with `@secure()`, which keeps its value out of deployment logs and history and lets you supply the password at deploy time instead of hardcoding it. The application passes that value directly to the database's `password` property. Because the property is `x-radius-sensitive`, Radius encrypts it and redacts it from reads.

The application also stores the same value under the `password` key of the authored `postgresqlCredentials` Secret instead of relying on database Recipe `result.secrets` for a developer-owned credential. The Secret has the same application and environment as the other resources, so it shares their lifecycle. Its resource name is deliberately different from the `postgresql-${environmentName}-credentials` Kubernetes Secret owned by the PostgreSQL Recipe.

The `postgresql` connection tells Radius that the container depends on the database. Radius provisions the database first, then injects its ordinary connection values as `CONNECTION_POSTGRESQL_HOST`, `CONNECTION_POSTGRESQL_PORT`, `CONNECTION_POSTGRESQL_DATABASE`, `CONNECTION_POSTGRESQL_USERNAME`, and `CONNECTION_POSTGRESQL_TLS`.

The `postgresqlCredentials` connection points directly to the authored Secret. With a compatible Kubernetes Container Recipe, Radius projects its `password` key through a Kubernetes `secretKeyRef` as `CONNECTION_POSTGRESQLCREDENTIALS_PASSWORD`. The secret value remains in the Secret and is not copied into Recipe output or plaintext container configuration.

> **Caution:** The Radius Demo displays all `CONNECTION_*` environment variables it receives, including this password, to illustrate connection injection. Do not display secret values in a production application.
>
> **Compatibility:** Automatic Secret connection projection requires a compatible Radius runtime and Kubernetes Container Recipe. In older or mixed-version environments, keep an explicit container `env.valueFrom.secretKeyRef` binding instead of changing a working model. This does not remove the separate transport-policy compatibility prerequisite. Azure Container Instances behavior is unchanged.

## Redeploy the application

Deploy the updated definition from its published URL using a temporary ARM JSON parameter file. Run the following block in Bash with shell tracing disabled. It creates a private temporary directory and a file readable only by your user, generates a URI-safe hexadecimal password for the demo's existing connection-string construction, and removes the file on success or failure. Only the file path, not the password, appears in the deployment command's arguments.

```bash
(
  set -eu
  set +x
  umask 077
  credential_dir="$(mktemp -d)"
  trap 'rm -f "$credential_dir/parameters.json"; rmdir "$credential_dir"' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  password="$(openssl rand -hex 16)"
  printf '{"$schema":"https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#","contentVersion":"1.0.0.0","parameters":{"password":{"value":"%s"}}}\n' \
    "$password" > "$credential_dir/parameters.json"
  unset password
  rad deploy https://edge.docs.radapp.io/samples/demo/app-postgresql.bicep \
    --parameters @"$credential_dir/parameters.json"
)
```

Do not regenerate the password to retry a deployment against an existing database. For this disposable tutorial, delete only the tutorial application before starting over.

Radius creates the database and authored Secret, then updates the container with both connections. Deployment success alone does not establish readiness. Find the database's actual runtime namespace and wait for both current rollouts:

```bash
kubectl get deployment --all-namespaces \
  -l radapp.io/application=demo-default,radapp.io/resource=postgresql-default
DB_NAMESPACE='<database-runtime-namespace>'
kubectl rollout status deployment/postgresql-default -n "$DB_NAMESPACE" --timeout=180s
kubectl rollout status deployment/demo-default -n "$DEMO_NAMESPACE" --timeout=180s
kubectl port-forward svc/demo-default-web -n "$DEMO_NAMESPACE" 3000:3000
```

Use `DEMO_NAMESPACE` from the previous step and replace the database namespace placeholder with the namespace shown for this tutorial's database. Stop if either rollout fails; an old pod can still be serving the previous configuration.

Open [http://localhost:3000](http://localhost:3000). The Radius Connections section now lists the `postgresql` database connection and the `postgresqlCredentials` Secret connection. The database connection includes `appdb`, `myadmin`, port `5432`, the database's service hostname, and `tls: disabled`. The client separately uses `PGSSLMODE=disable`; the connection's TLS property is not itself a client setting.

### Verify database-backed behavior

Create a uniquely titled todo item in the demo, mark it complete, and refresh the page. In another terminal, set the same namespace variables and check the stored row and server transport setting:

```bash
kubectl exec -n "$DB_NAMESPACE" deployment/postgresql-default -c postgres -- \
  sh -ec 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SHOW ssl;" -c "SELECT title, done FROM items;"'
kubectl get pods -n "$DEMO_NAMESPACE" -l radapp.io/resource=demo-default -o wide
kubectl exec -n "$DB_NAMESPACE" deployment/postgresql-default -c postgres -- \
  sh -ec 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT a.client_addr, s.ssl FROM pg_stat_activity a JOIN pg_stat_ssl s USING (pid) WHERE a.datname = current_database() AND a.client_addr IS NOT NULL;"'
```

Expect `ssl` to be `off`, your completed item to appear in `items`, and the connection from the current demo pod's IP address to have `ssl = f`. If no demo connection appears, refresh the application and repeat the query; an empty result is not proof. These local administrative queries inspect the demo's connection; a separate plaintext `psql` connection would not prove how the demo connects. Delete the item in the UI and repeat the row query to confirm it was removed. Stop the port forward with `Ctrl+C`.

These checks establish database-backed plaintext behavior, not Recipe provenance: an older plaintext Recipe can produce the same results. The compatible-artifact prerequisite still applies.

## View the connections in the Dashboard

Start port forwarding for the Dashboard:

```bash
kubectl port-forward svc/dashboard 7007:80 -n radius-system
```

Open [http://localhost:7007](http://localhost:7007), select the `demo-default` application, and use the application graph to inspect the container's connections to the `postgresql-default` database and `postgresql-credentials-default` Secret.

To learn more about modeling dependencies between resources, see [How to model application dependencies using connections]({{< ref "/applications/connections" >}}).

## Clean up

Delete only the Radius Demo application created in this tutorial. Because the database and authored Secret belong to this application, Radius deletes them with the container:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application delete demo-default --preview
```

The deployment block removes its temporary credential file even if deployment fails. If your shell was forcibly terminated before its exit trap ran, remove only the `parameters.json` file and temporary directory created by that invocation. Do not delete other applications, namespaces, or operator-owned Secrets.

Only if this is a disposable cluster dedicated to this tutorial, optionally uninstall Radius and remove all of its data. **Do not purge a shared installation:**

```bash
rad uninstall kubernetes --purge
```

## Next steps

You have installed Radius, deployed the Radius Demo application, and connected it to a PostgreSQL database and an authored Secret. Continue with the hands-on labs for deeper, real-world scenarios.

{{< button text="Next step: Explore the labs" page="getting-started/labs" >}}

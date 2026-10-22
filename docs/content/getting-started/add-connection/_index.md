---
type: docs
title: "3. Add a connection"
linkTitle: "3. Add a connection"
description: "Add a PostgreSQL database and connect the Radius Demo container to it"
weight: 300
---

The Radius Demo application runs on its own, but most applications depend on other resources such as databases and caches. In this step you will add a PostgreSQL database and an authored Secret to the application, then connect the container to both resources.

## Add a PostgreSQL database and connections

The `app-postgresql.bicep` definition builds on `app.bicep` by adding a `Radius.Data/postgreSqlDatabases` resource, a `Radius.Security/secrets` resource, a `@secure()` password parameter, and two `connections` entries on the container. It also configures verified TLS using a mounted public CA:

<div class="td-max-width-on-larger-screens" style="margin-bottom: -2rem;"><a href="https://github.com/radius-project/samples/blob/{{< param version >}}/samples/demo/app-postgresql.bicep" target="_blank" rel="noopener">samples/demo/app-postgresql.bicep</a></div>

{{< rad file="/static/samples/demo/app-postgresql.bicep" embed=true >}}

The `postgresql` resource is provisioned by the PostgreSQL Recipe in the default Recipe Pack. The `password` parameter is declared with `@secure()`, which keeps its value out of deployment logs and history and lets you supply the password at deploy time instead of hardcoding it. The application passes that value directly to the database's `password` property. Because the property is `x-radius-sensitive`, Radius encrypts it and redacts it from reads.

The application also stores the same value under the `password` key of the authored `postgresqlCredentials` Secret instead of relying on database Recipe `result.secrets` for a developer-owned credential. The Secret has the same application and environment as the other resources, so it shares their lifecycle. Its resource name is deliberately different from the `postgresql-${environmentName}-credentials` Kubernetes Secret owned by the PostgreSQL Recipe.

The `postgresql` connection tells Radius that the container depends on the database. Radius provisions the database first, then injects its ordinary connection values as `CONNECTION_POSTGRESQL_HOST`, `CONNECTION_POSTGRESQL_PORT`, `CONNECTION_POSTGRESQL_DATABASE`, and `CONNECTION_POSTGRESQL_USERNAME`.

The `postgresqlCredentials` connection points directly to the authored Secret. With a compatible Kubernetes Container Recipe, Radius projects its `password` key through a Kubernetes `secretKeyRef` as `CONNECTION_POSTGRESQLCREDENTIALS_PASSWORD`. The secret value remains in the Secret and is not copied into Recipe output or plaintext container configuration.

> **Caution:** The Radius Demo displays all `CONNECTION_*` environment variables it receives, including this password, to illustrate connection injection. Do not display secret values in a production application.
>
> **Compatibility:** Automatic Secret connection projection requires a compatible Radius runtime and Kubernetes Container Recipe. In older or mixed-version environments, keep an explicit container `env.valueFrom.secretKeyRef` binding instead of changing a working model. Azure Container Instances behavior is unchanged.

## Redeploy the application

### Prepare PostgreSQL TLS

Before deploying this edge sample, use a PostgreSQL Kubernetes Recipe with TLS support and prepare the operator-owned certificates. The default `required` policy rejects plaintext TCP connections. `optional` permits plaintext but still requires a server certificate; it is not a workaround for missing TLS configuration.

Obtain a certificate whose DNS subject alternative names include `postgresql-<environment>.<namespace>.svc.cluster.local`, and create the following Secrets in the Environment's actual Kubernetes namespace:

```bash
environment=default
namespace=default # Replace with the namespace shown by rad env show.
kubectl create secret tls "postgresql-$environment-tls" -n "$namespace" \
  --cert=server.crt --key=server.key
kubectl create secret generic "postgresql-$environment-ca" -n "$namespace" \
  --from-file=ca.crt=ca.crt
```

Use the leaf-first server certificate chain and matching unencrypted key for the TLS Secret. The second Secret contains only the public root CA, never a private key. See the [PostgreSQL Recipe TLS guide](https://github.com/radius-project/resource-types-contrib/blob/main/Data/postgreSqlDatabases/README.md#kubernetes-tls) for the certificate procedure, including an isolated-development CA example.

The sample mounts the public CA at `/etc/postgresql-ca/ca.crt` and sets `PGSSLMODE=verify-full` and `NODE_EXTRA_CA_CERTS` for the existing PostgreSQL client. This verifies server identity as well as encrypting traffic; `CONNECTION_POSTGRESQL_TLS` alone does not configure client trust. Older plaintext-only Recipes are incompatible with this sample configuration.

**Protect existing data before redeployment or rotation.** The default Recipes have no durable database volume, and a replacement Pod starts with an empty database. Server certificate rotation requires updating the TLS Secret and explicitly restarting the database Deployment. When changing the CA, distribute it to clients first and restart the demo after updating its CA Secret.

Deploy the updated definition from its published URL. The `--parameters` argument sets the database password, and `$(openssl rand -hex 16)` generates a random value on each deploy. This works in Bash and Zsh; in PowerShell, generate the value separately and pass it in:

{{< rad-deploy path="samples/demo/app-postgresql.bicep" args=`--parameters password="$(openssl rand -hex 16)"` >}}

Radius creates the database and authored Secret, then updates the container with both connections. Wait for database readiness rather than relying solely on deployment success, then forward a local port to the container:

```bash
kubectl rollout status deployment/"postgresql-$environment" -n "$namespace" --timeout=180s
kubectl port-forward svc/demo-default-web 3000:3000 -n "$namespace"
```

Open [http://localhost:3000](http://localhost:3000). The Radius Connections section now lists the `postgresql` database connection and the `postgresqlCredentials` Secret connection.

## View the connections in the Dashboard

Start port forwarding for the Dashboard:

```bash
kubectl port-forward svc/dashboard 7007:80 -n radius-system
```

Open [http://localhost:7007](http://localhost:7007), select the `demo-default` application, and use the application graph to inspect the container's connections to the `postgresql-default` database and `postgresql-credentials-default` Secret.

To learn more about modeling dependencies between resources, see [How to model application dependencies using connections]({{< ref "/applications/connections" >}}).

## Clean up

Delete the Radius Demo application. Because the database and authored Secret belong to this application, Radius deletes them with the container:

```bash
rad application delete demo-default
```

The operator-owned server TLS and public CA Secrets are not application resources. Remove them explicitly when no consumers need them:

```bash
kubectl delete secret "postgresql-$environment-tls" "postgresql-$environment-ca" -n "$namespace"
```

Optionally, uninstall Radius and remove all of its data:

```bash
rad uninstall kubernetes --purge
```

## Next steps

You have installed Radius, deployed the Radius Demo application, and connected it to a PostgreSQL database and an authored Secret. Continue with the hands-on labs for deeper, real-world scenarios.

{{< button text="Next step: Explore the labs" page="getting-started/labs" >}}

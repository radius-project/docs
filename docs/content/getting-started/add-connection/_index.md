---
type: docs
title: "3. Add a connection"
linkTitle: "3. Add a connection"
description: "Add a PostgreSQL database and connect the Radius Demo container to it"
weight: 300
---

> **Work in progress: do not publish or run this draft.** The sample definitions are synchronized, but deployment remains blocked on the approved public TLS Recipe, retained client image, and validation against that public artifact tuple. The branch-based source links may not yet match this draft's synchronized sample checkpoint.

The Radius Demo application runs on its own, but most applications depend on other resources such as databases and caches. In this step you will add a PostgreSQL database, an authored password Secret, and a separate CA-only Secret to the application. The container will verify the database server's certificate and DNS name.

This guide targets PostgreSQL on Kubernetes, not managed Azure or AWS databases. Keep the demo local-only: it displays connection credentials in the browser. These Kubernetes PostgreSQL Recipes use ephemeral storage; replacing the database Pod can erase its data. Read the [PostgreSQL Recipe's operational guidance](https://github.com/radius-project/resource-types-contrib/blob/1a4c120fdab2b0f0c49bda692aef4b519855d79d/Data/postgreSqlDatabases/README.md) before using it outside this tutorial. This tutorial is not a production migration or certificate-rotation procedure.

## Prepare the server certificate

The operator owns the server TLS Secret. The application owns a different Secret containing only the public CA certificate. Do not connect the server Secret to the demo, project its values into environment variables, or mount its private key in the client. The CA signing key also stays outside Kubernetes and the application.

Use the Bash shell from [the prerequisites]({{< ref "/getting-started/install-radius#prerequisites" >}}), retaining its local `RAD_CONFIG` and `KUBE_CONTEXT` variables. Keep the same shell open for the following commands. Disable shell tracing before handling private files:

```bash
set -euo pipefail
set +x
umask 077
```

Read the isolated tutorial Environment's actual Kubernetes namespace. The runtime namespace is not necessarily the Environment name, `default`, or the Radius control-plane namespace `radius-system`. The namespace must already exist from the installation step; stop if it is missing rather than creating or taking over a shared namespace.

```bash
ENVIRONMENT=tutorial
NAMESPACE="$(rad environment show "$ENVIRONMENT" --group default --preview \
  --config "$RAD_CONFIG" --output json \
  | jq -er '.properties.providers.kubernetes.namespace | select(type == "string" and length > 0)')"
if [[ "$NAMESPACE" != radius-tutorial ]]; then
  printf 'Unexpected tutorial namespace: %s. Check the Environment before continuing.\n' "$NAMESPACE" >&2
  exit 1
fi
kubectl get namespace "$NAMESPACE" --context "$KUBE_CONTEXT"

DB_NAME="postgresql-${ENVIRONMENT}"
DB_HOST="${DB_NAME}.${NAMESPACE}.svc.cluster.local"
SERVER_SECRET="${DB_NAME}-tls"
printf 'Database hostname: %s\nServer Secret: %s\n' "$DB_HOST" "$SERVER_SECRET"
```

The selected Recipe uses the database resource's exact name for its Kubernetes Service and defaults the server Secret name to that name followed by `-tls`. Issue the certificate for the full hostname above, not `localhost`, an IP address, or a shortened Service name.

### Issue a local tutorial certificate

Create a private directory outside your checkout. On WSL2, use the Linux home directory. Do not commit these files, upload them as build artifacts, or print their contents:

```bash
TLS_DIR="$(mktemp -d "$HOME/radius-postgresql-tls.XXXXXXXX")"
chmod 700 "$TLS_DIR"

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 \
  -out "$TLS_DIR/ca.key"
openssl req -x509 -new -sha256 -days 2 \
  -key "$TLS_DIR/ca.key" -out "$TLS_DIR/ca.crt" \
  -subj "/CN=Radius tutorial CA" \
  -addext "basicConstraints=critical,CA:TRUE" \
  -addext "keyUsage=critical,keyCertSign,cRLSign"

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 \
  -out "$TLS_DIR/server.key"
openssl req -new -sha256 -key "$TLS_DIR/server.key" \
  -out "$TLS_DIR/server.csr" -subj "/CN=$DB_HOST"

cat > "$TLS_DIR/server.ext" <<EOF
basicConstraints=critical,CA:FALSE
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
subjectAltName=DNS:$DB_HOST
EOF

openssl x509 -req -sha256 -days 1 \
  -in "$TLS_DIR/server.csr" \
  -CA "$TLS_DIR/ca.crt" -CAkey "$TLS_DIR/ca.key" \
  -CAcreateserial -out "$TLS_DIR/server.crt" \
  -extfile "$TLS_DIR/server.ext"
chmod 600 "$TLS_DIR"/*
```

These certificates are deliberately short-lived. If you supply an operator-issued certificate instead, keep its files in a protected directory and use its CA trust bundle in place of `ca.crt`. The server certificate file must include any intermediate certificates required to build its chain.

Verify the certificate's chain, server purpose, and hostname before creating the Secret. The `-untrusted` argument supplies any intermediate certificates in the server certificate file; it does not make an untrusted certificate valid:

```bash
openssl verify -CAfile "$TLS_DIR/ca.crt" \
  -untrusted "$TLS_DIR/server.crt" \
  -purpose sslserver -verify_hostname "$DB_HOST" "$TLS_DIR/server.crt"
openssl x509 -in "$TLS_DIR/server.crt" -noout -ext subjectAltName

cert_public_key="$(openssl x509 -in "$TLS_DIR/server.crt" -pubkey -noout \
  | openssl pkey -pubin -outform DER | openssl dgst -sha256)"
key_public_key="$(openssl pkey -in "$TLS_DIR/server.key" -pubout -outform DER \
  | openssl dgst -sha256)"
if [[ "$cert_public_key" != "$key_public_key" ]]; then
  printf 'Server certificate and private key do not match.\n' >&2
  exit 1
fi
```

The first command must report `OK`. The second must list `DNS:` followed by the exact database hostname. A certificate that is trusted but names another server is not valid for this database.

### Create the operator-owned server Secret

Check that the Secret name is unused. A permissions or connection error must stop the procedure, not be treated as evidence that the Secret is absent:

```bash
existing="$(kubectl get secret "$SERVER_SECRET" -n "$NAMESPACE" \
  --context "$KUBE_CONTEXT" --ignore-not-found -o name)"
if [[ -n "$existing" ]]; then
  printf 'Refusing to overwrite existing Secret %s in %s.\n' \
    "$SERVER_SECRET" "$NAMESPACE" >&2
  exit 1
fi

kubectl create secret tls "$SERVER_SECRET" -n "$NAMESPACE" \
  --context "$KUBE_CONTEXT" --cert="$TLS_DIR/server.crt" --key="$TLS_DIR/server.key"
kubectl get secret "$SERVER_SECRET" -n "$NAMESPACE" \
  --context "$KUBE_CONTEXT" -o jsonpath='{.metadata.uid}' > "$TLS_DIR/server-secret.uid"
```

`kubectl create` also refuses an overwrite if another process creates the Secret after the check. Only certificate and key **file paths** appear in its arguments. Do not use `kubectl get secret -o yaml`, paste private keys into commands, or pass this server Secret to the application. The application receives only `ca.crt` through its separate CA Secret.

## Add a PostgreSQL database and connections

The TLS-only `app-postgresql.bicep` definition builds on `app.bicep` by adding a `Radius.Data/postgreSqlDatabases` resource, an authored password Secret, and a CA-only Secret. Its parameters require a password, the public CA certificate, and a compatible client image. The container has connections to the database and the password Secret, plus a volume mount for the CA certificate.

<div class="td-max-width-on-larger-screens" style="margin-bottom: -2rem;"><a href="https://github.com/radius-project/samples/blob/{{< param version >}}/samples/demo/app-postgresql.bicep" target="_blank" rel="noopener">samples/demo/app-postgresql.bicep</a></div>

{{< rad file="/static/samples/demo/app-postgresql.bicep" embed=true markdownConfig=` {hl_lines=["6-16","36-50","58-76","79-117"]}` >}}

[Download the application definition](/samples/demo/app-postgresql.bicep).

The `postgresql` resource is provisioned by the verified TLS Recipe in the explicit `tutorial-postgresql-tls` Recipe Pack selected during installation. Do not substitute the default pack or assume a mutable `edge` tag implements TLS. The `password` parameter is declared with `@secure()`, which keeps its value out of deployment logs and history and lets you supply the password at deploy time instead of hardcoding it. The application passes that value directly to the database's `password` property. Because the property is `x-radius-sensitive`, Radius encrypts it and redacts it from reads.

The application also stores the same value under the `password` key of the authored `postgresqlCredentials` Secret instead of relying on database Recipe `result.secrets` for a developer-owned credential. The Secret has the same application and environment as the other resources, so it shares their lifecycle. Its resource name is deliberately different from the `postgresql-${environmentName}-credentials` Kubernetes Secret owned by the PostgreSQL Recipe.

The `postgresql` connection tells Radius that the container depends on the database. Radius provisions the database first, then injects its ordinary connection values as `CONNECTION_POSTGRESQL_HOST`, `CONNECTION_POSTGRESQL_PORT`, `CONNECTION_POSTGRESQL_DATABASE`, and `CONNECTION_POSTGRESQL_USERNAME`.

The `postgresqlCredentials` connection points directly to the authored Secret. With a compatible Kubernetes Container Recipe, Radius projects its `password` key through a Kubernetes `secretKeyRef` as `CONNECTION_POSTGRESQLCREDENTIALS_PASSWORD`. The secret value remains in the Secret and is not copied into Recipe output or plaintext container configuration.

The CA-only Secret, `postgresql-ca-tutorial`, contains just `ca.crt`. It is distinct from the operator's `postgresql-tutorial-tls` Secret, the Recipe's generated `postgresql-tutorial-credentials` Secret, and the authored `postgresql-credentials-tutorial` password Secret. The Container Recipe mounts the CA Secret as a Kubernetes Secret volume at `/etc/postgresql-ca`, which is inherently read-only. The Bicep definition references the CA resource by name and declares an explicit deployment dependency so the CA Secret is provisioned before the container. Neither the server private key nor the CA signing key is delivered to the container.

The sample opts into certificate and hostname verification with `RADIUS_DEMO_POSTGRESQL_TLS=verify-full` and sets `RADIUS_DEMO_POSTGRESQL_CA_FILE` to `/etc/postgresql-ca/ca.crt`. A missing or invalid CA, an untrusted server certificate, or a hostname mismatch stops the connection; the client does not retry without TLS. Do not use `CONNECTION_POSTGRESQL_TLS` as proof of encryption: older Recipes could return `required` without configuring server TLS.

> **Caution:** The Radius Demo displays all `CONNECTION_*` environment variables it receives, including this password, to illustrate connection injection. Do not display secret values in a production application.
>
> **Compatibility:** Automatic Secret connection projection requires a compatible Radius runtime and Kubernetes Container Recipe. In older or mixed-version environments, keep an explicit container `env.valueFrom.secretKeyRef` binding instead of changing a working model. Azure Container Instances behavior is unchanged.

## Redeploy the application

Create a protected JSON parameter file that contains the database password, the public CA certificate, and the approved retained client image digest. The `image` parameter has no default in this draft. Set `IMAGE` only to the verified public digest from the installation preflight; do not use `latest` or guess an unpublished image. The digest's syntax alone does not prove that the image exists, supports TLS, or will be retained.

The serializer preserves the PEM line breaks without manual escaping. Run this once for this tutorial deployment; reuse the file when redeploying rather than silently changing the database password.

```bash
: "${IMAGE:?Set IMAGE to the approved retained demo image digest from the installation preflight.}"
if [[ ! "$IMAGE" =~ ^ghcr\.io/radius-project/samples/demo@sha256:[0-9a-f]{64}$ ]]; then
  printf 'Use the approved retained demo image digest, not a mutable tag.\n' >&2
  exit 1
fi
if [[ -e "$TLS_DIR/password.txt" || -e "$TLS_DIR/app.parameters.json" ]]; then
  printf 'Tutorial parameters already exist. Reuse them instead of generating a new password.\n' >&2
  exit 1
fi
openssl rand -hex 32 | tr -d '\n' > "$TLS_DIR/password.txt"
jq -n \
  --arg image "$IMAGE" \
  --rawfile password "$TLS_DIR/password.txt" \
  --rawfile ca "$TLS_DIR/ca.crt" \
  '{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    contentVersion: "1.0.0.0",
    parameters: {
      image: {value: $image},
      password: {value: $password},
      postgresqlCaCertificate: {value: $ca}
    }
  }' > "$TLS_DIR/app.parameters.json"
chmod 600 "$TLS_DIR/password.txt" "$TLS_DIR/app.parameters.json"
```

Only file paths, not passwords or private keys, appear in command arguments. The parameter file itself contains a password: keep it private and out of source control even though the Bicep password parameter is marked `@secure()`. It contains no server private key or CA signing key.

Deploy the updated definition from its published URL, targeting only the tutorial Environment:

{{< rad-deploy path="samples/demo/app-postgresql.bicep" args=`--environment tutorial --group default --config "$RAD_CONFIG" --parameters "@$TLS_DIR/app.parameters.json"` >}}

The remote Bicep definition accepts the CA as a parameter. It must not use `loadTextContent` to read a file relative to the remote URL.

### Parameter files in PowerShell

Native PowerShell can serialize the parameter file, but the deployment commands in this guide still run in the isolated Bash/WSL shell. Read the existing `ca.crt` and `password.txt` files through their Windows-accessible WSL path. Do not copy the server key or CA signing key into Windows just to create this parameter file, and do not switch to an unverified native Windows compiler/cache for deployment.

In WSL, print the Windows-accessible directory path without printing its contents:

```bash
wslpath -w "$TLS_DIR"
```

This alternative creates a separate temporary directory and sets a new access control list (ACL) that grants access only to your Windows account before writing the parameter file. It disables inherited permissions without changing the original certificate directory.

```powershell
$ErrorActionPreference = 'Stop'
$Image = Read-Host 'Approved retained demo image digest from the installation preflight'
if ($Image -cnotmatch '^ghcr\.io/radius-project/samples/demo@sha256:[0-9a-f]{64}$') {
    throw 'Use the approved retained demo image digest, not a mutable tag.'
}
$TlsDir = Read-Host 'Absolute path to the protected directory containing ca.crt and password.txt'
$ParameterDir = Join-Path ([System.IO.Path]::GetTempPath()) (
    'radius-postgresql-parameters-' + [guid]::NewGuid().ToString('N')
)
New-Item -ItemType Directory -Path $ParameterDir | Out-Null
$Identity = [System.Security.Principal.WindowsIdentity]::GetCurrent().User
$Acl = [System.Security.AccessControl.DirectorySecurity]::new()
$Acl.SetAccessRuleProtection($true, $false)
$Rule = [System.Security.AccessControl.FileSystemAccessRule]::new(
    $Identity, 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow'
)
$Acl.AddAccessRule($Rule)
Set-Acl -LiteralPath $ParameterDir -AclObject $Acl
$Parameters = @{
    '$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
    contentVersion = '1.0.0.0'
    parameters = @{
        image = @{ value = $Image }
        password = @{
            value = [System.IO.File]::ReadAllText((Join-Path $TlsDir 'password.txt'))
        }
        postgresqlCaCertificate = @{
            value = [System.IO.File]::ReadAllText((Join-Path $TlsDir 'ca.crt'))
        }
    }
}
$ParametersPath = Join-Path $ParameterDir 'app.parameters.json'
[System.IO.File]::WriteAllText(
    $ParametersPath,
    ($Parameters | ConvertTo-Json -Depth 4),
    [System.Text.UTF8Encoding]::new($false)
)
$ParametersPath
```

Copy only the generated file's path back to the tutorial's WSL shell, convert it with `wslpath`, and replace the deployment command's parameter-file argument with `--parameters "@$PARAMETERS_FILE"`:

```bash
read -r -p 'Windows path of the generated JSON parameter file: ' WINDOWS_PARAMETERS_FILE
PARAMETERS_FILE="$(wslpath -u "$WINDOWS_PARAMETERS_FILE")"
test -r "$PARAMETERS_FILE"
```

For a separately validated native PowerShell deployment, the equivalent argument is `--parameters "@$ParametersPath"`, or `--parameters '@app.parameters.json'` for a relative filename. Quote the `@` argument to avoid PowerShell's splatting syntax. Do not pass the contents of `$Parameters` on the command line. Such a native deployment needs its own compatible compiler/cache validation; the WSL checks do not establish it.

After deleting the tutorial application, remove only this generated Windows parameter file and its now-empty directory:

```powershell
Remove-Item -LiteralPath $ParametersPath
Remove-Item -LiteralPath $ParameterDir
```

## Verify the database connection

Wait for the database and application Deployments, then compare the database's returned host with the name covered by the certificate:

```bash
kubectl rollout status "deployment/$DB_NAME" -n "$NAMESPACE" \
  --context "$KUBE_CONTEXT" --timeout=180s
kubectl rollout status deployment/demo-tutorial -n "$NAMESPACE" \
  --context "$KUBE_CONTEXT" --timeout=180s

actual_host="$(rad resource show Radius.Data/postgreSqlDatabases "$DB_NAME" \
  --group default --config "$RAD_CONFIG" --output json \
  | jq -er '.properties.host | select(type == "string" and length > 0)')"
if [[ "$actual_host" != "$DB_HOST" ]]; then
  printf 'Database returned an unexpected host: %s. Do not bypass hostname verification.\n' "$actual_host" >&2
  exit 1
fi
```

Readiness alone does not prove an authenticated TLS connection. Use the database container's `psql` client to connect over TCP to the full Service hostname. This command streams only the public CA into a temporary file. The database password is read from the container's existing environment, not passed as a command argument or printed:

```bash
kubectl exec -i "deployment/$DB_NAME" -n "$NAMESPACE" \
  --context "$KUBE_CONTEXT" -c postgres -- sh -ec '
    set +x
    umask 077
    ca_file="$(mktemp)"
    trap "rm -f -- \"$ca_file\"" EXIT
    cat > "$ca_file"
    export PGPASSWORD="$POSTGRES_PASSWORD"
    export PGSSLMODE=verify-full
    export PGSSLROOTCERT="$ca_file"
    ssl="$(psql --host="$1" --port=5432 \
      --username="$POSTGRES_USER" --dbname="$POSTGRES_DB" \
      --no-password --set=ON_ERROR_STOP=1 --tuples-only --no-align \
      --command="SELECT ssl FROM pg_stat_ssl WHERE pid=pg_backend_pid();")"
    if [ "$ssl" != t ]; then
      printf "The authenticated database session is not encrypted.\n" >&2
      exit 1
    fi
    printf "Authenticated TLS certificate and hostname verification succeeded.\n"
  ' sh "$DB_HOST" < "$TLS_DIR/ca.crt"
```

This verifies the `psql` session, not the Node application's session. Next, run a check inside the demo container using its own repository factory and connection settings. It rejects the in-memory fallback, checks the Node client's TLS session, and exercises the running application's HTTP API. SQL queries independently confirm the HTTP writes and deletion in the `items` table.

The test creates and deletes one to-do item. If a check fails before cleanup, the test item may remain; fix the reported error and remove only that test item. No password or connection string is printed.

```bash
kubectl exec -i deployment/demo-tutorial -n "$NAMESPACE" \
  --context "$KUBE_CONTEXT" -c web -- node <<'NODE'
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { randomUUID } = require('node:crypto');
const { createFactory } = require(`${process.cwd()}/dist/db/repository`);

async function verify() {
  assert.equal(process.env.RADIUS_DEMO_POSTGRESQL_TLS, 'verify-full');
  const caFile = process.env.RADIUS_DEMO_POSTGRESQL_CA_FILE;
  assert.equal(caFile, '/etc/postgresql-ca/ca.crt');
  fs.accessSync(caFile, fs.constants.R_OK);
  const writeProbe = path.join(path.dirname(caFile), `readonly-${randomUUID()}`);
  try {
    fs.writeFileSync(writeProbe, '');
    fs.unlinkSync(writeProbe);
    throw new Error('The CA mount is writable.');
  } catch (error) {
    if (error.code !== 'EROFS') throw error;
  }

  const factory = createFactory();
  assert.equal(factory.constructor.name, 'PostgresFactory');
  const repository = await factory.create();
  try {
    assert.equal(repository.isRealDatabase(), true);
    const tls = await repository.pool.query(
      'SELECT ssl FROM pg_stat_ssl WHERE pid = pg_backend_pid()'
    );
    assert.deepEqual(tls.rows, [{ ssl: true }]);

    const base = 'http://127.0.0.1:3000/api/todos';
    const initial = { title: 'verified-tls-persistence', done: false };
    const createdResponse = await fetch(base, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(initial),
    });
    assert.equal(createdResponse.status, 200);
    const created = await createdResponse.json();
    assert.equal(typeof created.id, 'string');
    const itemUrl = `${base}/${encodeURIComponent(created.id)}`;
    const rowQuery = 'SELECT title, done FROM items WHERE id = $1';
    assert.deepEqual(
      (await repository.pool.query(rowQuery, [created.id])).rows, [initial]
    );

    const updated = { title: 'verified-tls-update', done: true };
    const updateResponse = await fetch(itemUrl, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(updated),
    });
    assert.equal(updateResponse.status, 200);
    const listedResponse = await fetch(base);
    assert.equal(listedResponse.status, 200);
    const listed = await listedResponse.json();
    assert.equal(listed.message, null);
    assert.ok(listed.items.some(item =>
      item.id === created.id && item.title === updated.title && item.done === true
    ));
    assert.deepEqual(
      (await repository.pool.query(rowQuery, [created.id])).rows, [updated]
    );

    const deletedResponse = await fetch(itemUrl, { method: 'DELETE' });
    assert.equal(deletedResponse.status, 204);
    assert.deepEqual(
      (await repository.pool.query(rowQuery, [created.id])).rows, []
    );
    console.log('PostgreSQL backend, verified Node TLS, read-only CA mount, and HTTP/SQL CRUD passed.');
  } finally {
    await repository.dispose();
  }
}
verify().catch(error => {
  console.error(`PostgreSQL verification failed: ${error.message}`);
  process.exitCode = 1;
});
NODE
```

Do not proceed merely because `rad deploy` succeeds or the browser loads. The Node check must report success without relaxing certificate or hostname verification.

### Browse the connected application

Radius creates the database and application-owned Secrets, then updates the container with its connections and CA mount. Forward a local port to the container and open the application again:

```bash
kubectl port-forward svc/demo-tutorial-web 3000:3000 \
  -n "$NAMESPACE" --context "$KUBE_CONTEXT"
```

Open [http://localhost:3000](http://localhost:3000). The Radius Connections section now lists the `postgresql` database connection and the `postgresqlCredentials` Secret connection.

## View the connections in the Dashboard

Start port forwarding for the Dashboard:

```bash
kubectl port-forward svc/dashboard 7007:80 -n radius-system --context "$KUBE_CONTEXT"
```

Open [http://localhost:7007](http://localhost:7007), select the `demo-tutorial` application, and use the application graph to inspect the container's connections to the `postgresql-tutorial` database and `postgresql-credentials-tutorial` Secret.

To learn more about modeling dependencies between resources, see [How to model application dependencies using connections]({{< ref "/applications/connections" >}}).

## Troubleshoot a failed TLS connection

Keep verification enabled while diagnosing failures. Do not set `PGSSLMODE=no-verify`, disable certificate validation, or retry with plaintext.

| Symptom | What to check |
| --- | --- |
| Database Pod is waiting for a Secret | Check that `postgresql-tutorial-tls` exists in the Environment's actual runtime namespace and is a `kubernetes.io/tls` Secret with `tls.crt` and `tls.key`. Do not print the Secret's contents. |
| Server rejects the certificate or key | Check certificate expiry, the matching private key, and the certificate chain. Re-run the local OpenSSL verification before retrying. |
| Client cannot read its CA | Check the `postgresql-ca-tutorial` Secret, its `ca.crt` key, the Container Recipe's Secret volume support, and the application's configured CA file path. Never mount the server Secret as a workaround. |
| Client reports an untrusted issuer | Supply the CA bundle that issued the server certificate. Check intermediate certificates when using an operator-issued certificate. |
| Client reports a hostname mismatch | Compare the database's returned host to `postgresql-tutorial.<runtime-namespace>.svc.cluster.local` and the certificate's DNS SAN. Reissue the certificate for that exact name; do not override hostname verification. |
| Server does not support TLS | Inspect the Environment's selected Recipe Pack and stored PostgreSQL source. A `tls` schema property or projected connection value alone does not prove that the selected Recipe enforces TLS. |
| Browser works but no database data appears | Confirm that the Node application selected its PostgreSQL backend, not the in-memory fallback, and verify its database session and stored rows. A successful deployment or page load alone is not proof of a working database connection. |

## Clean up

Stop both local port forwards with `Ctrl+C`. Delete the Radius Demo application. Its database, authored password Secret, and CA-only Secret belong to the application and are deleted with the container. The operator-owned server Secret does not belong to the application and must remain:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application delete demo-tutorial --environment tutorial --group default \
  --preview --config "$RAD_CONFIG"
```

Check that the server Secret still has the UID recorded when you created it. If it has been replaced, stop and ask its current owner before deleting anything:

```bash
original_uid="$(cat "$TLS_DIR/server-secret.uid")"
current_uid="$(kubectl get secret "$SERVER_SECRET" -n "$NAMESPACE" \
  --context "$KUBE_CONTEXT" -o jsonpath='{.metadata.uid}')"
if [[ "$current_uid" != "$original_uid" ]]; then
  printf 'Server Secret identity changed; do not delete it.\n' >&2
  exit 1
fi
```

For the local certificate created by this tutorial, delete that server Secret when you no longer need it. Retain operator-provided certificate resources unless their owner authorizes removal:

```bash
kubectl delete secret "$SERVER_SECRET" -n "$NAMESPACE" --context "$KUBE_CONTEXT"
rm -- "$TLS_DIR/server-secret.uid" "$TLS_DIR/app.parameters.json" \
  "$TLS_DIR/password.txt" "$TLS_DIR/server.crt" "$TLS_DIR/server.key" \
  "$TLS_DIR/server.csr" "$TLS_DIR/server.ext" "$TLS_DIR/ca.crt" \
  "$TLS_DIR/ca.key" "$TLS_DIR/ca.srl"
rmdir -- "$TLS_DIR"
```

Delete only the files you created for this tutorial. Do not delete a shared namespace or an operator's certificate directory. File removal is not a guarantee of secure erasure on the underlying storage.

Once no application uses the tutorial Environment, remove that Environment and its dedicated Recipe Pack. Do not remove the installation's default Environment or default Recipe Pack:

```bash
rad environment delete tutorial --group default --preview --config "$RAD_CONFIG"
rad recipe-pack delete tutorial-postgresql-tls --group default --config "$RAD_CONFIG"
```

Only on the disposable cluster that you own, optionally uninstall Radius and remove all of its data. First verify the saved tutorial context:

```bash
printf 'Cluster context to uninstall: %s\n' "$KUBE_CONTEXT"
kubectl get namespace radius-system --context "$KUBE_CONTEXT"
rad uninstall kubernetes --purge --kubecontext "$KUBE_CONTEXT" --config "$RAD_CONFIG"
```

The isolated tool home also contains the copied kubeconfig, compiler, and type cache. Do not remove your original home or shared tool caches. When finished, close the dedicated tutorial subshell with `exit`; its `HOME` and `KUBECONFIG` changes do not affect the parent shell. Keep any retained tutorial files private.

## Next steps

You have installed Radius, deployed the Radius Demo application, and connected it to a PostgreSQL database and an authored Secret. Continue with the hands-on labs for deeper, real-world scenarios.

{{< button text="Next step: Explore the labs" page="getting-started/labs" >}}

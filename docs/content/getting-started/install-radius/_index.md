---
type: docs
title: "1. Install Radius"
linkTitle: "1. Install Radius"
description: "Install Radius on a Kubernetes cluster and initialize your first application"
weight: 100
---

> **Work in progress: do not publish or run this draft.** The sample checkpoint is synchronized. Approved public Recipe sources, a retained client image, and validation against that public artifact tuple are still pending.

In part one, you will install Radius on a disposable Kubernetes cluster that you own. Do not use a shared cluster, a production database, or an existing application Environment for this tutorial.

## Prerequisites

You need a **Kubernetes cluster** and `kubectl`. To install Radius, your user must have the cluster-admin role. Radius <a href="{{< ref "installation#supported-kubernetes-clusters" >}}">supports</a> <a href="https://azure.microsoft.com/en-us/products/kubernetes-service">AKS</a>, <a href="https://aws.amazon.com/eks/">EKS</a>, <a href="https://k3d.io/">k3d</a>, and <a href="https://kind.sigs.k8s.io/">kind</a> clusters. Use a disposable local cluster with k3d or kind for this guide.

The PostgreSQL certificate steps use **Bash on Linux, or Bash in WSL2 on Windows**, with **OpenSSL 1.1.1 or newer** and `jq`. The compiler preflight also uses `curl` and `sha256sum`. Native PowerShell does not include OpenSSL. On Windows, run certificate generation in your WSL2 Linux filesystem, not in a Windows-mounted repository or a synchronized folder; Linux permissions protect the private key files there. Run `rad` and `kubectl` against the same tutorial cluster from that shell.

Check the tools before continuing:

```bash
bash --version
openssl version
jq --version
curl --version
sha256sum --version
kubectl version --client
```

Confirm that `openssl version` reports OpenSSL 1.1.1 or a newer supported OpenSSL release. The certificate commands use its `-addext` and `-verify_hostname` options. An operator can instead supply a server certificate and matching private key issued by an existing certificate authority, provided the certificate covers the database Service's exact DNS name.

## Install the Radius CLI

{{< read file="/shared-content/installation/rad-cli/install-rad-cli.md" >}}

Record the installed CLI version:

```bash
rad version --cli
```

The CLI, control plane, registered Resource Types, and Recipe versions must match the tested combination specified for this tutorial. A CLI version alone is not a TLS compatibility check.

## Install Radius

Open a dedicated Bash subshell so the tutorial's temporary environment changes do not affect your normal shell:

```bash
bash --noprofile --norc
```

In that new shell, create a new directory for the Radius Demo application. Use a new local Radius configuration file so this tutorial does not change your usual Radius workspace or Environment. Keep this shell and directory for all three tutorial steps:

```bash
set -euo pipefail
set +x
umask 077
mkdir radius
cd radius
RAD_CONFIG="$PWD/rad.yaml"
```

Ensure your disposable cluster is set as your current context with `kubectl config current-context`. If the context needs updating, select an existing context with `kubectl config use-context <context-name>`. Do not change the context of a shared workstation without checking what it points to. Record the selected context so later `kubectl` commands continue to target that cluster:

```bash
KUBE_CONTEXT="$(kubectl config current-context)"
printf 'Tutorial cluster context: %s\n' "$KUBE_CONTEXT"
```

### Isolate the compiler and its type cache

Both compilation and deployment must use the same compiler and type cache. An older cached Radius extension can reject `tls` even when a fresh copy of the same `latest` reference supports it. A successful compile in a fresh cache does not prove that a later deployment using your normal cache will succeed.

Create an isolated Linux home directory for the tutorial's tools. Before changing `HOME`, copy only the selected disposable cluster context into its private kubeconfig. Flattening embeds certificate files and merges the existing `KUBECONFIG` inputs, so relative certificate paths and multi-file configurations do not silently break. The raw kubeconfig contains credentials: redirect it directly into the protected file, never print or commit it.

```bash
ORIGINAL_HOME="$HOME"
TUTORIAL_HOME="$(mktemp -d "$ORIGINAL_HOME/radius-tutorial-home.XXXXXXXX")"
mkdir -m 700 "$TUTORIAL_HOME/.kube"
kubectl config view --context "$KUBE_CONTEXT" --raw --flatten --minify -o json \
  > "$TUTORIAL_HOME/.kube/config"
chmod 600 "$TUTORIAL_HOME/.kube/config"
if ! jq -e '
  (.contexts | length) == 1 and
  all(.users[]; .user.exec == null and .user["auth-provider"] == null)
' "$TUTORIAL_HOME/.kube/config" > /dev/null; then
  printf 'Use a disposable local cluster context without an external authentication helper.\n' >&2
  exit 1
fi
RAD_BIN="$(type -P rad)"
export KUBECONFIG="$TUTORIAL_HOME/.kube/config"
export HOME="$TUTORIAL_HOME"
test "$(type -P rad)" = "$RAD_BIN"
kubectl get namespace default --context "$KUBE_CONTEXT"

rad bicep download --config "$RAD_CONFIG"
"$HOME/.rad/bin/bicep" --version
```

Keep the original `PATH`; the installed `rad` executable must remain available. The CLI installs its bundled Bicep compiler into this isolated home's `.rad/bin`, and both subsequent `rad deploy` commands and direct compiler checks use that home. This is a Linux/WSL procedure: changing `HOME` alone does not select the native Windows compiler cache.

The isolated home deliberately has no Docker or private-registry credentials. This tutorial uses public artifacts and a disposable local cluster, not a cloud authentication helper or a private registry. Do not copy unrelated credential stores into it or disable transport security to bypass an authentication error. Do not delete or modify your normal Bicep cache.

Install Radius with the `rad initialize` command, using the new local configuration:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad initialize --preview --config "$RAD_CONFIG"
```

Select `No` when asked to set up an application in the current directory. Initialization creates the initial `default` Environment and Recipe Pack on this new installation. Do not deploy an application into that Environment: the next section creates a separate tutorial Environment and selects its TLS Recipe Pack before any application resources are deployed.

Verify the pods are running:

```bash
kubectl get pods -n radius-system --context "$KUBE_CONTEXT"
rad version --config "$RAD_CONFIG"
```

You should see output similar to:

```
NAME                                  READY   STATUS    RESTARTS   AGE
applications-rp-xxxxxxxxxx-xxxxx      1/1     Running   0          1m
bicep-de-xxxxxxxxxx-xxxxx             1/1     Running   0          1m
contour-contour-xxxxxxxxxx-xxxxx      1/1     Running   0          1m
contour-envoy-xxxxxxxxxx-xxxxx        1/1     Running   0          1m
controller-xxxxxxxxxx-xxxxx           1/1     Running   0          1m
dashboard-xxxxxxxxxx-xxxxx            1/1     Running   0          1m
dynamic-rp-xxxxxxxxxx-xxxxx           1/1     Running   0          1m
ucp-xxxxxxxxxx-xxxxx                  1/1     Running   0          1m
```

For more details on installing Radius, see [How to Install Radius]({{< ref "/installation" >}}).

## Create an isolated tutorial Environment

Use the Environment name `tutorial` and the Kubernetes namespace `radius-tutorial`. These names are deliberately different: the namespace is a runtime setting, not a value to infer from the Environment name.

Before creating anything, check for an existing Environment with that name or namespace, an existing tutorial Recipe Pack, and an existing Kubernetes namespace. Stop on a collision or failed lookup. Do not reuse another application's resources or change a shared Environment's Recipe Pack.

```bash
ENVIRONMENT=tutorial
NAMESPACE=radius-tutorial
PACK_NAME=tutorial-postgresql-tls

environments="$(rad environment list --group default --preview \
  --config "$RAD_CONFIG" --output json)"
if ! jq -e --arg name "$ENVIRONMENT" --arg namespace "$NAMESPACE" '
  if type != "array" then error("Expected an Environment list")
  else all(.[];
    (.name | ascii_downcase) != ($name | ascii_downcase) and
    .properties.providers.kubernetes.namespace != $namespace)
  end
' <<< "$environments" > /dev/null; then
  printf 'Environment name or namespace is already assigned, or the list is invalid. Stop here.\n' >&2
  exit 1
fi

packs="$(rad recipe-pack list --group default --config "$RAD_CONFIG" --output json)"
if ! jq -e --arg name "$PACK_NAME" '
  if type != "array" then error("Expected a Recipe Pack list")
  else all(.[]; (.name | ascii_downcase) != ($name | ascii_downcase))
  end
' <<< "$packs" > /dev/null; then
  printf 'Tutorial Recipe Pack already exists, or the list is invalid. Stop here.\n' >&2
  exit 1
fi

existing_namespace="$(kubectl get namespace "$NAMESPACE" \
  --context "$KUBE_CONTEXT" --ignore-not-found -o name)"
if [[ -n "$existing_namespace" ]]; then
  printf 'Refusing to adopt existing namespace %s.\n' "$NAMESPACE" >&2
  exit 1
fi

kubectl create namespace "$NAMESPACE" --context "$KUBE_CONTEXT"
rad environment create "$ENVIRONMENT" --group default \
  --kubernetes-namespace "$NAMESPACE" --preview --config "$RAD_CONFIG"

rad environment show "$ENVIRONMENT" --group default --preview \
  --config "$RAD_CONFIG" --output json \
  | jq -e --arg namespace "$NAMESPACE" \
      '.properties.providers.kubernetes.namespace == $namespace'
```

The namespace is created explicitly; creating a Radius Environment does not by itself prove that the namespace exists. This Environment initially references the default Recipe Pack only to bootstrap pack deployment. Do not deploy the base application or PostgreSQL until the named TLS pack has been deployed, selected, and inspected below.

## Select the tutorial Recipe Pack

**Publication hold:** the approved public Recipe sources, retained client image, and compatible CLI/runtime/schema tuple are not yet available in this draft. Do not continue to application deployment or substitute `edge`, `latest`, an unpublished tag, or a Recipe digest-only reference.

The public `postgresql-tls-pack.bicep` helper selects the tested PostgreSQL, Container, and Secret Recipes. Recipe sources use raw registry paths and tags, without a `br:` prefix. The public tutorial must not enable plain HTTP or use the helper's isolated CI registry exception. The client image is supplied separately to the application by its approved retained digest.

<div class="td-max-width-on-larger-screens" style="margin-bottom: -2rem;"><a href="https://github.com/radius-project/samples/blob/{{< param version >}}/samples/demo/postgresql-tls-pack.bicep" target="_blank" rel="noopener">samples/demo/postgresql-tls-pack.bicep</a></div>

{{< rad file="/static/samples/demo/postgresql-tls-pack.bicep" embed=true >}}

[Download the Recipe Pack definition](/samples/demo/postgresql-tls-pack.bicep).

Compile the two TLS definitions before deployment using the compiler downloaded into the same tutorial home. Download them beside the `bicepconfig.json` written by initialization:

{{< edge >}}
```bash
curl -fsSL https://edge.docs.radapp.io/samples/demo/postgresql-tls-pack.bicep \
  -o postgresql-tls-pack.bicep
curl -fsSL https://edge.docs.radapp.io/samples/demo/app-postgresql.bicep \
  -o app-postgresql.bicep
```
{{< /edge >}}
{{< latest >}}
```bash
curl -fsSL https://docs.radapp.io/samples/demo/postgresql-tls-pack.bicep \
  -o postgresql-tls-pack.bicep
curl -fsSL https://docs.radapp.io/samples/demo/app-postgresql.bicep \
  -o app-postgresql.bicep
```
{{< /latest >}}

```bash
cat bicepconfig.json
"$HOME/.rad/bin/bicep" build postgresql-tls-pack.bicep --stdout > /dev/null
"$HOME/.rad/bin/bicep" build app-postgresql.bicep --stdout > /dev/null
find "$HOME/.bicep" -type f \( -name manifest -o -name types.tgz \) \
  -exec sha256sum {} \;
```

Compare the compiler version, configured Radius extension reference, and restored manifest and type-bundle hashes with the tested tuple. The compiler restores missing types automatically; there is no need to invent a refresh flag or clear a shared cache. If `tls` is rejected or any expected version differs, stop rather than suppressing the error. Keep using this same shell, `HOME`, `KUBECONFIG`, and `RAD_CONFIG` for deployment.

Once the approved public tuple is available, set `POSTGRESQL_RECIPE_SOURCE`, `CONTAINER_RECIPE_SOURCE`, and `SECRET_RECIPE_SOURCE` to its exact tagged Recipe references. These values are required inputs, not defaults. Set `IMAGE` to the tuple's retained client image digest for the later application deployment.

<!-- Publication gate: supply the approved public artifact tuple here.
Local candidate validation is not publication approval. Do not invent reference values. -->

Generate the pack parameter file from those public references:

```bash
: "${POSTGRESQL_RECIPE_SOURCE:?Set the approved PostgreSQL Recipe source from the tested public tuple.}"
: "${CONTAINER_RECIPE_SOURCE:?Set the tested Container Recipe source from the public tuple.}"
: "${SECRET_RECIPE_SOURCE:?Set the tested Secret Recipe source from the public tuple.}"
for source in "$POSTGRESQL_RECIPE_SOURCE" "$CONTAINER_RECIPE_SOURCE" "$SECRET_RECIPE_SOURCE"; do
  if [[ ! "$source" =~ ^ghcr\.io/[^@:[:space:]]+:[^/:@[:space:]]+$ ]]; then
    printf 'Public Recipe sources must be tagged ghcr.io references, without br:, URL schemes, or digests.\n' >&2
    exit 1
  fi
done

jq -n --arg pack "$PACK_NAME" \
  --arg postgresql "$POSTGRESQL_RECIPE_SOURCE" \
  --arg container "$CONTAINER_RECIPE_SOURCE" \
  --arg secret "$SECRET_RECIPE_SOURCE" '{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    contentVersion: "1.0.0.0",
    parameters: {
      packName: {value: $pack},
      postgresqlRecipeSource: {value: $postgresql},
      containerRecipeSource: {value: $container},
      secretRecipeSource: {value: $secret}
    }
  }' > pack.parameters.json
```

Deploy the pack before deploying the base application:

{{< rad-deploy path="samples/demo/postgresql-tls-pack.bicep" args=`--environment tutorial --group default --config "$RAD_CONFIG" --parameters '@pack.parameters.json'` >}}

After deploying the verified pack into the tutorial Environment, assign it only to that Environment and inspect its stored sources:

```bash
rad environment update "$ENVIRONMENT" --group default --preview \
  --recipe-packs "$PACK_NAME" --config "$RAD_CONFIG"
rad recipe-pack show "$PACK_NAME" --group default \
  --config "$RAD_CONFIG" --output json

pack_id="$(rad recipe-pack show "$PACK_NAME" --group default \
  --config "$RAD_CONFIG" --output json | jq -er '.id')"
rad environment show "$ENVIRONMENT" --group default --preview \
  --config "$RAD_CONFIG" --output json \
  | jq -e --arg namespace "$NAMESPACE" --arg pack "$pack_id" '
      .properties.providers.kubernetes.namespace == $namespace and
      .properties.recipePacks == [$pack]
    '
kubectl get namespace "$NAMESPACE" --context "$KUBE_CONTEXT"
```

Compare all three stored Recipe sources to the tested public sources, not just the pack's name. Check the registered `Radius.Data` schema for the PostgreSQL `tls` property and the actual Bicep extension used by your CLI. An unchanged API version, a recent CLI, or a mutable `latest` type reference does not prove compatibility. Schema support alone also does not prove that a Recipe configures server TLS.

Check the definition registered in the running Radius control plane, not just the compiler's cached types:

```bash
rad resource-type show Radius.Data/postgreSqlDatabases \
  --config "$RAD_CONFIG" --output json > postgresql-schema.json
jq -e '
  .APIVersions["2025-08-01-preview"].Schema.properties.tls |
  .type == "string" and (.enum | index("required") != null)
' postgresql-schema.json
jq -S '.APIVersions["2025-08-01-preview"].Schema' postgresql-schema.json \
  | sha256sum
```

The first check must return `true`. Record the schema hash with the compiler and Recipe sources. If the field is absent or `required` is unsupported, stop; installing a fresh compiler extension alone does not update the running control plane's registered schema.

Record the control-plane container images and resolved image IDs, rather than relying only on mutable image tags:

```bash
kubectl get pods -n radius-system --context "$KUBE_CONTEXT" -o json \
  | jq -r '.items[] | .metadata.name as $pod |
      .status.containerStatuses[]? |
      [$pod, .name, .image, .imageID] | @tsv'
```

## Next steps

In part two of this guide, you will deploy the Radius Demo sample application.

{{< button text="Next step: Deploy an application" page="getting-started/deploy-demo" >}}

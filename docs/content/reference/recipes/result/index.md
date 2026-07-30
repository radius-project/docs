---
type: docs
title: "Recipe result object"
linkTitle: "Recipe result"
description: "Learn how to use the result object to return values from a recipe"
weight: 200
---

A recipe returns data to Radius through a special output named `result`. After a recipe provisions its infrastructure, the `result` object carries the values, secrets, and resource IDs that Radius records on the resource that called the recipe. Radius surfaces those values to the resource and to any resources that connect to it, stores secrets securely, and tracks the returned resource IDs so it can manage their lifecycle. A recipe returns it from an `output result object` in Bicep or an `output "result"` in Terraform. For more information, visit the [recipe authoring how-to guide]({{< ref "/extensibility/recipes" >}}).

## Usage

{{< tabs Terraform Bicep >}}

{{< codetab >}}

{{< rad file="snippets/recipe.tf" embed=true lang="terraform" >}}

{{% alert title="💡 Terraform recipes" color="info" %}}
The Terraform `result` output must be marked `sensitive = true`. Because non-sensitive values and secrets are combined into a single object, Terraform requires the whole output to be marked sensitive.
{{% /alert %}}

{{< /codetab >}}

{{< codetab >}}

{{< rad file="snippets/recipe.bicep" embed=true >}}

{{< /codetab >}}

{{< /tabs >}}

## Properties

| Key | Type | Description |
|-----|------|-------------|
| [`values`](#values) | object | A map of non-sensitive key/value pairs to record on the resource. These become the resource's computed properties and are surfaced to connecting resources. |
| [`secrets`](#secrets) | object | A map of sensitive key/value pairs. Radius stores these securely and surfaces them to connecting resources without exposing them as plain values. |
| [`resources`](#resources) | array | A list of resource IDs that Radius should associate with the resource so it can manage their lifecycle. |

### values

`values` is a map of non-sensitive key/value pairs. Radius records each entry as a computed property on the resource that called the recipe and makes it available to any resource that connects to it—for example, a container reads them through connection environment variables.

| Type | Example |
|------|---------|
| object | `{ "host": "db.default.svc.cluster.local", "port": 5432, "database": "appdb" }` |

### secrets

`secrets` is a map of sensitive key/value pairs, such as passwords or connection strings. Radius stores these values securely and surfaces them to connecting resources without exposing them as plain values.

| Type | Example |
|------|---------|
| object | `{ "username": "postgres", "password": "***" }` |

### resources

`resources` is an array of fully qualified resource IDs. Radius associates each ID with the resource that called the recipe so it can manage the returned resources' lifecycle—for example, deleting them when the resource is deleted.

| Type | Example |
|------|---------|
| array | `["/planes/kubernetes/local/namespaces/default/providers/core/Service/redis"]` |

## How Radius uses the result

When a recipe finishes, Radius reads the `result` output and:

- Records the `values` as computed properties on the resource and passes them to any resource that connects to it (for example, as `CONNECTION_<NAME>_<KEY>` environment variables on a container).
- Stores the `secrets` securely and surfaces them to connecting resources without exposing them as plain values.
- Adds the resource IDs in `resources` to the resource's list of tracked output resources so they are managed—and cleaned up—alongside the resource.

Radius also records status metadata about the recipe (such as the template kind and path) on the resource automatically. This metadata is not set in the `result` object.

{{% alert title="⚠️ Unknown fields" color="warning" %}}
Radius rejects a `result` object that contains keys other than `values`, `secrets`, and `resources`. A recipe must return only these three properties.
{{% /alert %}}

## When is the result required?

Returning a `result` object is optional, but it is required in the following cases:

- **To populate the resource's properties.** When the resource type defines read-only properties that the recipe computes (such as `host`, `port`, or a connection string), those values must be returned under `values` so they appear on the resource and flow to connecting resources.
- **To return secrets.** Any sensitive value the consuming application needs—such as a password or connection string—must be returned under `secrets`.
- **To track resources Radius can't discover implicitly.** Radius automatically tracks ARM and UCP resources that a Bicep recipe creates. Other resources—most commonly Kubernetes resources—are not returned automatically, so their IDs must be listed under `resources` for Radius to manage their lifecycle.

When a recipe doesn't compute any properties or secrets and only creates resources that Radius tracks implicitly, the `result` output can be omitted entirely.
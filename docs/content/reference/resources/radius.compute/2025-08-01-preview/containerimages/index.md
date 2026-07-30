---
type: docs
title: "Radius.Compute/containerImages@2025-08-01-preview"
linkTitle: "ContainerImages"
---

{{< schemaExample >}}

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Required) The Radius Application ID. `myApplication.id` for example. |
| `build` | [object](#build) | (Required) Build configuration for the container image. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typical value should be `environment`. |
| `imageReference` | string | (Read Only) The full image reference produced by the recipe in the form `<registry>/<resource-name>:<tag>`. Reference this from `Radius.Compute/containers` to consume the built image. |
| `tag` | string | (Optional) Tag for the produced image. When unset, the recipe computes a content-addressable digest (`sha256-<hash>`) from the build inputs. For git sources, pin to a commit SHA or immutable tag (e.g. `?ref=<sha>`) so that the computed tag is genuinely content-addressable; with a moving ref like `?ref=main`, the computed tag does not change when the upstream branch advances. |

## Object Properties

### `build` {#build}

| Property | Type | Description |
|----------|------|-------------|
| `args` | object | (Optional) Map of `--build-arg` values passed to the build, e.g. `{ VERSION: 'v1.2.3' }`. Argument names must match `[A-Za-z_][A-Za-z0-9_]*`. Values must not contain shell metacharacters. |
| `dockerfile` | string | (Optional) Path to the Dockerfile relative to the build source. Defaults to `Dockerfile`. |
| `platforms` | string array | (Optional) Target platforms to build for (e.g. `["linux/amd64"]`, `["linux/amd64", "linux/arm64"]`). When omitted, defaults to `["linux/amd64", "linux/arm64"]`. Multi-platform builds use cross-compilation; the Dockerfile must use `FROM --platform=$BUILDPLATFORM` and `TARGETARCH`. |
| `source` | string | (Required) Source location for the build. Either a git URL of the form `git::https://...` (BuildKit clones the repo inside the cluster) or a local filesystem path to a directory containing the build context. For git URLs, the subdirectory is selected via the go-getter `//<subdir>` segment and the ref via the `?ref=<branch-or-sha>` query parameter, in that order. Example, `git::https://github.com/myorg/myapp.git//frontend?ref=v1.2.3`. |

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

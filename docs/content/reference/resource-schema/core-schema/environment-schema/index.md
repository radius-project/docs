---
type: docs
title: "Environment"
linkTitle: "Environment"
description: "Learn how to define an environment"
weight: 000
---

## Resource format

{{< rad file="snippets/environment.bicep" embed=true marker="//ENV" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `frontend`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| [compute](#compute) | y | Container runtime configuration. | [See below](#compute)

### compute

Details on what to run and how to run it are defined in the `container` property:

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of container runtime to use. Only option is `'kubernetes'` | `'kubernetes'`
| namespace | y | The Kubernetes namespace to render application resources into | `'default'`
| resourceId | n | The resource ID of the AKS cluster to render application resources into. Only required for Azure environments | `aksCluster.id`

## Further reading

- [Radius environments]({{< ref environments >}})

---
type: docs
title: "Reference: Available Radius metrics"
linkTitle: "Metrics"
weight: 850
description: "Learn what metrics are available for the Radius control plane"
categories: ["Reference"]
---

Radius currently records following custom metrics that provide insight into its health and operations:

- [Async operation metrics](#async-operation-metrics)
- [Recipe Engine metrics](#recipe-engine-metrics)

In addition, Radius uses otelhttp meter provider. Therefore all of the HTTP metrics documented at [otelhttp metrics](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/http/http-metrics.md) are also available.

## Async operation metrics

| Metrics Name | Description |
|--------------|-------------|
|`asyncoperation.operation`          | Total async operation count |
|`asyncoperation.queued.operation`   | Number of queued async operation |
|`asyncoperation.extended.operation` | Number of extended async operation that are extended |
|`asyncoperation.duration`           | Async operation duration in milliseconds |

## Recipe Engine metrics

| Metrics Name | Description |
|--------------|-------------|
| `recipe.operation.duration`       | Recipe engine operation duration in milliseconds |
| `recipe.download.duration`        | Recipe download duration in milliseconds |
| `recipe.tf.installation.duration` | Terraform installation duration in milliseconds |
| `recipe.tf.init.duration`         | Terraform initialization duration |

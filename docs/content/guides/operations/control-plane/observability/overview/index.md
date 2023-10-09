---
type: docs
title: "Overview: Observe Radius control plane"
linkTitle: "Overview"
weight: 100
description: "Learn how to observe and gain insights into the Radius control plane"
categories: "Overview"
tags: ["observability", "control plane"]
---

Radius provides observability into the control plane through the following:

## Logging

The Radius control plane produces logs that you can use to monitor and troubleshoot the control plane. This document describes how to collect and search logs, as well as the log schema.

### Log formats

The Radius control plane outputs structured logs to stdout, either plain-text or JSON-formatted. By default, services produce JSON formatted logs. 

> If you want to use a search engine such as Elastic Search or Azure Monitor to search logs, it is strongly recommended to use JSON-formatted logs which the log collector and the search engine can parse using the built-in JSON parser.

### Log collectors

#### Fluentd

If you run the control plane in a Kubernetes cluster, [Fluentd](https://www.fluentd.org/) is a popular container log collector. You can use Fluentd with a [JSON parser plugin](https://docs.fluentd.org/parser/json) to parse Radius JSON-formatted logs. This [how-to]({{< ref fluentd.md >}}) shows how to configure Fluentd in your cluster.

#### Azure Monitor

If you are using Azure Kubernetes Service, you can use the [built-in agent to collect logs with Azure Monitor](https://learn.microsoft.com/azure/aks/monitor-aks) without needing to install Fluentd.

### Search engines

### Elastic Search and Kibana

If you use [Fluentd](https://www.fluentd.org/), we recommend using Elastic Search and Kibana. This [how-to]({{< ref fluentd.md >}}) shows how to set up Elastic Search and Kibana in your Kubernetes cluster.

### Azure Monitor

If you are using the Azure Kubernetes Service, you can use [Azure Monitor for containers](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-overview) without installing any additional monitoring tools. Also read [How to enable Azure Monitor for containers](https://learn.microsoft.com/azure/azure-monitor/containers/container-insights-onboard)

### Log schema

Control plane logs contain the following fields:

| Field | Description       | Example |
|-------|-------------------|---------|
| `timestamp`  | [ISO8601](https://www.iso.org/iso-8601-date-and-time-format.html) timestamp | `2011-10-05T14:48:00.000Z` |
| `severity` | Log level. Available levels are info, warn, debug, and error. | `info` |
| `message`   | Log message | `proxying request target: http://de-api.radius-system:6443` |
| `name`   | Logging scope | `ucplogger.api` |
| `caller` | Service logging point | `planes/proxyplane.go:171`
| `version` | Control plane version | `0.18` |
| `serviceName` | Name of control plane service | `ucplogger` |
| `hostName` | Service host name | `ucp-77bc9b4cbb-nmjlz` |
| `resourceId` | The resourceId being affected, if applicable | `/apis/api.ucp.dev/v1alpha3/planes/deployments/local/resourcegroups/myrg/providers/Microsoft.Resources/deployments/rad-deploy-6c0d37b0-705e-454b-9167-877aa080e656` |
| `traceId` | [w3c traceId](https://www.w3.org/TR/trace-context/#trace-id). Used to uniquely identify a [distributed trace](https://www.w3.org/TR/trace-context/#dfn-distributed-traces) through a system.  | `d1ba9c7d2326ee1b44eb0b8177ef554f` |
| `spanId` | [w3c spanId](https://www.w3.org/TR/trace-context/#parent-id) The ID of this request as known by the caller. Also known as `parent-id` in some tracing systems.  | `ce52a91ed3c86c6d` |

#### Example

```json
{
    "severity": "info",
    "timestamp": "2023-03-03T00:03:55.355Z",
    "name": "ucplogger.api",
    "caller": "planes/proxyplane.go:171",
    "message": "proxying request target: http://de-api.radius-system:6443",
    "serviceName": "ucplogger",
    "version": "0.18",
    "hostName": "ucp-77bc9b4cbb-nmjlz",
    "resourceId": "/apis/api.ucp.dev/v1alpha3/planes/deployments/local/resourcegroups/myrg/providers/Microsoft.Resources/deployments/rad-deploy-6c0d37b0-705e-454b-9167-877aa080e656",
    "traceId": "2435428bbf8533c68b122b1ef31bb42f",
    "spanId": "30a88181fe683c00"
}
```

## Metrics

Radius emits metrics from the control-plane which can be used for troubleshooting and monitoring. 

### Grafana

[Grafana](https://grafana.com/) is an open source visualization and analytics tool that allows you to query, visualize, alert on, and explore your metrics. This guide will show you how to install Grafana and configure it to visualize the Radius control plane metrics from Prometheus.

#### Example dashboards

There are two example dashboards that you can import into Grafana to quickly get started visualizing your metrics and then customize them to meet your needs.

#### Control plane overview

The [radius-overview-dashboard.json](https://get.radapp.dev/tools/grafana/radius-overview-dashboard.json) template shows Radius and Deployment Engine statuses, including runtime, and server-side health:

<img src="radius-overview-1.png" alt="1st screenshot of the Radius Overview Dashboard" width=1200><br/>

<img src="radius-overview-2.png" alt="2nd screenshot of the Radius Overview Dashboard" width=1200><br/>

#### Resource provider overview

The [radius-resource-provider-dashboard.json](https://get.radapp.dev/tools/grafana/radius-resource-provider-dashboard.json) template shows Radius Resource Provider status, including runtime, server-side, and operations health:

<img src="radius-resource-provider-1.png" alt="1st screenshot of the Radius Resource Provider Dashboard" width=1200><br/>

<img src="radius-resource-provider-2.png" alt="2nd screenshot of the Radius Resource Provider Dashboard" width=1200><br/>

### Prometheus

[Prometheus](https://prometheus.io/) collects and stores metrics as time series data. This guide will show you how to collect Radius control plane metrics to then be visualized and queried.

### Available metrics

Refer to the [metrics reference]({{< ref "/reference/metrics" >}}) for a list of available metrics.

## Tracing

[Jaeger](https://www.jaegertracing.io/) is an open source distributed tracing system. It helps gather timing data needed to troubleshoot latency problems in microservice architectures. It manages both the collection and lookup of this data.

[Zipkin](https://zipkin.io/) is an open source distributed tracing system. It helps gather timing data needed to troubleshoot latency problems in microservice architectures. It manages both the collection and lookup of this data.

### Further Reading

- [How-to: Set up Fluentd, Elastic search, and Kibana]({{< ref fluentd.md >}})
- [How-to: Set up Azure Monitor for containers](https://learn.microsoft.com/azure/aks/monitor-aks)
- [How-To: Set up Prometheus for metrics]({{< ref prometheus >}})
- [How-To: Set up Grafana for metrics]({{< ref grafana >}})
- [How-To: Set up Jaeger for distributed tracing]({{< ref jaeger >}})
- [How-To: Set up Zipkin for distributed tracing]({{< ref zipkin >}})

---
type: docs
title: "Control plane logs"
linkTitle: "Logs"
weight: 100
description: "Understand Project Radius control plane logs"
---

Radius produces structured logs to stdout, either in plain-text or JSON-formatted. By default, all Radius services produce Json formatted logs. 

{{% alert title="Note" color="primary" %}}
If you want to use a search engine such as Elastic Search or Azure Monitor to search the logs, it is strongly recommended to use JSON-formatted logs which the log collector and search engine can parse using the built-in JSON parser.
{{% /alert %}}

## Log schema

Radius produces logs based on the following schema:

| Field | Description       | Example |
|-------|-------------------|---------|
| timestamp  | ISO8601 Timestamp | `2011-10-05T14:48:00.000Z` |
| severity | Log Level (info/warn/debug/error) | `info` |
| message   | Log Message | `hello radius!` |
| name   | Logging scope | `ucplogger.api` |
| version | radius control plane version | `1.9.0` |
| serviceName | name of radius control plane service | `ucp` |
| hostName | radius service host name | `ucp-77bc9b4cbb-nmjlz` |
| resourceId | radius resourceId | `/apis/api.ucp.dev/v1alpha3/planes/deployments/local/resourcegroups/nsdemo2/providers/Microsoft.Resources/deployments/rad-deploy-6c0d37b0-705e-454b-9167-877aa080e656` |
| caller | radius service logging point | `planes/proxyplane.go:171`
| traceId | w3c traceId | `d1ba9c7d2326ee1b44eb0b8177ef554f` |
| spanId | w3c spanId | `ce52a91ed3c86c6d` |

* JSON-formatted log examples

```json
{
    "severity": "info",
    "timestamp": "2023-03-03T00:03:55.355Z",
    "name": "ucplogger.api",
    "caller": "planes/proxyplane.go:171",
    "message": "proxying request target: http://de-api.radius-system:6443",
    "serviceName": "ucplogger",
    "version": "0.17",
    "hostName": "ucp-77bc9b4cbb-nmjlz",
    "resourceId": "/apis/api.ucp.dev/v1alpha3/planes/deployments/local/resourcegroups/nsdemo2/providers/Microsoft.Resources/deployments/rad-deploy-6c0d37b0-705e-454b-9167-877aa080e656",
    "traceId": "2435428bbf8533c68b122b1ef31bb42f",
    "spanId": "30a88181fe683c00"
}
```

## Log formats

Radius supports either plain-text or JSON-formatted logs (default).


## Log collectors

If you run Radius in a Kubernetes cluster, [Fluentd](https://www.fluentd.org/) is a popular container log collector. You can use Fluentd with a [JSON parser plugin](https://docs.fluentd.org/parser/json) to parse Radius JSON-formatted logs. This [how-to]({{< ref fluentd.md >}}) shows how to configure Fluentd in your cluster.

If you are using Azure Kubernetes Service, you can use the built-in agent to collect logs with Azure Monitor without needing to install Fluentd.

## Search engines

If you use [Fluentd](https://www.fluentd.org/), we recommend using Elastic Search and Kibana. This [how-to]({{< ref fluentd.md >}}) shows how to set up Elastic Search and Kibana in your Kubernetes cluster.

If you are using the Azure Kubernetes Service, you can use [Azure Monitor for containers](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-overview) without installing any additional monitoring tools. Also read [How to enable Azure Monitor for containers](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-onboard)

## References

- [How-to: Set up Fleuntd, Elastic search, and Kibana]({{< ref fluentd.md >}})
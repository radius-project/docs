---
type: docs
title: "Configure Radius to send distributed tracing data"
linkTitle: "Configure tracing"
weight: 100
description: "Configure Radius to send distributed tracing data"
---

It is recommended to run Radius with tracing enabled for any production
scenario.  You can configure Radius to send tracing and telemetry data
to many observability tools based on your environment, whether it is running in
the cloud or on-premises.

## Configuration

The `tracerProvider` section under the `radius-dev.yaml` spec contains the following properties:

```yml
# Tracing configuration
tracerProvider:
  serviceName: "core-rp"
  zipkin:
    url: "http://localhost:9411/api/v2/spans"
```

The following table lists the properties for tracing:

| Property     | Type   | Description |
|--------------|--------|-------------|
| `zipkin` | section | Identifies we are using Zipkin as our tracing tool.
| `url` | string | Sets the Zipkin server address. 
| `serviceName` | string | Is the serviceName used to identify the service which is generating traces.


Not having a tracerProvider section disables tracing.


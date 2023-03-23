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

To enable Radius tracing, use 

```
   rad install -set  global.tracerProvider.zipkin.url=zipkin_endpoint_url

   For example, 
   rad install -set  global.tracerProvider.zipkin.url=http://zipkin.default.svc.cluster.local:9411/api/v2/spans
```



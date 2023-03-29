---
type: docs
title: "How to: Configure Radius to send distributed tracing data"
linkTitle: "Configure tracing"
weight: 100
description: "Configure Radius to send distributed tracing data"
---

It is recommended to run Radius with tracing enabled for any production
scenario.  You can configure Radius to send tracing and telemetry data
to many observability tools based on your environment, regardless of whether it is running in
the cloud or on-premises.

## Configuration

To enable Radius tracing, use `rad install kuberenetes set`
If needed, use `rad init` to set up a environment once `rad install` completes.

```
rad install kubernetes --set  global.zipkin.url=zipkin_endpoint_url
```
where `zipkin_endpoint_url` is the Zipkin collector endpoint of the installed instance of Jaeger

For example, 
```
rad install kubernetes --set  global.zipkin.url=http://jaeger-collector.radius-monitoring.svc.cluster.local:9411/api/v2/spans
```

That's it! Your Radius control plane is now configured for use with Jaeger.


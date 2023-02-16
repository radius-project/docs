---
type: docs
title: "How-To: Set up Jaeger for distributed tracing"
linkTitle: "Jaeger"
weight: 3000
description: "Set up Jaeger for distributed tracing"
type: docs
---

Jaeger is compatible with Zipkin. Therefore, the Zipkin protocol can be used to communication with Jaeger.

## Configure self hosted mode

### Setup

The simplest way to start Jaeger is to use the pre-built all-in-one Jaeger image published to DockerHub:

```bash
docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -e COLLECTOR_OTLP_ENABLED=true \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 4317:4317 \
  -p 4318:4318 \
  -p 14250:14250 \
  -p 14268:14268 \
  -p 14269:14269 \
  -p 9411:9411 \
  jaegertracing/all-in-one:1.42
```


Next, run rad init. For self hosted mode, on running `rad init`, `tracerProvider` section in `radius-dev.yaml` will be used to set up tracing.
This section, by default, looks like:

* radius-dev.yaml

```yaml
# Tracing configuration
tracerProvider:
  serviceName: "rp"
  zipkin:
    url: "http://localhost:9411/api/v2/spans"

### Viewing Traces
To view traces, in your browser go to http://localhost:16686 to see the Jaeger UI.

![jaeger](/images/jaeger_ui.png)

## References
- [Jaeger Getting Started](https://www.jaegertracing.io/docs/1.21/getting-started/#all-in-one)

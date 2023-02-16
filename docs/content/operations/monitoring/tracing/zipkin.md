---
type: docs
title: "How-To: Set up Zipkin for distributed tracing"
linkTitle: "Zipkin"
weight: 4000
description: "Set up Zipkin for distributed tracing"
type: docs
---

## Configure self hosted mode

For self hosted mode, on running `rad init`, `tracerProvider` section in `radius-dev.yaml` will be used to set up tracing.
This section, by default, looks like:

* radius-dev.yaml

```yaml
# Tracing configuration
tracerProvider:
  serviceName: "rp"
  zipkin:
    url: "http://localhost:9411/api/v2/spans"
```

2. The [openzipkin/zipkin](https://hub.docker.com/r/openzipkin/zipkin/) docker container can be launched with the following code.

Launch Zipkin using Docker:

```bash
docker run -d -p 9411:9411 openzipkin/zipkin
```

### Viewing Traces
To view traces, in your browser go to http://localhost:9411 and you will see the Zipkin UI.

### Viewing Tracing Data

To view traces, make sure  Zipkin container in running.
In your browser, go to `http://localhost:9411` and you will see the Zipkin UI.

## References
- [Zipkin for distributed tracing](https://zipkin.io/)

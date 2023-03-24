---
type: docs
title: "How-To: Set up Jaeger for distributed tracing"
linkTitle: "Jaeger"
weight: 3000
description: "Set up Jaeger for distributed tracing"
type: docs
---

Radius supports the Zipkin protocol. Since Jaeger is compatible with Zipkin, the Zipkin protocol can be used to communication with Jaeger.

### Setup

The simplest way to start Jaeger is to use the pre-built all-in-one Jaeger image published to DockerHub:

```bash
docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -p 16686:16686 \
  -p 9411:9411 \
  jaegertracing/all-in-one:1.22
```


### Viewing Traces
To view traces, in your browser go to http://localhost:16686 to see the Jaeger UI.

## Configure Kubernetes
The following steps shows you how to configure Radius control plane to send distributed tracing data to Jaeger running as a container in your Kubernetes cluster, how to view them.

### Setup Jaeger

1. Create namespace radius-monitoring
```
kubectl create namespace radius-monitoring
```

2. Create the following YAML file to install Jaeger, file name is `jaeger-allinall.yaml`
By default, the allInOne Jaeger image uses memory as the backend storage and it is not recommended to use this in a production environment.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jaeger
  namespace: radius-monitoring
  labels:
    app: jaeger
spec:
  selector:
    matchLabels:
      app: jaeger
  template:
    metadata:
      labels:
        app: jaeger
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "14269"
    spec:
      containers:
        - name: jaeger
          image: "docker.io/jaegertracing/all-in-one:1.42"
          env:
            - name: BADGER_EPHEMERAL
              value: "false"
            - name: SPAN_STORAGE_TYPE
              value: "badger"
            - name: BADGER_DIRECTORY_VALUE
              value: "/badger/data"
            - name: BADGER_DIRECTORY_KEY
              value: "/badger/key"
            - name: COLLECTOR_ZIPKIN_HOST_PORT
              value: ":9411"
            - name: MEMORY_MAX_TRACES
              value: "50000"
            - name: QUERY_BASE_PATH
              value: /jaeger
          livenessProbe:
            httpGet:
              path: /
              port: 14269
          readinessProbe:
            httpGet:
              path: /
              port: 14269
          volumeMounts:
            - name: data
              mountPath: /badger
          resources:
            requests:
              cpu: 10m
      volumes:
        - name: data
          emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: tracing
  namespace: radius-monitoring
  labels:
    app: jaeger
spec:
  type: ClusterIP
  ports:
    - name: http-query
      port: 16686
      protocol: TCP
      targetPort: 16686
    # Note: Change port name if you add '--query.grpc.tls.enabled=true'
    - name: grpc-query
      port: 16685
      protocol: TCP
      targetPort: 16685
  selector:
    app: jaeger
---
# Jaeger implements the Zipkin API. To support swapping out the tracing backend, we use a Service named Zipkin.
apiVersion: v1
kind: Service
metadata:
  labels:
    name: zipkin
  name: zipkin
  namespace: radius-monitoring
spec:
  ports:
    - port: 9411
      targetPort: 9411
      name: http-query
  selector:
    app: jaeger
---
apiVersion: v1
kind: Service
metadata:
  name: jaeger-collector
  namespace: radius-monitoring
  labels:
    app: jaeger
spec:
  type: ClusterIP
  ports:
  - name: jaeger-collector-http
    port: 14268
    targetPort: 14268
    protocol: TCP
  - name: jaeger-collector-grpc
    port: 14250
    targetPort: 14250
    protocol: TCP
  - port: 9411
    targetPort: 9411
    name: http-zipkin
  selector:
    app: jaeger
```

3. Install Jaeger
```
kubectl apply -f jaeger-allinall.yaml
```

4. Wait for Jaeger to be up and running
```
kubectl wait deploy --selector app=jaeger --for=condition=available -n radius-monitoring
``

### Configure Radius

Install radius with tracing enabled by following below steps.  If needed, use `rad init` to set up a environment once rad install completes. 

```
rad install kubernetes --set  global.tracerProvider.zipkin.url=zipkin_endpoint_url
```
where zipkin_endpoint_url is the zipkin collector endpoint of installed jaeger

For example, 
```
rad install kubernetes --set  global.tracerProvider.zipkin.url=http://jaeger-collector.radius-monitoring.svc.cluster.local:9411/api/v2/spans
```

That's it! Your Radius control plane is now configured for use with Jaeger.

### Viewing Tracing Data

To view traces, connect to the Jaeger Service and open the UI:

```bash
kubectl port-forward svc/tracing 16686 -n radius-monitoring 
```

In your browser, go to `http://localhost:16686` and you will see the Jaeger UI.

![jaeger](/images/jaeger_ui.png)

## References
- [Jaeger Getting Started](https://www.jaegertracing.io/docs/1.21/getting-started/#all-in-one)
---
type: docs
title: "How-To: Collect metrics with Prometheus"
linkTitle: "Prometheus"
weight: 2000
description: "Use Prometheus to collect time-series data from the Radius control plane"
categories: "How-To"
tags: ["metrics", "observability"]
---

[Prometheus](https://prometheus.io/) collects and stores metrics as time series data. This guide will show you how to collect Radius control plane metrics to then be visualized and queried.

## Install Prometheus on Kubernetes

1. Make sure you have the following pre-requisites:

   - [Supported Kubernetes cluster]({{< ref supported-clusters >}})
   - [kubectl](https://kubernetes.io/docs/tasks/tools/)
   - [Helm 3](https://helm.sh/)
   - [Radius control plane installed]({{< ref kubernetes-install >}})

1. Create a namespace that can be used to deploy the Grafana and Prometheus monitoring tools:

   ```bash
   kubectl create namespace radius-monitoring
   ```

2. Install Prometheus into your monitoring namespace:

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   helm install radius-prom prometheus-community/prometheus -n radius-monitoring
   ```

   If you are Minikube user or want to disable persistent volume for development purposes, you can disable it by using the following command.

   ```bash
   helm install radius-prom prometheus-community/prometheus -n radius-monitoring --set alertmanager.persistentVolume.enable=false --set pushgateway.persistentVolume.enabled=false --set server.persistentVolume.enabled=false
   ```

3. Validate your Prometheus installation:

   ```bash
   kubectl get pods -n radius-monitoring
   ```

   You should see something similar to the following:

   ```
   NAME                                                  READY   STATUS    RESTARTS   AGE
   radius-prom-kube-state-metrics-9849d6cc6-t94p8        1/1     Running   0          4m58s
   radius-prom-prometheus-alertmanager-749cc46f6-9b5t8   2/2     Running   0          4m58s
   radius-prom-prometheus-node-exporter-5jh8p            1/1     Running   0          4m58s
   radius-prom-prometheus-node-exporter-88gbg            1/1     Running   0          4m58s
   radius-prom-prometheus-node-exporter-bjp9f            1/1     Running   0          4m58s
   radius-prom-prometheus-pushgateway-688665d597-h4xx2   1/1     Running   0          4m58s
   radius-prom-prometheus-server-694fd8d7c-q5d59         2/2     Running   0          4m58s
   ```

1. Done! Prometheus is now installed and ready to collect metrics from the Radius control plane.

## Next step: Add a Grafana dashboard

Now that you have Prometheus installed, you can visualize the metrics using Grafana. Follow the [Grafana installation guide]({{< ref grafana >}}) to get up and running with a Grafana dashboard.

{{< button page="grafana" text="Next: Add a Grafana dashboard" >}}

## Further reading

* [Prometheus Installation](https://github.com/prometheus-community/helm-charts)
* [Prometheus Query Language](https://prometheus.io/docs/prometheus/latest/querying/basics/)
---
type: docs
title: "How-To: Observe metrics with Grafana"
linkTitle: "Grafana dashboards"
weight: 5000
description: "How to view Radius metrics in Grafana dashboards."
---

## Available dashboards

{{< tabs "Core RP & Link RP" "Deployment Engine" "UCP" >}}

{{% codetab %}}
The `grafana-system-services-dashboard.json` template shows Radius Core RP and Link RP statuses, including runtime, server-side, and async operation health:

<img src="/corerp-linkrp-grafana-dashboard.png" alt="Screenshot of the Core RP and Link RP dashboard" width=1200>
{{% /codetab %}}

{{% codetab %}}
The `grafana-sidecar-dashboard.json` template shows Radius Deployment Engine status, including runtime and server-side health:

<img src="/images/grafana-sidecar-dashboard.png" alt="Screenshot of the sidecar dashboard" width=1200>
{{% /codetab %}}

{{% codetab %}}
Upcoming Feature...

{{< /tabs >}}

## Pre-requisites

- [Setup Prometheus]({{<ref prometheus.md>}})

## Setup on Kubernetes

### Install Grafana

1. Add the Grafana Helm repo:

   ```bash
   helm repo add grafana https://grafana.github.io/helm-charts
   helm repo update
   ```

1. Install the chart:

   ```bash
   helm install grafana grafana/grafana -n radius-monitoring
   ```

   {{% alert title="Note" color="primary" %}}
   If you are Minikube user or want to disable persistent volume for development purpose, you can disable it by using the following command instead:

   ```bash
   helm install grafana grafana/grafana -n radius-monitoring --set persistence.enabled=false
   ```
   {{% /alert %}}


1. Retrieve the admin password for Grafana login:

   ```bash
   kubectl get secret --namespace radius-monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
   ```

   You will get a password similar to `cj3m0OfBNx8SLzUlTx91dEECgzRlYJb60D2evof1%`. Remove the `%` character from the password to get `cj3m0OfBNx8SLzUlTx91dEECgzRlYJb60D2evof1` as the admin password.

1. Validation Grafana is running in your cluster:

   ```bash
   kubectl get pods -n dapr-monitoring

   NAME                                                  READY   STATUS       RESTARTS   AGE
   radius-prom-kube-state-metrics-9849d6cc6-t94p8        1/1     Running      0          4m58s
   radius-prom-prometheus-alertmanager-749cc46f6-9b5t8   2/2     Running      0          4m58s
   radius-prom-prometheus-node-exporter-5jh8p            1/1     Running      0          4m58s
   radius-prom-prometheus-node-exporter-88gbg            1/1     Running      0          4m58s
   radius-prom-prometheus-node-exporter-bjp9f            1/1     Running      0          4m58s
   radius-prom-prometheus-pushgateway-688665d597-h4xx2   1/1     Running      0          4m58s
   radius-prom-prometheus-server-694fd8d7c-q5d59         2/2     Running      0          4m58s
   grafana-c49889cff-x56vj                               1/1     Running      0          5m10s
   ```

### Configure Prometheus as data source
First you need to connect Prometheus as a data source to Grafana.

1. Port-forward to svc/grafana:

   ```bash
   kubectl port-forward svc/grafana 8080:80 -n dapr-monitoring

   Forwarding from 127.0.0.1:8080 -> 3000
   Forwarding from [::1]:8080 -> 3000
   Handling connection for 8080
   Handling connection for 8080
   ```

1. Open a browser to `http://localhost:8080`

1. Login to Grafana
   - Username = `admin`
   - Password = Password from above

1. Select `Configuration` and `Data Sources`

1. Add Prometheus as a data source.

1. Get your Prometheus HTTP URL

   The Prometheus HTTP URL follows the format `http://<prometheus service endpoint>.<namespace>`

   Start by getting the Prometheus server endpoint by running the following command:

   ```bash
   kubectl get svc -n radius-monitoring

   NAME                                     TYPE        CLUSTER-IP        EXTERNAL-IP   PORT(S)             AGE
   radius-prom-kube-state-metrics           ClusterIP   10.0.174.177      <none>        8080/TCP            7d9h
   radius-prom-prometheus-alertmanager      ClusterIP   10.0.255.199      <none>        80/TCP              7d9h
   radius-prom-prometheus-node-exporter     ClusterIP   None              <none>        9100/TCP            7d9h
   radius-prom-prometheus-pushgateway       ClusterIP   10.0.190.59       <none>        9091/TCP            7d9h
   radius-prom-prometheus-server            ClusterIP   10.0.172.191      <none>        80/TCP              7d9h
   grafana                                  ClusterIP   10.0.15.229       <none>        80/TCP              5d5h

   ```

      In this guide the server name is `radius-prom-prometheus-server` and the namespace is `radius-monitoring`, so the HTTP URL will be `http://radius-prom-prometheus-server.radius-monitoring`.

1. Fill in the following settings:

   - Name: `Radius`
   - HTTP URL: `http://radius-prom-prometheus-server.radius-monitoring`
   - Default: On

1. Click `Save & Test` button to verify that the connection succeeded.

## Import dashboards in Grafana

1. In the upper left corner of the Grafana home screen, click the "+" option, then "Import".

   You can now import [Grafana dashboard templates](https://github.com/dapr/dapr/tree/master/grafana) from [release assets](https://github.com/dapr/dapr/releases) for your Radius version.

1. Find the dashboard that you imported and enjoy.

## References

* [Prometheus Installation](https://github.com/prometheus-community/helm-charts)
* [Prometheus on Kubernetes](https://github.com/coreos/kube-prometheus)
* [Prometheus Query Language](https://prometheus.io/docs/prometheus/latest/querying/basics/)
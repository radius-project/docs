---
type: docs
title: "How-To: Set up Fluentd, Elastic search and Kibana in Kubernetes"
linkTitle: "Fluentd"
weight: 2000
description: "How to install Fluentd, Elastic Search, and Kibana to search control plane logs in Kubernetes"
categories: "How-To"
tags: ["logs","observability"]
---

## Prerequisites

- [Setup a supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm 3](https://helm.sh/)

## Install Elastic search and Kibana

1. Create a Kubernetes namespace for monitoring tools

    ```bash
    kubectl create namespace radius-monitoring
    ```

1. Add the helm repo for Elastic Search

    ```bash
    helm repo add elastic https://helm.elastic.co
    helm repo update
    ```

1. Install Elastic Search using Helm

    _By default, the chart creates three replicas which must be on different nodes. If your cluster has fewer than 3 nodes, specify a smaller number of replicas with the `--set replicas=1` flag:_

    ```bash
    helm install elasticsearch elastic/elasticsearch --version 7.17.3 -n radius-monitoring --set replicas=1
    ```

    _If you are using minikube or simply want to disable persistent volumes for development purposes, you can do so with `--set persistence.enabled=false`:_

    ```bash
    helm install elasticsearch elastic/elasticsearch --version 7.17.3 -n radius-monitoring --set persistence.enabled=false,replicas=1
    ```

1. Install Kibana

    ```bash
    helm install kibana elastic/kibana --version 7.17.3 -n radius-monitoring
    ```

1. Ensure that Elastic Search and Kibana are running in your Kubernetes cluster

    ```bash
    kubectl get pods -n radius-monitoring
    ```

    You should see:

    ```
    NAME                            READY   STATUS    RESTARTS   AGE
    elasticsearch-master-0          1/1     Running   0          6m58s
    kibana-kibana-95bc54b89-zqdrk   1/1     Running   0          4m21s
    ```

## Install Fluentd

1. Install config map and Fluentd as a daemonset

    Download these config files:
    - [fluentd-config-map.yaml](fluentd-config-map.yaml)
    - [fluentd-radius-with-rbac.yaml](fluentd-radius-with-rbac.yaml)

    _Note: If you already have Fluentd running in your cluster, enable the nested json parser so that it can parse JSON-formatted logs from radius._

    Apply the configurations to your cluster:

    ```bash
    kubectl apply -f ./fluentd-config-map.yaml
    kubectl apply -f ./fluentd-radius-with-rbac.yaml
    ```

1. Ensure that Fluentd is running as a daemonset. The number of Fluentd instances should be the same as the number of cluster nodes. In the example below, there is only one node in the cluster:

    ```bash
    kubectl get pods -n kube-system -w
    ```

    You should see:

    ```
    NAME                          READY   STATUS    RESTARTS   AGE
    coredns-6955765f44-cxjxk      1/1     Running   0          4m41s
    coredns-6955765f44-jlskv      1/1     Running   0          4m41s
    etcd-m01                      1/1     Running   0          4m48s
    fluentd-sdrld                 1/1     Running   0          14s
    ```

## Install Radius control plane 

Visit the [Kubernetes docs]({{< ref "guides/operations/kubernetes" >}}) to learn how to install the Radius control plane. By default, Radius has JSON logging enabled.

For Kubernetes, you can install with the rad CLI:

```bash
rad install kubernetes
```

## Search logs

Once the Radius control plane is installed, you can search the logs using Kibana.

_Note: There is a small delay for Elastic Search to index the logs that Fluentd sends. You may need to wait a minute and refresh to see your logs._

1. Port-forward from localhost to `svc/kibana-kibana`

    ```bash
    kubectl port-forward svc/kibana-kibana 5601 -n radius-monitoring
    ```
    
    You should see:
   
    ```
    Forwarding from 127.0.0.1:5601 -> 5601
    Forwarding from [::1]:5601 -> 5601
    Handling connection for 5601
    Handling connection for 5601
    ```

1. Browse to `http://localhost:5601`

1. Expand the drop-down menu and click **Management → Stack Management**

    ![Stack Management item under Kibana Management menu options](kibana-1.png)

1. On the Stack Management page, select **Data → Index Management** and wait until `radius-*` is indexed.

    ![Index Management view on Kibana Stack Management page](kibana-2.png)

1. Once `radius-*` is indexed, click on **Kibana → Index Patterns** and then the **Create index pattern** button.

    ![Kibana create index pattern button](kibana-3.png)

1. Define a new index pattern by typing `radius*` into the **Index Pattern name** field, then click the **Next step** button to continue.

    ![Kibana define an index pattern page](kibana-4.png)

1. Configure the primary time field to use with the new index pattern by selecting the `@timestamp` option from the **Time field** drop-down. Click the **Create index pattern** button to complete creation of the index pattern.

    ![Kibana configure settings page for creating an index pattern](kibana-5.png)

1. The newly created index pattern should be shown. Confirm that the fields of interest such as `scope`, `type`, `app_id`, `level`, etc. are being indexed by using the search box in the **Fields** tab.

    _Note: If you cannot find the indexed field, please wait. The time it takes to search across all indexed fields depends on the volume of data and size of the resource that the elastic search is running on._

    ![View of created Kibana index pattern](kibana-6.png)

1. To explore the indexed data, expand the drop-down menu and click **Analytics → Discover**.

    ![Discover item under Kibana Analytics menu options](kibana-7.png)

1. In the search box, type in a query string such as `scope:*` and click the **Refresh** button to view the results.

    _Note: This can take a long time. The time it takes to return all results depends on the volume of data and size of the resource that the elastic search is running on._

    ![Using the search box in the Kibana Analytics Discover page](kibana-8.png)

## References

* [Fluentd for Kubernetes](https://docs.fluentd.org/v/0.12/articles/kubernetes-fluentd)
* [Elastic search helm chart](https://github.com/elastic/helm-charts/tree/master/elasticsearch)
* [Kibana helm chart](https://github.com/elastic/helm-charts/tree/master/kibana)
* [Kibana Query Language](https://www.elastic.co/guide/en/kibana/current/kuery-query.html)

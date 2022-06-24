---
type: docs
title: "Deploy eShop application to Radius environment"
linkTitle: "Deploy application"
slug: "deploy-app"
description: "Learn how to deploy thr eShop application to a Radius environment"
weight: 400
---

## Download eShop templates

Download the templates from the previous [infrastructure]({{< ref 2-infrastructure >}}) and [services]({{< ref 3-services >}}) steps.

### Setup `rad.yaml` file

A rad.yaml file describes how to deploy an application with the [`rad app deploy`]({< ref rad_appliaction_deploy >}) command. Copy and paste the following contents into a file named `rad.yaml`:

```yaml
name: store
stages:
- name: infra
  bicep:
    template: infra.bicep
  profiles:
    azure:
      bicep:
        template: infra.azure.bicep
- name: app
  bicep:
    template: app.bicep
  profiles:
    azure:
      bicep:
        template: app.azure.bicep
```

## Initialize environment

Visit the [getting started guide]({{< ref getting-started >}}) to deploy or connect to a Radius environment running the latest release.

### Get cluster IP

A Gateway controller is configured for you by default when you initialize an environment for both Kubernetes and Azure.

Radius gateways are still in development, and will get more features in upcoming releases. Until they are updated, manually retrieve your cluster IP address to pass into the application:

{{< tabs Azure Kubernetes >}}
{{% codetab %}}

1. Navigate to the resource group that was initialized for your environment.
1. Select the Kubernetes Service cluster and navigate to the "Services and ingresses" blade.
1. Note the IP address of the External IP of your LoadBalancer service.
{{% /codetab %}}
{{% codetab %}}
1. Ensure your cluster is set as the default cluster in your kubectl config, and Radius is initialized on it.
1. Run `kubectl get svc -A` and note the EXTERNAL-IP value of your load balancer.
{{% /codetab %}}
{{% /tabs %}}

## Deploy application

Using the [`rad app deploy`]({{< ref rad_application_deploy >}}) command, deploy the eShop application to your environment:

{{< tabs Containerized Azure >}}
{{% codetab %}}
```sh
$ rad app deploy -p adminPassword=CHOOSE-A-PASSWORD -p CLUSTER_IP=ip-address-you-retrieved
```
{{% /codetab %}}
{{% codetab %}}
```sh
$ rad app deploy --profile azure -p adminPassword=CHOOSE-A-PASSWORD -p CLUSTER_IP=ip-address-you-retrieved
```
{{% /codetab %}}
{{% /tabs %}}

{{% alert title="Note" color="info" %}}
Azure Redis cache can take ~20-30 minutes to deploy. You can monitor your deployment process in the `Deployments` blade of your environment's resource group.
{{% /alert %}}

## Verify app resources

Verify the eShop resources are deployed:

```sh
rad resource list -a eshop
```

## Visit eShop

Now that eShop is deployed, you can visit the eShop application in your browser at `https://CLUSTER-IP.nip.io`:

<img src="eshop.png" alt="Screenshot of the eShop application" width=800 >

Login and try buying an item!

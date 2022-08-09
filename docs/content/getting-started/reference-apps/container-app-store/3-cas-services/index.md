---
type: docs
title: "Model Container App Store Microservice services"
linkTitle: "Services"
slug: "services"
description: "Learn how to model the Container App Store Microservice services"
weight: 300
toc_hide: true
hide_summary: true
---

<!-- DISABLE_ALGOLIA -->

## Building the services

As part of a Radius deployment, the container images are built and provided to the application as parameters.

Open rad.yaml to see where the containers are built:

{{% alert title="Local container registry" color="info" %}}
When deployed, the Docker images are built and pushed to the registries specified within `build.docker.image`. When running locally with `rad app run`, the containers are instead built and pushed to the [local container registry]({{< ref "dev-environments#local-container-registry" >}}).
{{% /alert %}}

```yaml
name: store
stages:
...
- name: app
  build:
    go_service_build:
      docker:
        context: go-service
        image: MYREGISTRY/go-service # Overriden to local container registry when run locally
    node_service_build:
      docker:
        context: node-service
        image: MYREGISTRY/node-service # Overriden to local container registry when run locally
    python_service_build:
      docker:
        context: python-service
        image: MYREGISTRY/python # Overriden to local container registry when run locally
  ...
```

Within `app.bicep`, object parameters with the same name as the build steps are available to use with the container image imformation from the above step:

{{< rad file="snippets/app.bicep" embed=true marker="//PARAMS" >}}

## Services

The Container App Store services are modeled as Radius [container resources]({{< ref container >}}):

{{< tabs "Store API (node-app)" "Order Service (python-app)" "Inventory Service (go-app)" >}}

{{% codetab %}}
{{< rad file="snippets/app.bicep" embed=true marker="//NODEAPP" replace-key-rest="//REST" replace-value-rest="..." >}}
{{% /codetab %}}

{{% codetab %}}
{{< rad file="snippets/app.bicep" embed=true marker="//PYTHONAPP" replace-key-rest="//REST" replace-value-rest="..." >}}
{{% /codetab %}}

{{% codetab %}}
{{< rad file="snippets/app.bicep" embed=true marker="//GOAPP" replace-key-rest="//REST" replace-value-rest="..." >}}
{{% /codetab %}}

{{< /tabs >}}

Note the [`dapr.io/Sidecar` extension]({{< ref dapr-extension >}}) to add Dapr to each service.

## HTTP Route + Gateway

Each service will communicate with each other via HTTP.

An [HttpRoute]({{< ref httproute >}}) resource allows services to communicate with eachother. A [Gateway]({{< ref gateway >}}) resource can be added to let your services be accessible to the internet via a DNS name and paths.

{{< rad file="snippets/app.bicep" embed=true marker="//ROUTE">}}

## Dapr Invoke Routes

The Python and Go services allow other services to invoke them using Dapr Service Invocation, using a [Dapr Invoke Route]({{< ref dapr-http >}}):

{{< rad file="snippets/app.bicep" embed=true marker="//DAPR" >}}

## Next steps

Now that we have modeled the infrastructure and services let's run it locally on a Radius dev environment.

{{< button text="Next: Run application locally" page="4-cas-run" >}}

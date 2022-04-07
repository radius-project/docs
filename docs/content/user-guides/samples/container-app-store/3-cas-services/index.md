---
type: docs
title: "Model Container App Store Microservice services"
linkTitle: "Services"
slug: "services"
description: "Learn how to model the Container App Store Microservice services"
weight: 300
---

## Building the services

As part of a Radius deployment, the container images are built and provided to the application as parameters.

Open [`rad.yaml`]({{< ref rad-yaml >}}) to see where the containers are built:

{{< tabs "Local Environment" "Azure Environment" "Kubernetes Environment)" >}}

{{% codetab %}}

For local environments, the `Build` section of your `rad.yaml` does not need to point to any specific image, Radius automatically overwrites whatever your input is to the container registry created when your local environment is initialized.

```yaml
name: store
stages:
- name: infra
  bicep:
    template: iac/infra.bicep
  profiles:
    dev:
      bicep:
        template: iac/infra.dev.bicep
- name: app
  build:
    go_service_build:
      docker:
        context: go-service
        # Ignored
        image: MYREGISTRY/go-service
    node_service_build:
      docker:
        context: node-service
        # Ignored
        image: MYREGISTRY/node-service
    python_service_build:
      docker:
        context: python-service
        # Ignored
        image: MYREGISTRY/python
  ...
```

{{% /codetab %}}

{{% codetab %}}
For Azure environments, make sure that the `image` value is corresponding to the container registry that is registered with the Azure resource group you're connected to.

```yaml
name: store
stages:
- name: infra
  bicep:
    template: iac/infra.bicep
  profiles:
    dev:
      bicep:
        template: iac/infra.dev.bicep
- name: app
  build:
    go_service_build:
      docker:
        context: go-service
        # Azure Container Registry
        image: MYREGISTRY.azurecr.io/go-service
    node_service_build:
      docker:
        context: node-service
        # Azure Container Registry
        image: MYREGISTRY.azurecr.io/node-service
    python_service_build:
      docker:
        context: python-service
        # Azure Container Registry
        image: MYREGISTRY.azurecr.io/python
  ...
```

{{% /codetab %}}

{{% codetab %}}

For Kubernetes environments, you can use any container registry that is configured for your cluster. You just have to make sure that your Kubernetes cluster has access to it.

```yaml
name: store
stages:
- name: infra
  bicep:
    template: iac/infra.bicep
  profiles:
    dev:
      bicep:
        template: iac/infra.dev.bicep
- name: app
  build:
    go_service_build:
      docker:
        context: go-service
        # Kubernetes Container Registry
        image: MYREGISTRY/go-service
    node_service_build:
      docker:
        context: node-service
        # Kubernetes Container Registry
        image: MYREGISTRY/node-service
    python_service_build:
      docker:
        context: python-service
        # Kubernetes Container Registry
        image: MYREGISTRY/python
  ...
```

{{% /codetab %}}

{{< /tabs >}}


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

Note the [`dapr.io/Sidecar` trait]({{< ref dapr-trait >}}) to add Dapr to each service.

## HTTP Routes

Each service will communicate with each other via HTTP.

An [Http Route]({{< ref http-route >}}) resource allows services to communicate with eachother. Gateways can also be added to expose the service over the internet.

{{< rad file="snippets/app.bicep" embed=true marker="//ROUTE">}}

## Dapr HTTP Routes

The Python service allows other services to invoke it using Dapr Service Invocation, using a [Dapr Invoke Route]({{< ref dapr-http >}}):

{{< rad file="snippets/app.bicep" embed=true marker="//DAPR" >}}

## Next steps

Now that we have modeled the infrastructure and services let's run it locally on a Radius dev environment.

{{< button text="Next: Run application locally" page="4-cas-run" >}}

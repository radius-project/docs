---
type: docs
title: "Container App Application"
linkTitle: "Container app application"
description: "A microservices application that uses Dapr"
weight: 200
---

## Sample Repo

{{< button text="Radius Samples" link="https://github.com/project-radius/samples" >}}

This demo shows just how easy it is to integrate Radius into a multiple microservice application that uses [Dapr](https://dapr.io). As a Radius application it will gain the following benefits:

* Defined first-class relationships between microservices and the infrastructure
* Will add portability to the application allowing it to move from environments such as Azure, Kubernetes and local development with ease.
* Run and test the application locally.

To simulate the transition from an application to an Radius application this demo has three major breaktdowns 1-3.

* **Breakdown 1** - the configurations needed to convert an application into a Radius application.
* **Breakdown 2** - local development showing the ease of deployment and application development that Radius brings.
* **Breakdown 3** - the ease of switching deployment environments from local to a Kubernetes cluster and an Azure AKS cluster.

## Sample info

>Note: this demo uses Rad CLI v0.11 and may break change in future releases.

![Architecture Overview](container-app-store.png)

This application contains three main microservices in the solution:

* **Store API (node-app)** - The node-app is an express.js API that exposes three endpoints.

  * `/` will return the primary index page
  * `/order` will return details on an order (retrieved from the order service)
  * `/inventory` will return details on an inventory item (retireved from the inventory service)

* **Order Service (python-app)** - The python-app is a Flask app that will retrieve and store the state of orders.

  * Uses `Dapr state management` to store the state of the orders.
  * The statestore is configured to point to an Redis container.

* **Inventory Service (go-app)** - The go-app is a Go Mux app that will retrieve and store the state of inventory.

  * Returns back a static value.

## Breakdown 1

This demo will demonstrate how to represent your microservices in Bicep as well as the configurations needed to have in your `rad.yaml` for proper usage of those Bicep files.

#### Objectives

The goal of this demo is to show how quickly you can get an application running with Radius.

* Show the ease of how your services and infrastructure can be represented in Bicep.
* Show the ease of setup in your `rad.yaml`

#### Requirements

* Rad CLI

#### Walkthrough example

Starting from the repo folder, enter the directory (`./Container-App-Store`)

* Install [Rad CLI](https://edge.radapp.dev/getting-started/#install-rad-cli)

* Initialize a Radius application

  ```bash
  rad app init
  ```

This will create a starting template for your `iac/app.bicep`, `iac/infra.bicep` and a `rad.yaml`.

* **`rad.yaml`** - The rad.yaml file configures application multi-stage deployment. The commmand rad app init creates rad.yaml for you as part of app initialization.

  * An example of a working `rad.yaml` for this demo is:

  ```yaml

    # Name of Radius application
    name: store

    # Stages define an ordered set of steps to take in the deployment of an application

    stages:
     name: infra
    bicep:
        template: iac/infra.bicep
     name: app

    # Details on a build to run prior to a deployment

    build:
        go_service_build:
        docker:
            context: go-service
            # overwritten in local
            image: <MY CONTAINER REGISTRY>/go-service
        node_service_build:
        docker:
            # directory to run the Docker build in.
            context: node-service
            # overwritten in local
            image: <MY CONTAINER REGISTRY>/node-service
        python_service_build:
        docker:
            context: python-service
            # overwritten in local
            image: <MY CONTAINER REGISTRY>/python
    bicep:
        template: iac/app.bicep
  ```

* **`iac/app.bicep`** - The `app.bicep` file is the place were the user defines the services and resources that are part of the application in Bicep.

  * An example of a working `iac/app.bicep` for this demo is:

  ```bicep
    // These parameters correspond to the build objects described in the 'rad.yaml'
    // it's important to note that the image location for each of them is overwritten in 
    // a local environment to represent the automatically created container registry found in
    // the Radius local environment.
    param go_service_build object
    param node_service_build object
    param python_service_build object

    resource app 'radius.dev/Application@v1alpha3' existing = {
    name: 'store'

    // The 3 Microservices described in Bicep format for Radius.

    resource go_app 'Container' = {
        name: 'go-app'
        properties: {
        // Details on what to run and how to run it are defined in the container property
        container: {
            image: go_service_build.image
            ports: {
            web: {
                containerPort: 8050
            }
            }
        }
        // A Trait is a piece of configuration that specifies an operational behavior
        traits: [
            {
            kind: 'dapr.io/Sidecar@v1alpha1'
            appId: 'go-app'
            appPort: 8050
            provides: go_app_route.id
            }
        ]
        }
    }
    resource node_app 'Container' = {
        name: 'node-app'
        properties: {
        container: {
            image: node_service_build.image
            env: {
            'ORDER_SERVICE_NAME': python_app_route.properties.appId
            'INVENTORY_SERVICE_NAME': go_app_route.properties.appId
            }
            ports: {
            web: {
                containerPort: 3000
                provides: node_app_route.id
            }
            }
        }
        connections: {
            inventory: {
            kind: 'dapr.io/InvokeHttp'
            source: go_app_route.id
            }
            orders: {
            kind: 'dapr.io/InvokeHttp'
            source: python_app_route.id
            }
        }
        traits: [
            {
            kind: 'dapr.io/Sidecar@v1alpha1'
            appId: 'node-app'
            }
        ]
        }
    }

    resource python_app 'Container' = {
        name: 'python-app'
        properties: {
        container: {
            image: python_service_build.image
            ports: {
            web: {
                containerPort: 5000
            }
            }
        }
        connections: {
            kind: {
            kind: 'dapr.io/StateStore'
            source: statestore.id
            }
        }
        traits: [
            {
            kind: 'dapr.io/Sidecar@v1alpha1'
            appId: 'python-app'
            appPort: 5000
            provides: python_app_route.id
            }
        ]
        }
    }

    // HTTP Routes define the microservice they correspond to for communication
    resource go_app_route 'dapr.io.InvokeHttpRoute' = {
        name: 'go-app'
        properties: {
        appId: 'go-app'
        }
    }

    resource node_app_route 'HttpRoute' = {
        name: 'node-app'
        properties: {
        gateway: {
            hostname: '*'
        }
        }
    }

    resource python_app_route 'dapr.io.InvokeHttpRoute' = {
        name: 'python-app'
        properties: {
        appId: 'python-app'
        }
    }

    // A dapr.io/StateStore resource represents a Dapr state store topic.
    // Depending on the Radius environment used, the name 'orders' can correspond to a Azure Dapr resource 
    // or local kubernetes resource in this example.
    resource statestore 'dapr.io.StateStore' existing = {
        name: 'orders'
    }
    }
  ```

* **`iac/infra.bicep`** - The `infra.bicep` file is the place were the user defines the infrastructure resources if they wish to not define everything in their `app.bicep` file.

  * An example of a working `iac/infra.bicep` for this demo is:

  ```bicep
    resource app 'radius.dev/Application@v1alpha3' = {
    name: 'store'

    }

    // Dapr StateStore container starter uses a Redis container that can run on any Radius platform.
    // This module is referenced in app.bicep by the name of 'orders'
    module statestore 'br:radius.azurecr.io/starters/dapr-statestore:latest' = {
    name: 'orders'
    params: {
        radiusApplication: app
        stateStoreName: 'orders'
    }
    }
  ```

With these 3 files you've converted the application into a Radius application, fully ready to be deployed into an environment.

## Breakdown 2

Breakdown 2 builds on breakdown 1 adding a local Radius environment which will allow you to run and test your demo locally.

#### Objectives

* Builds on Demo 1, illustrates the ease of creating a local environment.
* Illustrates the ease of running an application locally.

#### Requirements

* Docker
* Node.js
* Python runtime
* Golang runtime
* K3d
* Kubectl
* Rad CLI

#### Walkthrough example

Starting from the repo folder, enter the directory (`./Container-App-Store`)

* Initialize a Radius local environment

  ```bash
  rad env init dev -i
  ```

Set the desired values for each input requested.

Now we can deploy the application into our local environment and test out our services.

* Run your application

    ```bash
    rad app run app
    ```

## Breakdown 3

Breakdown 3 takes the local development work and moves it to 2 other environments, AKS in Azure and a Kubernetes cluster.

#### Objectives

* Show how to switch from a local environment to Azure/Kubernetes environments.

#### Requirements

* AZ CLI
* Kubernetes cluster

#### Walkthrough example

Starting from the repo folder, enter the directory (`./Container-App-Store`)

Setup your environments.

##### Azure

* Make sure you authenticate with `az` CLI your Azure account.

```bash
az login
```

* Create the Radius Azure environment

```bash
    rad env init azure
```

##### Kubernetes

Make sure you have a kubernetes cluster running.

Create the Radius Azure environment

```bash
    rad env init kubernetes -i
```

##### Deploy

Deploy your application

```bash
    rad app deploy
```

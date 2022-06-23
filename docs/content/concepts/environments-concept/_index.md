---
type: docs
title: "Environments concept"
linkTitle: "Environments"
description: "Learn about Radius Environments"
weight: 300
---

## Introduction
Radius environments can be thought of as a prepared landing zone for applications. Creating and configuring an environment results in a prepared pool of compute, networking, and dependency resources like databases. Then, a Radius application can be deployed into the environment, "binding" the app to the infrastructure. 

Because environment definitions can be codified, central teams can define environment templates that let their dev teams hydrate fully-functioning environments in a self-service way - while following organization best practices like security confiugration. 

<img src="env-template-example.png" alt="Diagram of example contents for an environment template. It contains dependencies like Dapr, recipes for infrastructure, security configuration, diagnostics and logging, and compute runtime." width="200" />

## Configuring environments
### 1. Define the environment 
Environments, like applications, are defined via Infrastructure-as-Code languages. 
For the list of supported languages, see [Languages]({{< ref supported-languages >}}). 

### 2. Create a Kubernetes cluster
Flavor and specs of your choosing (e.g. [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster), [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/), [K3s](https://k3s.io))

### 3. Run `rad env init kubernetes`
Radius currently supports Kubernetes as the container runtime. We plan to support additional container runtimes in the future. 

This command will:
- If needed, install a Radius control plane
    - Install Radius control plane services via a set of Helm charts 
- Create a new environment 
    - Create a namespace to hold the environment resource 
    - Create an environment resource
    - Execute any environment installation templates (e.g. to install Dapr) 
- Walk users through configuring cloud providers to connect to public clouds 

Each AKS or EKS cluster requires 1 Radius control plane, but it may contain multiple Radius environmnents if desired. 


## Using environments
### Environment as a resource instance
An environment is more than just an address of where to put the application. 

**Each environment has its own credentials**  
Developers don't need a full set of infrastructure permissions in order to spin up the infrastructure they need. For example. A developer may need a storage account to be created as part of their app. Previously, they could either requst the database via ticketing system and lengthy approval process or they needed credentials to be able to deploy that resource type themselves. Now, Radius offers a way for central teams to empower dev teams to run quickly, knowing sufficient guardrails are in place.

Infra teams can build up definitions ("recipes") for how various resource types should be deployed. When a dev user consumes them, the environment's credentials can be used to execute the deployment, so individual dev users don't need elevated permissions to obtain their supporting infrastructure. 

--- simple version of Jason's Kendrick v Kanye flowchart ---

**Environments are stateful**  
TODO fill this in

**other?**

### Environment as local workspace 
After initializing a new Radius environment, you will see:  
"Successfully wrote configuration to .../config.yaml"

The environment context is stored locally in a config file to simplify environment consumption. 

Like a Kubernetes cluster config, a user has an active Radius environment that is used by default as the target for their app deployments.   

Additionally, the config file stores environment names for easily switching between environments. 

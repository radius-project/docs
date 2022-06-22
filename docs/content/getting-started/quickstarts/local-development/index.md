---
type: docs
title: "Quickstart: Local development"
linkTitle: "Local development"
description: "Learn about using Radius local development environments to easily create and test applications" 
weight: 400
---

## Overview

Walk through a simple [dockerized NodeJs express.js application](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/) to learn the fundamentals of Radius local development environments.

### Prerequisites

To run this quickstart, you need the following prerequisites:

- [Docker](https://docs.docker.com/get-docker/)
- [Stern](https://github.com/wercker/stern)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)

### Step 1: Set up the sample

To set up the sample:

1. In your working directory, create a file named `package.json`.

1. Include the following inside `package.json`:
    {{< rad file="code/src/package.json" embed=true >}}

1. Run `npm install`, this will generate a `package-lock.json` file which will be copied to your Docker image.

1. Create a `server.js` file that defines a web app using the [Express.js](https://expressjs.com/).
    {{< rad file="code/src/server.js" embed=true >}}

1. Create a `Dockerfile` configured for the NodeJs application.
    {{< rad file="code/src/Dockerfile" embed=true >}}

1. Include a `.dockerignore` file in the same directory as your Dockerfile with the following content:
    {{< rad file="code/src/.dockerignore" embed=true >}}

### Step 2: Create a Radius local environment

To setup your [Radius local environment]({{< ref dev-environments >}}):

1. Run `rad env init dev -i` and you'll be able to configure the environment as needed for:
    - Naming the Environment

    ```bash
    Enter an environment name [dev]: `<YOUR-INPUT>`
    Using `<YOUR-INPUT>` as environment name
    ```

    - [Azure provider]({{< ref azure-environments >}})

    ```bash
    Add Azure provider for cloud resources [y/N]? `<YOUR-INPUT>`
    ```

    {{% alert title="From local to cloud" color="info" %}}
    Radius local environments support Azure resources but the scope goes beyond this quickstart.
    {{% /alert %}}  

1. Once you've entered the prompted input, Radius will move on to creating a local Kubernetes cluster.

    ```bash
    Creating Cluster...
    INFO[0000] portmapping '80' targets the loadbalancer: defaulting to [servers:*:proxy agents:*:proxy]
    INFO[0000] portmapping '443' targets the loadbalancer: defaulting to [servers:*:proxy agents:*:proxy]
    INFO[0000] Prep: Network
    INFO[0000] Created network 'k3d-radius-`<YOUR-INPUT>`'
    INFO[0000] Created volume 'k3d-radius-`<YOUR-INPUT>`-images'
    INFO[0000] Creating node 'radius-`<YOUR-INPUT>`-registry'
    INFO[0000] Successfully created registry 'radius-`<YOUR-INPUT>`-registry'
    INFO[0000] Starting new tools node...
    INFO[0000] Starting Node 'k3d-radius-`<YOUR-INPUT>`-tools'
    INFO[0001] Creating node 'k3d-radius-`<YOUR-INPUT>`-server-0'
    INFO[0001] Creating LoadBalancer 'k3d-radius-`<YOUR-INPUT>`-serverlb'
    INFO[0001] Using the k3d-tools node to gather environment information
    INFO[0002] Starting cluster 'radius-`<YOUR-INPUT>`'
    INFO[0002] Starting servers...
    INFO[0003] Starting Node 'k3d-radius-`<YOUR-INPUT>`-server-0'
    INFO[0007] All agents already running.
    INFO[0007] Starting helpers...
    INFO[0007] Starting Node 'radius-`<YOUR-INPUT>`-registry'
    INFO[0007] Starting Node 'k3d-radius-`<YOUR-INPUT>`-serverlb'
    INFO[0013] Injecting '192.168.65.2 host.k3d.internal' into /etc/hosts of all nodes...
    INFO[0014] Injecting records for host.k3d.internal and for 3 network members into CoreDNS configmap...
    INFO[0017] Cluster 'radius-`<YOUR-INPUT>`' created successfully!  
    INFO[0017] You can now use it like this:
    kubectl cluster-info
    Installing Radius...
    Installing new Radius Kubernetes environment to namespace: radius-system
    ```

    You'll know the creation was successful once you see:

    ```bash
    Successfully wrote configuration to /Users/`<YOUR-NAME>`/.rad/config.yaml
    ```

### Step 3: Initialize your Radius application

To initialize a Radius application:

1. In the working directory storing the sample application created in step 1, run `rad app init`.

    ```bash
    Initializing Application Workspace...

        Created rad.yaml
        Created iac/infra.bicep
        Created iac/app.bicep

    Have a RAD time 😎  
    ```

1. Configure the files created as follows:

    - `rad.yaml`
    {{< rad file="code/rad.yaml" embed=true >}}

    For a deep dive into [rad.yaml]({{< ref rad-yaml >}}).

    - `iac/app.bicep`
    {{< rad file="code/iac/app.bicep" embed=true >}}

    For a deep dive into [authoring bicep files]({{< ref author-apps >}}).

    - `iac/infra.bicep` can be deleted as this application doesn't use any infrastructure resources.

### Step 4: Run your Radius application

To run your Radius application:

1. Run the command `rad app run app`.

1. This command will read your `rad.yaml` and display the following information:

    - Your environment in use:

    ```bash
    Using environment `<YOUR-ENV>`
    ```

    - Your deployment stages:

    ```bash
    Processing stage app: 1 of 1
    [node_build] Processing build node_build
    ....
    ```

    - Your bicep file build and its deployment application information:

    ```bash
    Building iac/app.bicep...
    Deploying iac/app.bicep...


    Deployed stage app: 1 of 1

    Resources:
        code            Application         
        demo            Container           
        web             Gateway             
        route           HttpRoute           

    Public Endpoints:
        web             Gateway              http://localhost:53091
    Application code has been deployed. Press CTRL+C to exit...
    ```

    - Display your application log stream:

    ```bash
    Launching log stream...
    + code-demo-757cf7986c-447z7 › demo
    code-demo-757cf7986c-447z7 demo Running on http://0.0.0.0:8080
    ```

1. Access your application by accessing the gateway provided.

    ```bash
    Public Endpoints:
        web             Gateway              http://localhost:<PORT>
    ```

### Deep Dive

For a more in depth understanding of what's created in a Radius local environment visit [local environment platform page]({{< ref dev-environments >}}).

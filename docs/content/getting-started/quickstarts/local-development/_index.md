---
type: docs
title: "Quickstart: Local development features"
linkTitle: "Local development features"
description: "Get started with local environments in Radius"
weight: 200
---

With [Radius local environments]({{< ref dev-environments >}}) you can run applications straight from your machine.

Running an application with a local environment mirrors many aspects of using other Radius environments. For this Quickstart, you'll run a Radius application with various microservices.

### Step 1: Prerequisite

For this example, you will need:

- [rad CLI]({{< ref "getting-started#install-rad-cli" >}})
- [Docker](https://docs.docker.com/get-docker/)
- [Dapr CLI](https://docs.dapr.io/getting-started/install-dapr-cli/)
- [k3d](https://k3d.io/v5.4.1/)
- [Stern](https://github.com/wercker/stern)

### Step 2: Set up the application

Clone the reference application [`Container App Store`](https://github.com/project-radius/samples) found in the Radius samples repo.

```bash
git clone https://github.com/project-radius/samples.git
```

### Step 3: Create local Radius environment

Using the `rad cli` create a local Radius environment.

```bash
rad env init dev
```

### Step 4: Run your application

Using the `rad cli` run your application, make sure you're in the `Container App Store` directory as commands will be dependent on the Bicep files and `rad.yaml` configurations.

```bash
rad app run app
```

### Step 5: Leverage local specific features

#### Hot-Reload

Radius local environments support Dockerfile configurations that enable hot-reloading in Kubernetes clusters.

To see it in action run:

```bash
rad app run --profile hotreload
```

This will load a Dockerfile for a NodeJs application that supports hot-realoading.

```Dockerfile
FROM node:14-alpine

USER node
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

COPY --chown=node:node package*.json ./
RUN npm ci
COPY --chown=node:node . .

EXPOSE 3000
ARG ENV=development
ENV NODE_ENV $ENV
CMD ["npm", "run", "watch"]
```

#### View microservice logs

While running your application the `rad cli` will be listing out logs based on each service running inside your Radius application.

```bash
Launching log stream...
+ store-node-app-75ff4c774-q8shk › node-app
+ store-starter-redis-container-orders-56d6b8cf47-znmgr › starter-redis-container-orders
+ store-python-app-6d88c6546-7qtdl › python-app
+ store-go-app-6b89566f95-bcj6n › go-app
```

## Tell us what you think

We’re continuously working to improve our Quickstart examples and value your feedback. Did you find this Quickstart helpful? Do you have suggestions for improvement?

Open up issues on our samples page to [join the dicussion](https://github.com/project-radius/samples).

## Next Steps

- Learn more about [Radius environments]({{< ref platforms >}})
- Learn more about how to [author Radius applications]({{< ref author-apps >}}) to use in Radius environments.

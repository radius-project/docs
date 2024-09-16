---
type: docs
title: "How-To: Reference secrets in Dapr components"
linkTitle: "Reference secrets in components"
description: "Learn how to manage secrets in Dapr components"
weight: 300
categories: "How-To"
tags: ["Dapr"]
---

This guide will provide an overview of how to:

- Securely manage secrets in Dapr components using [Dapr secret stores](https://docs.dapr.io/operations/components/setup-secret-store/)

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})
- [Radius local-dev Recipes]({{< ref howto-dev-recipes >}})
- [Dapr installed on your Kubernetes cluster](https://docs.dapr.io/operations/hosting/kubernetes/kubernetes-deploy/)

## Step 1: Create a container and a Dapr sidecar

Begin by creating a file named `app.bicep`, which defines a container with a Dapr state store. If you need a detailed explanation on how to do so, refer to the [Add a Dapr building block]({{< ref how-to-dapr-building-block >}}) tutorial.

In this guide, you manually provision both a Redis instance and a Dapr state store component. Specify the Redis username in the Dapr state store, which will later be secured using a Dapr Secret Store.

{{< rad file="./snippets/app-statestore.bicep" embed=true >}}

Deploy the application with the `rad` CLI:

```bash
rad run ./app.bicep -a demo-secret
```

While the application is running, verify that the `redisUsername` is exposed in the Dapr state store component by running the following command **in another terminal**:
```sh
kubectl -n default-demo-secret get component demo-statestore -o yaml
```

The output should look similar to:
```yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: demo-statestore
  namespace: default-demo-secret
spec:
  metadata:
  - name: redisHost
    value: <HOST>
  - name: redisUsername
    # The Redis username is stored in plain text
    value: default
  type: state.redis
  version: v1
```

## Step 2: Add a Dapr secret store resource and create a secret

Secure the Redis username using a Dapr Secret Store. In your `app.bicep` file, add a Dapr secret store resource. Use the [`local-dev` recipe]({{< ref "guides/recipes/overview##use-lightweight-local-dev-recipes" >}}) to deploy the secret store, leveraging Kubernetes secrets

{{< rad file="./snippets/app-statestore-secret.bicep" embed=true marker="//SECRETSTORE" >}}

> Visit the [Radius Recipe repo](https://github.com/radius-project/recipes/blob/main/local-dev/secretstores.bicep) to learn more about `local-dev` Recipes and view the Dapr Secret Store Recipe used in this guide.


Now, create a Kubernetes secret for the Redis username by creating a `redis-auth.yaml` file with the following content:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: redis-auth
  namespace: default-demo-secret
type: opaque
data:
  # Result of "echo -n 'default' | base64"
  username: ZGVmYXVsdA==
```
    
Apply the secret to your Kubernetes cluster by running:
```sh
kubectl apply -f redis-auth.yaml
```

## Step 3: Configure the Dapr state store to use the Dapr secret store

Finally, update your Dapr state store to reference the created secret.

{{< rad file="./snippets/app-statestore-secret.bicep" embed=true marker="//STATESTORE" >}}


## Step 4: Deploy the updated application

Deploy the application with the updated configuration:
```bash
rad run ./app.bicep -a demo-secret
```

You can verify that the Redis username is no longer exposed by running the following command **in another terminal**:
```sh
kubectl -n default-demo-secret get component demo-statestore -o yaml
```

The output should show the Redis username stored in the secret store:
```yaml
apiVersion: dapr.io/v1alpha1
auth:
  secretStore: secretstore
kind: Component
metadata:
  name: demo-statestore
  namespace: default-demo-secret
spec:
  metadata:
  - name: redisHost
    value: <HOST>
  - name: redisUsername
    secretKeyRef:
      key: username
      name: redis-auth
  type: state.redis
  version: v1
```
Open [http://localhost:3000](http://localhost:3000) to view the Radius demo container. The TODO application should work as intended.

> In a production environment, it's recommended to use a more secure secret store, such as Azure Key Vault or HashiCorp Vault, instead of relying on Kubernetes secrets. You can find the list of all Dapr secret store components [here](https://docs.dapr.io/reference/components-reference/supported-secret-stores/).

## Cleanup

To delete your app, run the [rad app delete]({{< ref rad_application_delete >}}) command to cleanup the app and its resources, including the Recipe resources:

```bash
rad app delete -a demo-secret
kubectl delete secret redis-auth -n default-demo-secret
```

## Further reading

- [Dapr building blocks](https://docs.dapr.io/concepts/building-blocks-concept/)
- [Dapr resource schemas]({{< ref dapr-schema >}})


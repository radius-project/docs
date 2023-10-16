---
type: docs
title: "How To: Create a new Secret Store"
linkTitle: "Existing Secret Stores"
description: "Learn how to create new or reference existing Secrets in your Radius Application"
weight: 300
categories: "How-To"
tags: ["secrets"]
---

## Pre-requisites 

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/) 
- [Radius Bicep VSCode extension]({{< ref "installation#step-2-install-the-radius-bicep-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-the-radius-control-plane-and-the-radius-environment" >}})

## Step 1 : Create a Kubernetes secret 

Create a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/) with the below command 

```bash
kubectl create secret generic db-user-pass \
    --from-literal=username=admin \
    --from-literal=password='test123'
```

## Step 2: Reference an existing Secret Store

Open the `app.bicep` from the current working directory and add the secret store resource to reference an existing secret store. 

{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRET_STORE_REF" >}}

In this example the secret store resource references a Kubernetes secret that was created in step 1.

## Step 3: Deploy the application

Deploy the application with [`rad deploy`]({{< ref "rad_deploy" >}}):

```bash
rad deploy app.bicep -a secretdemo
```

## Step 4: Verify the secrets are deployed 

Use the below command to verify if the secret got deployed 

```bash
kubectl get secret -n default
```

## Further reading

- [Secret store schema]({{< ref secretstore >}})
- [How To: gateway TLS termination]({{< ref howto-tls >}})

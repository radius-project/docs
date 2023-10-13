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

- [rad CLI]({{< ref "/guides/tooling/rad-cli/overview" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-the-radius-control-plane-and-the-radius-environment" >}})
- [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/) already deployed 

## Step 1: Reference an existing Secret Store

Open the `app.bicep` from the current working directory and add the secret store resource to reference an existing secret store. 

{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRET_STORE_REF" >}}

In this example the secret store resource references Kubernetes Secrets of type `certificate`

## Step 2: Deploy the application

Deploy the application with [`rad deploy`]({{< ref "rad_deploy" >}}):

```bash
rad deploy app.bicep -a secretdemo
```

## Step 3: Verify the secrets are deployed 

Use the below command to verify if the secret got deployed 

```bash
kubectl get secret -n default-docs
```

You will find `appCert` of type kubernetes.io/tls automatically created.

## Further reading

- [Secret store schema]({{< ref secretstore >}})
- [How To: gateway TLS termination]({{< ref howto-tls >}})

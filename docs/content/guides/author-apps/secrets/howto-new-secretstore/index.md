---
type: docs
title: "How To: Create new or reference an existing Secret Store"
linkTitle: "Secret Stores"
description: "Learn how to create new or reference existing Secrets in your Radius Application"
weight: 200
categories: "How-To"
tags: ["secrets"]
---

Radius leverages the secrets management solution available on the hosting platform to create and store the secret. For example, if you are deploying to Kubernetes, the secret will be created in Kubernetes Secrets.

## Pre-requisites 

- [rad CLI]({{< ref "/guides/tooling/rad-cli/overview" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-the-radius-control-plane-and-the-radius-environment" >}})

## Step 1: Add a Secret Store

Open the `app.bicep` from the current working directory and add a new Secret Store resource

{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRET_STORE_NEW" >}}

In this example a new secret store resource is created for storing a TLS certificate in it. 

## Step 2: Deploy the application

Deploy the application with [`rad deploy`]({{< ref "rad_deploy" >}}):

```bash
rad deploy app.bicep -a secretdemo 
```

## Step 3: Verify the secrets are deployed 

Use the below command to verify if the secret got deployed 

```
kubectl get secret -n default-docs
```

You will find `appcert` of type kubernetes.io/tls automatically created.

## Further reading

- [Secret store schema]({{< ref secretstore >}})
- [How To: gateway TLS termination]({{< ref howto-tls >}})

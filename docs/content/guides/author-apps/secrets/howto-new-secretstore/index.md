---
type: docs
title: "How To: Create new Secret Store"
linkTitle: "New Secret Store"
description: "Learn how to create new secrets in your Radius Application"
weight: 200
categories: "How-To"
tags: ["secrets"]
---

Radius secret stores securely manage secrets for your Environment and Application.

By default, Radius leverages the hosting platform's secrets management solution to create and store the secret. For example, if you are deploying to Kubernetes, the secret store will be created as a Kubernetes Secret.

## Pre-requisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Bicep VSCode extension and Bicep configuration file]({{< ref "installation#step-2-install-the-radius-bicep-vs-code-extension" >}})
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

Use the below command to verify if the secret got deployed:

```bash
kubectl get secret -n default-secretdemo
```

You will find `appCert` of type kubernetes.io/tls automatically created.

## Further reading

- [Secret store schema]({{< ref secretstore >}})
- [How To: gateway TLS termination]({{< ref howto-tls >}})

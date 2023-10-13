---
type: docs
title: "How To: Create a new Secret Store"
linkTitle: "New Secret Stores"
description: "Learn how to create new or reference existing Secrets in your Radius Application"
weight: 300
categories: "How-To"
tags: ["secrets"]
---

## Pre-requisites 

- [rad CLI]({{< ref "/guides/tooling/rad-cli/overview" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-the-radius-control-plane-and-the-radius-environment" >}})

## Step 1: Add a Secret Store

Open the `app.bicep` from the current working directory and add a new Secret Store resource or reference an existing secret store. 

{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRET_STORE_REF" >}}

In this example the secret store resource reference secrets stores in an existing secrets management solution that is external to the Radius Application stack. Note that only references to Kubernetes Secrets is currently supported, with more to come in the future.

## Step 2: Deploy the application

Deploy the application with [`rad deploy`]({{< ref "rad_deploy" >}}):

```bash
rad deploy app.bicep 
```

## Step 3: Validate the Kubernetes secret resource deployed 



## Further reading

- [Secret store schema]({{< ref secretstore >}})
- [How To: gateway TLS termination]({{< ref howto-tls >}})

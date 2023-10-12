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

Open the `app.bicep` and add a new Secret Store resource or reference an existing secret store. 

{{< tabs "New Secret Store" "Existing Secret Store" >}}

{{% codetab %}}
{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRET_STORE_NEW" >}}
In this example a new secret store resource is created for storing a TLS certificate in it. 
{{% /codetab %}}

{{% codetab %}}
{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRET_STORE_REF" >}}
In this example the secret store resource reference secrets stores in an existing secrets management solution that is external to the Radius Application stack. Note that only references to Kubernetes Secrets is currently supported, with more to come in the future.
{{% /codetab %}}

{{< /tabs >}}

## Step 2: Deploy the application

Deploy the application with [`rad deploy`]({{< ref "rad_deploy" >}}):

```bash
rad deploy app.bicep 
```

## Further reading

- [Secret store schema]({{< ref secretstore >}})
- [How To: gateway TLS termination]({{< ref howto-tls >}})

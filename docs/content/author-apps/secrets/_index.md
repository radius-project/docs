---
type: docs
title: "Secrets management"
linkTitle: "Secrets"
description: "Learn how to create and reference secrets in your Radius application"
weight: 210
categories: "Concept"
tags: ["secrets"]
---

## Overview

Sensitive data, such as TLS certificates, tokens, passwords, and keys that serve as digital authentication credentials are commonly referred to as secrets. A Radius Secret Store enables you to either store these secrets or reference existing secrets stored in external secret management solutions. Kubernetes Secrets is currently supported with others, such as Azure Keyvault or AWS Secrets Manager, coming in the future.

An independent resource with its own lifecycle, a Radius Secret Store ensures that data is persisted across container restarts or mounts and can interact directly with the Radius Application Model. For instance, an Applications.Core/gateways resource can use this resource to store a TLS certificate and reference it.

## Create a new Secret Store

Here is an example for creating a new Secret Store resource and storing a TLS certificate in it. Radius leverages the secrets management solution available on the hosting platform to create and store the secret. For example, if you are deploying to Kubernetes, the secret will be created in Kubernetes Secrets.

{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRET_STORE_NEW" >}}

## Reference an existing Secret Store

Here is an example of using a Secret Store to reference secrets stores in an existing secrets management solution that is external to the Radius application stack. Note that only references to Kubernetes Secrets is currently supported, with more to come in the future.

{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRET_STORE_REF" >}}

## Using Secret Stores

Secret Stores can currently be used for TLS certificates with [Radius Gateways]({{< ref "networking#gateways" >}}).

Additional use-cases will be added in upcoming releases.

## Further reading

- [How To: TLS termination with your own TLS certificate]({{< ref howto-tls-termination >}})
- [How To: TLS termination with a certificate from Let's Encrypt]({{< ref howto-tls-termination-cert-manager >}})

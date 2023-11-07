---
type: docs
title: "Overview: Secrets management"
linkTitle: "Overview"
description: "Learn how to create and reference secrets in your Radius Application"
weight: 100
categories: "Overview"
tags: ["secrets"]
---

## Overview

Sensitive data, such as TLS certificates, tokens, passwords, and keys that serve as digital authentication credentials are commonly referred to as secrets. A Radius Secret Store enables you to either store these secrets or reference existing secrets stored in external secret management solutions. Kubernetes Secrets is currently supported with others, such as Azure Keyvault or AWS Secrets Manager, coming in the future.

An independent resource with its own lifecycle, a Radius Secret Store ensures that data is persisted across container restarts or mounts and can interact directly with the Radius Application Model. For instance, an Applications.Core/gateways resource can use this resource to store a TLS certificate and reference it.

## Create a new Secret Store 

Radius leverages the secrets management solution available on the hosting platform to create and store the secret. For example, if you are deploying to Kubernetes, the secret will be created in Kubernetes Secrets.
Follow the [how-to guide on creating new secret store]({{< ref "/guides/author-apps/secrets/howto-new-secretstore" >}}) to learn more about creating a new secret store resource and storing a TLS certificate in it.

## Reference an existing Secret Store

You can also reference an existing secrets management solution that is external to the Radius Application stack. Note that only references to Kubernetes Secrets is currently supported, with more to come in the future.

## Using Secret Stores

Secret Stores can currently be used for TLS certificates with [Radius Gateways]({{< ref "guides/author-apps/networking/overview#gateways" >}}).

Additional use-cases will be added in upcoming releases.

## Further reading

- [How To: gateway TLS termination]({{< ref howto-tls >}})

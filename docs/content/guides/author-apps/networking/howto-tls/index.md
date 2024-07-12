---
type: docs
title: "How To: Add TLS termination to a gateway"
linkTitle: "HTTPS/TLS"
description: "Learn how to deploy HTTPS-enabled application with a TLS certificate" 
weight: 400
slug: 'tls'
categories: "How-To"
---

This guide will show you how to add TLS and HTTPS to an application with a gateway.

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension and Bicep configuration file]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})
- Domain name + DNS A-record pointing to your Kubernetes cluster
  - If running Radius on an Azure Kubernetes Service (AKS) cluster you can optionally use a [DNS label](https://learn.microsoft.com/azure/virtual-network/ip-services/public-ip-addresses#dns-name-label) to create a DNS A-record pointing to your cluster.
  - If running Radius on an Elastic Kubernetes Service (EKS) cluster you can optionally leverage an [Application Load Balancer](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html) for a hosted DNS name and record.

## Step 1: Define a container

Begin by creating a file named `app.bicep`. Add a container which will be exposed to the internet:

{{< rad file="snippets/app-existing.bicep" marker="//FRONTEND" embed=true >}}

## Step 2: Add a secret store

TLS certificates need to be referenced via a Radius [secret store]({{< ref "/guides/author-apps/secrets" >}}). You can either reference an existing secret, or define a new one with certificate data.

{{< tabs "Reference existing secrets" "Define new secrets" >}}

{{< codetab >}}

{{< alert title="Managing certificates in Kubernetes" color="info" >}}
[cert-manager](https://cert-manager.io/docs/) is a great way to manage certificates in Kubernetes and make them available as a Kubernetes secret. This example uses a Kubernetes secret that was setup by cert-manager
{{< /alert >}}

{{< rad file="snippets/app-existing.bicep" marker="//SECRETS" embed=true >}}

{{< /codetab >}}

{{% codetab %}}

{{< rad file="snippets/app-new.bicep" marker="//SECRETS" embed=true >}}

{{% /codetab %}}

{{< /tabs >}}

## Step 3: Add a gateway

Now that your certificate data is ready add a gateway and reference the secret store:

{{< rad file="snippets/app-new.bicep" marker="//GATEWAY" embed=true >}}

## Step 4: Deploy the application

{{< tabs "Reference existing secrets" "Define new secrets" >}}

{{% codetab %}}

```sh
rad deploy app.bicep -a tlsdemo
```

{{% /codetab %}}

{{% codetab %}}

```sh
rad deploy app.bicep -a tlsdemo -p tlscrt=<base64-encoded TLS certificate> -p tlskey=<base64-encoded TLS certificate private key>
```

{{% /codetab %}}

{{< /tabs >}}

You should see the application deploy successfully, with the public endpoint printed automatically:

```
Building app.bicep...
   Deploying template './app.bicep' for application 'tlsdemo' and environment 'default' from workspace 'default'...

   Deployment In Progress...

   Completed            gateway         Applications.Core/gateways
   Completed            frontend        Applications.Core/containers
   Completed            secretstore     Applications.Core/secretstores

   Deployment Complete

   Resources:
      gateway         Applications.Core/gateways
      secretstore     Applications.Core/secretstores
      frontend        Applications.Core/containers

    Public endpoint https://MYDOMAIN/
```

## Step 5: Access HTTPS endpoint

Once the deployment is complete you should see a public endpoint displayed at the end. Navigating to this public endpoint should show you your application that is accessed via HTTPS, assuming that you have a valid TLS certificate:

{{< image src="https-app.png" alt="View TLS certificate" width="400px" >}}

## Done

You've successfully deployed an application with TLS termination. Make sure to cleanup your resources:

```bash
rad app delete tlsdemo -y
```

## Further reading

- [Networking overview]({{< ref "/guides/author-apps/networking/overview" >}})
- [Gateway reference]({{< ref "/reference/resource-schema/core-schema/gateway" >}})

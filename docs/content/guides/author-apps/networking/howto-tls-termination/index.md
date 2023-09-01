---
type: docs
title: "How To: TLS termination with your own TLS certificate"
linkTitle: "How-To: TLS with a custom certificate"
description: "Learn about how to use Radius to deploy HTTPS-enabled application with a TLS certificate" 
weight: 800
slug: 'tls-termination'
categories: "How-To"
tags: ["https"]
---

This guide will show you:

- How to model and use Secret Stores for a bring-your-own certificate scenario
- How to model and use Gateways for a Radius Gateway TLS termination scenario.

## Prerequisites

- [rad CLI]({{< ref getting-started >}})
- [Supported Kubernetes cluster]({{< ref kubernetes-install >}})

## Step 1: Initialize a Radius environment

Begin by running `rad init` to initialize Radius and create an environment:

```sh
rad init
```

## Step 2: Define an Application, Secret Store, and Gateway

Begin by creating a file named `app.bicep`. You can either provide the certificate data directly in the Bicep file, or reference an existing Kubernetes secret with your certificate data.

{{< tabs "Certificate Data" "Kubernetes Secret" >}}

{{% codetab %}}

{{< rad file="snippets/tls-termination-data.bicep" embed=true >}}

{{% /codetab %}}

{{% codetab %}}

{{< rad file="snippets/tls-termination-k8s-secret.bicep" embed=true >}}

{{% /codetab %}}

{{< /tabs >}}

## Step 3: Deploy the application

```sh
rad deploy app.bicep -p tlscrt=<base64-encoded TLS certificate> -p tlskey=<base64-encoded TLS certificate private key>
```

Once the deployment is complete, you should see a public endpoint displayed at the end. Navigating to this public endpoint should show you your application that is accessed via HTTPS, assuming that you have a valid TLS certificate.

<img src="https-app.png" alt="View TLS certificate" width=700 />

---
type: docs
title: "How To: TLS termination with cert-manager and Let's Encrypt"
linkTitle: "TLS termination with cert-manager"
description: "Learn about how to use Radius to deploy HTTPS-enabled application with a TLS certificate" 
weight: 900
slug: 'tls-termination-cert-manager'
categories: "How-To"
tags: ["https"]
---

This guide will show you:

- How to integrate Radius with cert-manager and Let's Encrypt in order to enable HTTPS for your app

## Prerequisites

- [rad CLI]({{< ref getting-started >}})
- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/)

## Step 1: Initialize a Radius environment

Begin by running `rad install kubernetes` and `rad init`. This will tell Radius which domain name your application will be accessed by.

```sh
rad init
```


## Step 2: Set up domain

1. Run the following command and copy the EXTERNAL-IP field:

```sh
$ kubectl get svc -n radius-system contour-envoy
NAME            TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)                      AGE
contour-envoy   LoadBalancer   10.0.10.1     <EXTERNAL-IP>  80:31734/TCP,443:32517/TCP   67m
```

1. Configure DNS server to set A record for your domain name and external IP address.

```
YOUR_DOMAIN A <EXTERNAL-IP>
```

## Step 3: Install cert-manager

Next, run the following command to install [cert-manager](https://cert-manager.io/):

```sh
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
```

> You can find the other method, such as helm, to install cert-manager [here](https://cert-manager.io/docs/installation/#getting-started).

## Step 4: Set up HTTP-01 Challenge

To use Let's encrypt, you need to configure [ACME Issuer](https://cert-manager.io/docs/configuration/acme/) using cert-manager. This how-to uses [HTTP-01 Challenge](https://cert-manager.io/docs/configuration/acme/http01/) to verify that a client owns a domain.

Here is what your HTTP-01 ACME ClusterIssuer resource should look like:

{{< rad file="snippets/clusterissuer-http01.yaml" embed=true >}}

> Note that this guide shows how to set up a certificate using Let's Encrypt prod. For testing purposes, you can change this to the [staging endpoint](https://letsencrypt.org/docs/staging-environment/).


## Step 5: Create Certificate resource

Create a file `certificate.yaml` with the following data, replacing the placeholders as necessary:

{{< rad file="snippets/certificate.yaml" embed=true >}}

Then create `tls-delegation.yaml` with the following data.

{{< rad file="snippets/delegation.yaml" embed=true >}}

Run the following commands to create the certificate resource and authorize Radius to access the resource:

```sh
kubectl apply -f certificate.yaml
kubectl apply -f tls-delegation.yaml
```

You may need to wait a minute or two for cert-manager to authorize with Let's Encrypt and create the secret on the cluster. Once this process completes, you should see a secret called `demo-secret` in the default namespace. This secret is managed by cert-manager.


## Step 6: Define the Radius application

Create a file named `app.bicep`. Here, we reference the `demo-secret` and reference the Secret Store in the Gateway to enable TLS termination.

{{< rad file="snippets/app.bicep" embed=true >}}


## Step 7: Deploy the application

```sh
rad deploy app.bicep
```

Once the deployment is complete, you should see a public endpoint displayed at the end. Navigating to this public endpoint should show you your application that is accessed via HTTPS and has a Let's Encrypt certificate enable TLS Termination on the Radius Gateway.

<img src="https-app.png" alt="View TLS certificate." width=700 />

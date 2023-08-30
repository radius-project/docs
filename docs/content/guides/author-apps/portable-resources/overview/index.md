---
type: docs
title: "Overview: Portable Resources"
linkTitle: "Overview"
description: "Add portable resources to your Radius application for infrastructure portability"
weight: 600
categories: "Overview"
tags: ["portability"]
---

## Overview

Portable resources provide **abstraction** and **portability** to Radius applications. This allows development teams to depend on high level resource types and APIs, and let infra teams swap out the underlying resource and configuration.

<img src="links.png" alt="Diagram of a resource connecting from a container to either an Azure Redis Cache or a Kubernetes Deployment" width=700px />

### Example

The following examples show how a [container]({{< ref "guides/author-apps/containers" >}}) can connect to a Redis cache, which in turn binds to an Azure Cache for Redis or a Kubernetes Pod.

{{< tabs Kubernetes Azure >}}

{{< codetab >}}
<h4>Underlying resource</h4>

In this example Redis is provided by a Kubernetes Pod:

{{< rad file="snippets/redis-container.bicep" embed=true marker="//RESOURCE" >}}

<h4>Portable Resource</h4>

A Redis cache can be configured with properties from the Kubernetes Pod:

{{< rad file="snippets/redis-container.bicep" embed=true marker="//PORTABLERESOURCE" >}}

{{< /codetab >}}

{{< codetab >}}
<h4>Underlying resource</h4>

In this example Redis is provided by an Azure Cache for Redis:

{{< rad file="snippets/redis-azure.bicep" embed=true marker="//RESOURCE" >}}

<h4>Portable Resource</h4>

A Redis cache can be configured with an Azure resource:

{{< rad file="snippets/redis-azure.bicep" embed=true marker="//PORTABLERESOURCE" >}}

{{< /codetab >}}

{{< /tabs >}}

<h4>Container</h4>

A container can connect to the Redis cache without any configuration or knowledge of the underlying resource:

{{< rad file="snippets/redis-azure.bicep" embed=true marker="//CONTAINER" >}}
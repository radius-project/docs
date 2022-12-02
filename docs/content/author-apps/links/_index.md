---
type: docs
title: "Radius Links"
linkTitle: "Links"
description: "Add cross-platform links to your Radius application with Links"
weight: 300
---

## Overview

Links provide **abstraction** and **portability** to Radius applications. This allows development teams to depend on high level resource types and APIs, and let infra teams swap out the underlying resource and configuration.

<img src="links.png" alt="Diagram of a link connecting from a container to either an Azure Redis Cache or a Kubernetes Deployment" width=700px />

### Example

The following examples show how a [container]({{< ref container >}}) can connect to a Redis link, which in turn binds to an Azure Cache for Redis or a Kubernetes Pod.

{{< tabs Kubernetes Azure >}}

{{< codetab >}}
<h4>Underlying resource</h4>

In this example Redis is provided by a Kubernetes Pod:

{{< rad file="snippets/redis-container.bicep" embed=true marker="//RESOURCE" >}}

<h4>Link</h4>

A Redis link can be configured with properties from the Kubernetes Pod:

{{< rad file="snippets/redis-container.bicep" embed=true marker="//LINK" >}}

{{< /codetab >}}

{{< codetab >}}
<h4>Underlying resource</h4>

In this example Redis is provided by an Azure Cache for Redis:

{{< rad file="snippets/redis-azure.bicep" embed=true marker="//RESOURCE" >}}

<h4>Link</h4>

A Redis link can be configured with an Azure resource:

{{< rad file="snippets/redis-azure.bicep" embed=true marker="//LINK" >}}

{{< /codetab >}}

{{< /tabs >}}

<h4>Container</h4>

A container can connect to the Redis link without any configuration or knowledge of the underlying resource:

{{< rad file="snippets/redis-azure.bicep" embed=true marker="//CONTAINER" >}}

## Link categories

Check out the Radius link resource schema docs to learn how to leverage links in your application:

{{< button text="Link resources" page="link-schema" >}}

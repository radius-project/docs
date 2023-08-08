---
type: docs
title: "Overview: Application networking"
linkTitle: "Application networking"
description: "Learn how to add networking to your Radius application"
weight: 100
categories: "Overview"
tags: ["routes","gateways"]
---

Radius networking resources allow you to model:

- Communication between a user and a service
- Communication between services

## DNS Service Discovery

`DNS Service Discovery`, or `DNS-SD`, is another way of defining HTTP communication between two [services]({{< ref container >}}). It can define one-way and cycles of communication between services. `DNS-SD` differs from `HttpRoute` by not having to define an intermediary resource for connection.

<img src="dns-connection.png" style="width:600px" alt="Diagram of Radius service-to-service networking DNS service discovery" /><br />

A gateway can optionally be added for external users to access the service.

## HTTP Routes (advanced)

An `HttpRoute` resources defines HTTP communication between two [services]({{< ref container >}}). They can be used to define both one-way communication, as well as cycles of communication between services.

<img src="networking-cycles.png" style="width:400px" alt="Diagram of Radius service-to-service networking with cycles" /><br />

Refer to the [HTTP Route schema]({{< ref httproute >}}) for more information on how to model HTTP routes.

A gateway can optionally be added for external users to access the Route.

## Gateways

`Gateway` defines how requests are routed to different resources, and also provides the ability to expose traffic to the internet. Conceptually, gateways allow you to have a single point of entry for  traffic in your application, whether it be internal or external traffic.

`Gateway` in Radius are split into two main pieces; the `Gateway` resource itself, which defines which port and protocol to listen on, and Route(s) which define the rules for routing traffic to different resources. Both `DNS-SD` and `HttpRoute` are supported by `Gateway`.

<img src="networking-gateways.png" style="width:600px" alt="Diagram of Radius gateways" /><br />

Refer to the [Gateway schema]({{< ref gateway >}}) for more information on how to model gateways.

### TLS Termination

Gateways support TLS termination. This allows incoming encrypted traffic to be decrypted with a user-specific certificate and then routed, unencrypted, to the specified routes. TLS certificates can be stored or referenced via a [Radius secret store]({{< ref secretstore >}}).

### SSL Passthrough

A gateway can be configured to passthrough encrypted SSL traffic to an HTTP route and container. This is useful for applications that already have SSL termination configured, and do not want to terminate SSL at the gateway.

To set up SSL passthrough, set `tls.sslPassthrough` to `true` on the gateway, and set a single route with no `path` defined (just `destination`).

## Example

### DNS-SD routing

{{< tabs Bicep >}}

{{< codetab >}}
{{< rad file="snippets/dns-networking.bicep" embed=true >}}
{{< /codetab >}}

{{< /tabs >}}

### Path-based HTTP routing

{{< tabs Bicep >}}

{{< codetab >}}
{{< rad file="snippets/networking.bicep" embed=true >}}
{{< /codetab >}}

{{< /tabs >}}

### TLS termination

{{< tabs Bicep >}}

{{< codetab >}}
{{< rad file="snippets/networking-tlstermination.bicep" embed=true marker="//GATEWAY" >}}
{{< /codetab >}}

{{< /tabs >}}

### SSL Passthrough

{{< tabs Bicep >}}

{{< codetab >}}
{{< rad file="snippets/networking-sslpassthrough.bicep" embed=true marker="//GATEWAY" >}}
{{< /codetab >}}

{{< /tabs >}}

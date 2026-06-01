---
type: docs
title: "Overview: Application networking"
linkTitle: "Overview"
description: "Learn how to add networking to your Radius Application"
weight: 100
categories: "Overview"
---

Radius networking resources allow you to model:

- Communication between services
- Communication between a user and a service

{{< image src="networking.png" alt="Diagram of a gateway with traffic going to a frontend container, which in turn sends traffic to the basket and catalog containers" width="400px" >}}

## Service to service communication

Radius containers can define connections to other containers, just like they can define connections to dependencies.

Network connections are defined as strings containing:

- The **scheme** (protocol) of the connection _(http, https, tcp, etc.)_
- The **target** container/service to connect to _(basket, catalog, etc.)_
- The **port** to connect to _(80, 443, etc.)_

For example, a frontend container may need to connect to a basket container. The frontend container would define a connection to the basket container, with the scheme `http`, the target `basket`, and the port `3000`. The connection would look like this: `http://basket:3000`.

{{< image src="network-connection.png" alt="Diagram showing the components of a network connection" width="400px" >}}

For more information on how to do service to service networking, visit the [service networking how-to guide]({{< ref howto-service-networking >}}):

{{< button text="How-To: Service to service networking" page="howto-service-networking" >}}

## Gateways

A `gateway` defines how requests are routed to different resources, and also provides the ability to expose traffic to the internet. Conceptually, gateways allow you to have a single point of entry for traffic in your application, whether it be internal or external.

Refer to the [Gateway schema]({{< ref gateway >}}) for more information on how to model gateways.

### TLS Termination

Gateways support TLS termination. This allows incoming encrypted traffic to be decrypted with a user-specific certificate and then routed, unencrypted, to the specified routes. TLS certificates can be stored or referenced via a [Radius secret store]({{< ref secretstore >}}).

### SSL Passthrough

A gateway can be configured to passthrough encrypted SSL traffic to an HTTP route and container. This is useful for applications that already have SSL termination configured, and do not want to terminate SSL at the gateway.

To set up SSL passthrough, set `tls.sslPassthrough` to `true` on the gateway, and set a single route with no `path` defined (just `destination`).

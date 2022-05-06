---
type: docs
title: "Networking resources for Radius applications"
linkTitle: "Networking"
description: "Learn how to add networking to your Radius application"
weight: 300
---

## HTTP Routes

An `HttpRoute` resources defines HTTP communication between two [services]({{< ref services >}}).

A gateway can optionally be added for external users to access the Route.

{{< button page="httproute" text="Learn more" >}}

## Gateways

`Gateway` defines how requests are routed to different resources, and also provides the ability to expose traffic to the internet. Conceptually, gateways allow you to have a single point of entry for  traffic in your application, whether it be internal or external traffic.

`Gateway` in Radius are split into two main pieces; the `Gateway` resource itself, which defines which port and protocol to listen on, and Route(s) which define the rules for routing traffic to different resources.

{{< button page="gateway" text="Learn more" >}}
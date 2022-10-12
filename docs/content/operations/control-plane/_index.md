---
type: docs
title: "Control plane"
linkTitle: "Control plane"
description: "Configure and manage your Radius control plane"
weight: 20
no_list: true
---

The Radius control plane is the central management system for your Radius applications and deployments. It is responsible for managing the lifecycle of your applications, including deploying, updating, and deleting them.

View the [control plane architecture]({{< ref architecture >}}) to learn more about how the control plane works.

## Configuration

{{< cardpane width=500px >}}
  {{< card header="[**Resource groups**]({{< ref groups >}})" footer="Manage collections of resources with resource groups" >}}
  [<img src="./groups/group.svg" alt="Resource group icon" width=100% />]({{< ref groups >}})
  {{< /card >}}
  {{< card header="[**Cloud provider**]({{< ref providers >}})" footer="Deploy across clouds and platforms with Radius cloud providers" >}}
  [<img src="./providers/provider.svg" alt="Cloud provider icon" width=100% />]({{< ref providers >}})
  {{< /card >}}
{{< /cardpane >}}

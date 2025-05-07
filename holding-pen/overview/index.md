---
type: docs
title: "Overview: Custom resource types"
linkTitle: "Overview"
description: "Learn how to model and deploy your own resource types in Radius"
weight: 100
---

When you have a need for types beyond those currently built into Radius, you can model and deploy your own resource types. Currently, Radius supports an untyped "extender" resource which allows you to pass in any property or secret.

## Extenders

Extenders are a special type of resource that allows you to pass in any property or secret. This is useful for modeling resources that aren't natively supported by Radius.

[Recipes]({{< ref "/guides/recipes/overview" >}}) can be used with extenders to manage the backing infrastructure.

Refer to the [How-To: Extenders guide]({{< ref howto-extenders >}}) for more information on how to use an extender.

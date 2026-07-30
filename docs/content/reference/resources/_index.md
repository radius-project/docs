---
type: docs
title: "Resource Types"
linkTitle: "Resource Types"
description: "Schema reference for built-in Resource Types"
weight: 200
---

## Introduction

Resource Types define the schema for the resources developers use to model their applications—the properties you can configure, the values Radius returns, and the API versions each type supports. For a deeper explanation of what Resource Types are and how they abstract the underlying infrastructure, see the [Resource Types concepts]({{< ref "concepts/resource-types" >}}) page.

`Radius.Core` Resource Types are embedded in the Radius control plane. All other Resource Types are sourced from the [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) repository.

All of the schema information on these pages is also available directly from your environment using [`rad resource-type list`]({{< ref rad_resource-type_list >}}) and [`rad resource-type show`]({{< ref rad_resource-type_show >}}), as well as through the [Radius Dashboard]({{< ref "/installation/dashboard" >}}).

## How this section is organized

Resource Types are organized first by namespace (such as `Radius.Core`, `Radius.Compute`, and `Radius.Data`) and then by API version (for example, `2025-08-01-preview`). Open a Resource Type to view its schema reference, which documents the resource's properties, including which fields are required and read-only.


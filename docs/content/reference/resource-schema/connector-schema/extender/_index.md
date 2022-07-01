---
type: docs
title: "Extender resource"
linkTitle: "Extender"
description: "Learn how to use Extender resource in Radius"
weight: 100
slug: "extender"
toc_hide: true
hide_summary: true
---

## Overview

An extender resource could be used to bring in a custom resource into Radius for which there is no first class support to "extend" the Radius functionality. The resource can define arbitrary key-value pairs and secrets. These properties and secret values can then be used to connect it to other Radius resources.

{{< rad file="snippets/extender.bicep" embed=true >}}

| Property | Description | Example |
|----------|-------------|---------|
| \<user-defined key-value pairs\> | User-defined properties of the extender. Can accept any key name except 'secrets'. | `fromNumber: '222-222-2222'`
| secrets | Secrets in the form of key-value pairs

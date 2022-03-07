---
type: docs
title: "Extender resource"
linkTitle: "Extender"
description: "Learn how to use Extender resource in Radius"
weight: 999
slug: "extender"
---

## Overview

An extender resource could be used to bring in a custom resource into Radius for which there is no first class support to "extend" the Radius functionality. The resource can define arbitrary key-value pairs and secrets. These properties and secret values can then be used to connect it to other Radius resources.

{{< rad file="snippets/extender.bicep" embed=true >}}

| Property | Description | Example |
|----------|-------------|---------|
| properties | Properties of the extender | Could be any key-value pairs
| secrets | Secrets in the form of key-value pairs

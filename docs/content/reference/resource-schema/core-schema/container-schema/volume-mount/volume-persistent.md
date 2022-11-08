---
type: docs
title: "Persistent volumes"
linkTitle: "Persistent"
description: "Learn about Radius persistent volumes"
weight: 201
slug: "persistent"
---

Persistent volumes have lifecycles that are separate from the container. Containers can mount these persistent volumes and restart without losing data. Persistent volumes can also be useful for storing data that needs to be accessed by multiple containers.

## Persistent volumes

A persistent volume can be mounted to a container by specifying the following `volumes` properties within the container definition:

{{< rad file="snippets/volume-persistent.bicep" embed=true marker="//EXAMPLE" replace-key-volume="//VOLUME" replace-value-volume="resource volume 'Applications.Core/volumes@2022-03-15-privatepreview' = {...}" >}}

## Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | A name key for the volume. | `tempstore`
| kind | y | The type of volume, either `ephemeral` or `persistent` | `persistent`
| mountPath | y | The container path to mount the volume to. | `\var\mystore`
| source | y | The resource id of the resource providing the volume. | `keyvault.id`
| rbac | n | The role-based access control level for the file share. Allowed values are `'read'` and `'write'`. | `'read'`

## Supported volumes

Refer to the [volume reference docs]({{< ref volumes >}}) to learn what volumes are supported.

{{< button page="volumes" text="Supported volumes" >}}

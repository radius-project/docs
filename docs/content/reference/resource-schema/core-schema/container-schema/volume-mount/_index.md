---
type: docs
title: "Mount a volume to a container"
linkTitle: "Volume mounts"
description: "Learn how to mount a volume to a container"
weight: 100
slug: "volumes"
---

Containers can mount volumes to store data. Ephemeral volumes are created and destroyed with the container. Persistent volumes have lifecycles that are separate from the container. Containers can mount these persistent volumes and restart without losing data. Persistent volumes can also be useful for storing data that needs to be accessed by multiple containers.

## Volume types

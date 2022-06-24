---
type: docs
title: "Known issues with the latest Radius release"
linkTitle: "Known issues"
description: "Learn where there are known issues with the latest Radius release and how to workaround them"
weight: 998
---

## Radius environments require Owner rights on the subscription
Creating Radius environments on Azure currently **require you to have *Owner* rights on your subscription.** (This is a current limitation that will be resolved once we've built our Azure Service.)  
   If you use a service principal for CLI authentication, ensure it also has the proper RBAC assignment on your subscription.

## Application names with capitol letters fail

Applications can currently only have lower-case letters in their names. This is being resolved with the move from custom resource provider to a full resource provider.

### Workaround

Make sure your application names only contain lower-case letters.

---
type: docs
title: "How-To: Manage resource groups"
linkTitle: "Manage resource groups"
description: "Learn how to manage resource groups in Radius"
weight: 200
---

This guide will walk you through the process of managing resource groups in Radius. For more information on resource groups, see [Resource groups]({{< ref groups >}}).

## Pre-requisites

- [Supported Kubernetes cluster]({{< ref supported-clusters >}})
- [Radius CLI]({{< ref howto-rad-cli >}})

## Step 1: Ensure Radius is installed

Begin by making sure that Radius is installed on your Kubernetes cluster:

```bash
rad install kubernetes
```

## Step 2: Create a resource group

Use [`rad group create`]({{< ref rad_group_create >}}) to create a resource group:

```bash
rad group create myGroup
```

You should see:

```
creating resource group "myGroup" in namespace "default"...

resource group "myGroup" created
```

## Step 3: Set a resource group as the default

Run [`rad group switch`]({{< ref rad_group_switch >}}) to set a resource group as the default:

```bash
rad group switch myGroup
```

## Step 4: View the current resource group

Run [`rad group show`]({{< ref rad_group_show >}}) to view the current resource group:

```bash
rad group show myGroup
```

You should see:

```
ID                                            NAME                
/planes/radius/local/resourcegroups/myGroup   myGroup
```

You can use the `-o json` flag to view more information about the resource group:

```bash
rad group show -o json
```

You should see:

```
{
    "id": "/planes/radius/local/resourcegroups/myGroup",
    "location": "global",
    "name": "myGroup",
    "tags": {},
    "type": "System.Resources/resourceGroups",
}
```

## Step 5: Delete a resource group

Run [`rad group delete`]({{< ref rad_group_delete >}}) to delete a resource group:

```bash
rad group delete myGroup
```

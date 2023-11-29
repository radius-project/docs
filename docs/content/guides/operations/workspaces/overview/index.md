---
type: docs
title: "Overview: Radius workspaces"
linkTitle: "Overview"
description: "Learn how to handle multiple Radius platforms and environments with workspaces"
weight: 200
categories: "Overview"
---

Workspaces allow you to manage multiple Radius platforms and environments using a local configuration file. You can easily define and switch between workspaces to deploy and manage applications across separate environments.

{{< image src=workspaces.png alt="Diagram showing a Radius configuration file mapping workspaces to Kubernetes clusters" width=800px >}}

## CLI commands

The following commands let you interact with Radius Environments:

{{< tabs create list show delete switch >}}

{{% codetab %}}
[rad workspace init kubernetes]({{< ref rad_workspace_create >}}) creates a new workspace:

```bash
rad workspace init kubernetes
```

{{% /codetab %}}

{{% codetab %}}
[rad workspace list]({{< ref rad_workspace_list >}}) lists all of the workspaces in your configuration file:

```bash
rad workspace list
```

{{% /codetab %}}

{{% codetab %}}
[rad workspace show]({{< ref rad_workspace_show >}}) prints information on the default or specified workspace:

```bash
rad workspace show
```

{{% /codetab %}}

{{% codetab %}}
[rad workspace delete]({{< ref rad_workspace_delete >}}) deletes the specified workspace:

```bash
rad workspace delete -w myenv
```

{{% /codetab %}}

{{% codetab %}}
[rad workspace switch]({{< ref rad_workspace_switch >}}) switches the default workspace:

```bash
rad env switch -e myenv
```

{{% /codetab %}}

{{< /tabs >}}

## Example

Your Radius configuration file contains workspace entries that point to a Radius platform and environment:

```yaml
workspaces:
  default: dev
  items:
    dev:
      connection:
        context: DevCluster
        kind: kubernetes
      environment: /planes/radius/local/resourcegroups/dev/providers/applications.core/environments/dev
      scope: /planes/radius/local/resourceGroups/dev
      providerConfig:
        azure:
          subscriptionid: DEV-SUBID
          resourcegroup: Dev
    prod:
      connection:
        context: ProdCluster
        kind: kubernetes
      environment: /planes/radius/local/resourcegroups/prod/providers/applications.core/environments/prod
      scope: /planes/radius/local/resourceGroups/prod
      providerConfig:
        azure:
          subscriptionid: PROD-SUBID
          resourcegroup: Prod
```

## Schema

Visit the [`config.yaml` reference docs]({{< ref config >}}) to learn about workspace definitions.

{{< button text="config.yaml Schema" page="config" >}}

---
type: docs
title: "App concept"
linkTitle: "App concept"
description: "Learn about the Radius Application concept"
weight: 100
---
<!-- TODO retire this page. move this topic's fresh content to either Concepts.Overview or Concepts.Architecture. -->


## Definition

The Radius Application contains everything on an app diagram. That includes all the compute, data, and infrastructure. 

<!-- TODO: expand this diagram to include more about the infra layer -->
{{< imgproc radius-application Fit "700x500">}}
<i>A Radius Application encompases all the containers, databases, and APIs for an app.</i>
{{< /imgproc >}}

## Authoring an Application

An application is defined as a top-level `resource app` in a .bicep file: 
{{< rad file="snippets/blank-app.bicep" embed=true >}}

Currently, this example app is an empty shell and has no child resources defined.

It's up to the user to define what they consider part of the app. Users can include both services (containers) and infrastructure resources (databases, caches, etc.). 

In some cases, an Ops team may create a Radius environment and prepare it with portable Radius [Connector]({{< ref connectors >}}) resources that a separate Dev team can connect to from their `resource app`. 

Learn more about how to author applications: [Concepts for Authoring Apps]({{< ref authoring-concepts >}}). 

<!-- TODO: high-level overview of managing an app -->

## Next

{{< button text="Radius Resources" page="resources-model.md" >}}

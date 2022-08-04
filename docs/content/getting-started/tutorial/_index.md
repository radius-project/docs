---
type: docs
title: "Tutorial for Project Radius"
linkTitle: "Tutorial"
description: "Walk through an in-depth example to learn more about how to work with Radius concepts"
weight: 100
no_list: true
---

## Overview

This tutorial will teach you how to deploy a website as a Radius application from first principles. You will take away the following

- Enough knowledge to map your own application in Radius
- Achieve portability via connectors between your local and cloud environments
- Understand the separation of concerns for the different personas involved in a deployment

## Tutorial steps

This tutorial contains the following sections:

- App overview - Overview of the website tutorial application
- Author app definition - Define the application definition with container, gateway and http routes
- Add a database connector - Connect a MongoDB to the website tutorial application using a connector and deploy to a Radius environment
- Swap a connector resource - Swap a MongoDB container for an Azure CosmosDB instance to back the connector and deploy the app to a Radius environment with Azure cloud provider configured

## Prerequisites

{{% alert title="💡 Github Code Spaces" color="success" %}} You can skip this section if you are using [Github codespaces]({{< ref "getting-started#try-out-radius-on-github-codespaces">}})  to try out the tutorial. The dev containers have all the pre-requisites installed and environment initialized.
{{% /alert %}}

- [Install Radius CLI]({{< ref "getting-started#install-rad-cli" >}})
- [Install kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- Set up a Kubernetes Cluster. Visit the [Kubernetes documentation]({{< ref "kubernetes#supported-clusters" >}}) for a list of supported clusters
- [Azure subscription](https://azure.com) (optional - used in last tutorial step to deploy Azure resources)

<br>{{< button text="Next step: App overview" page="webapp-overview" >}}

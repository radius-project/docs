---
type: docs
title: "How-To: Deploying applications into a Radius environment"
linkTitle: "Deploy via CLI"
description: "Learn how to deploy a Radius application"
weight: 200
categories: "How-To"
tags: ["deployments"]
---

## Pre-requisites 
- [An authored Radius application]({{< ref author-apps >}})

## Step 1 : Deploy an application into a Radius environment

{{< tabs Deploy-app Deploy-app-with-parameters >}}

{{% codetab %}}
An application can be deployed to an environment with [`rad deploy`]({{< ref rad_deploy>}}):

```bash
 rad deploy app.bicep
 ```
 This will deploy the application to the created Radius environment.
 {{% /codetab %}}

 {{% codetab %}}
Parameters can be included as part of `rad deploy` via the `-p/--parameters` flag:

```bash
 rad deploy app.bicep -p param1=value1 -p param2=value2
 ```

 This will deploy the application to the created Radius environment injecting the parameters into the application.

 You can find more examples of deploying applications with parameters [here]({{< ref "rad_deploy#examples" >}}).
 {{% /codetab %}}

 {{< /tabs >}}

 > Follow the [how-to guide]({{< ref howto-troubleshootapps >}}) for guidance on troubleshooting your Radius application


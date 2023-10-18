---
type: docs
title: "How-To: Run applications on Radius"
linkTitle: "Run apps"
description: "Learn how to run applications on Radius"
weight: 100
categories: "How-To"
tags: ["deployments"]
---

## Pre-requisites 
- [An authored Radius Application]({{< ref author-apps >}})

## Step 1: Run an application

{{< tabs Run-app Run-app-with-parameters >}}

{{% codetab %}}
You can run an application using the [`rad run`]({{< ref rad_run >}}) command.

```bash
 rad run app.bicep
 ```

This will deploy the application to your environment, create port-forwards for all container ports, and stream container logs to the console.
{{% /codetab %}}

{{% codetab %}}
Parameters can be included as part of `rad run` via the `-p/--parameters` flag:

```bash
 rad run app.bicep -p param1=value1 -p param2=value2
```

This will deploy the application to the created Radius Environment injecting the parameters into the application.

You can find more examples of deploying applications with parameters [here]({{< ref "rad_run#examples" >}}).
{{% /codetab %}}

 {{< /tabs >}}

 > Follow the [how-to guide]({{< ref howto-troubleshootapps >}}) for guidance on troubleshooting your apps

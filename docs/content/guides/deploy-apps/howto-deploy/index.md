---
type: docs
title: "Overview: Deploying applications into a Radius environment"
linkTitle: "Deploy apps"
description: "Learn how to deploy a Radius application"
weight: 300
categories: "Overview"
tags: ["deployments"]
---

## Run an application

Once you have [authored an application]({{< ref author-apps >}}), you can run an application using the [`rad run`]({{< ref rad_run >}}) command.

```bash
 rad run app.bicep
 ```

This will deploy the application to your environment, create port-forwards for all container ports, and stream container logs to the console.

## Deploy an application

An application can be deployed to an environment with [`rad deploy`]({{< ref rad_deploy>}}):

```bash
 rad deploy app.bicep
 ```
 This will deploy the application to the created Radius environment.

### Parameters

Parameters can be included as part of `rad run` or `rad deploy` via the `-p/--parameters` flag:

```bash
 rad deploy app.bicep -p param1=value1 -p param2=value2
 ```

 This will deploy the application to the created Radius environment injecting the parameters into the application.

 You can find more examples of deploying applications with parameters [here]({{< ref "rad_deploy#examples" >}}).
 

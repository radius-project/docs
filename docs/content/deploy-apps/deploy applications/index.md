---
type: docs
title: "Deploy applications"
linkTitle: "Deploy applications"
description: "Learn how to deploy a Radius application"
weight: 200
categories: "Overview"
tags: ["deployments"]
---

## Deploying applications

Once you have authored an application, you can deploy it to an environment via rad CLI using the [`rad deploy`]({{< ref rad_deploy>}})

```bash
 rad deploy app.bicep
 ```
 This will deploy the application to the created Radius environment.

## Deploying applications with parameters 

You can also deploy an application with parameters using the [`rad deploy`]({{< ref rad_deploy>}}) command. 

```bash
 rad deploy app.bicep -p param1=value1 -p param2=value2
 ```

 This will deploy the application to the created Radius environment injecting the parameters into the application.

## Running an application locally

You can run an application locally using the `rad run` command. 

```bash
 rad run app.bicep
 ```

 This will run your application locally by creating a port-forward from localhost to the port in the container and streams the logs to the console
---
type: docs
title: "Overview: Deploying applications into a radius environment"
linkTitle: "Deploy applications"
description: "Learn how to deploy a Radius application"
weight: 200
categories: "Overview"
tags: ["deployments"]
---

## Deploy a Radius applications

Once you have authored an application, you can deploy it to an environment via rad CLI using the [`rad deploy`]({{< ref rad_deploy>}})

```bash
 rad deploy app.bicep
 ```
 This will deploy the application to the created Radius environment.

 Example output:

   ```
   Building ./app.bicep...
   Deploying template './app.bicep' for application 'webapp' and environment 'default' from workspace 'default'...

   Deployment In Progress... 

   Completed            webapp          Applications.Core/applications
   Completed            db              Applications.Link/redisCaches
   Completed            frontend        Applications.Core/containers

   Deployment Complete

   Resources:
      webapp          Applications.Core/applications
      frontend        Applications.Core/containers
      db              Applications.Link/redisCaches
   ```

### Deploying applications with parameters (optional)

You can also deploy an application with parameters using the [`rad deploy`]({{< ref rad_deploy>}}) command. 

```bash
 rad deploy app.bicep -p param1=value1 -p param2=value2
 ```

 This will deploy the application to the created Radius environment injecting the parameters into the application.


## Run an application

You can run an application locally using the `rad run` command. 

```bash
 rad run app.bicep
 ```

 This will run your application locally by creating a port-forward from localhost to the port in the container and streams the logs to the console
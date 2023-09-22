---
type: docs
title: "How-To: Troubleshoot applications"
linkTitle: "Troubleshoot apps"
description: "Learn how to troubleshoot issues with the Radius application"
weight: 900
categories: "How-To"
tags: ["troubleshooting"]
---

## Pre-requisites

- A [deployed application]({{< ref deploy-apps >}}) in a Radius environment.

## Step 1: Port-forward container to your local machine

Use the below command to port-forward the container to your local machine. This enables you to access the container from your local machine.

```bash
rad resource expose containers <container_name> -a <app_name> --port <port_number>
```
Refer to [`rad resource expose`]({{< ref rad_resource_expose >}}) for more details on the command.

## Step 2: Inspect container logs

If your Radius application is unresponsive or does not connect to its dependencies, Use the below command to inspect logs from container:

```bash
rad resource logs containers frontend -a <app_name>
```

## Step 3: Inspect environment variables

Check if the environment variables are properly set in your container and if the container is able to connect to the dependencies. Use the below command to list all the env variables set on your container pod:

``` bash
kubectl exec -n <namespace_name> <pod_name> -- printenv
```

Your output should look something like below:

```
....
CONNECTION_REDIS_PORT=6379
CONNECTION_REDIS_URL=redis://redis-pnjdlzgljrt74.default-application.svc.cluster.local:6379/0?
CONNECTION_REDIS_CONNECTIONSTRING=redis-pnjdlzgljrt74.default-application.svc.cluster.local:6379,abortConnect=False
CONNECTION_REDIS_HOST=redis-pnjdlzgljrt74.default-application.svc.cluster.local
....
```

Also refer to the [connections section]({{< ref "guides/author-apps/containers/overview#connections" >}}) to know more about the naming convention and the environment variables that are set for each connection.

## Step 4: Inspect control-plane logs

If you hit errors while deploying the application, look at the control plane logs to see if there are any errors. You can use the following command to view the logs:

```bash
rad debug-logs
```
Inspect the UCP and DE logs to see if there are any errors  

>Also make sure to [open an Issue](https://github.com/radius-project/radius/issues/new/choose) if you encounter a generic `Internal server error` message or an error message that is not self-serviceable, so we can address the root error not being forwarded to the user.

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

A [deployed application]({{< ref deploy-apps >}}) in a Radius environment.

## Step 1: Port-forward container to your local machine

Use the below command to port-forward the container to your local machine. This enables you to access the container from your local machine.

```bash
rad resource expose containers <container_name> -a <app_name> --port <port_number>
```

## Step 2: Inspect container logs

If your Radius application is unresponsive or does not connect to its dependencies, Use the below command to inspect logs from container:

    ```bash
    rad resource logs containers frontend -a <app_name>
    ```

## Step 3: Inspect environment variables

Check if the environment variables are properly set in your container and if the container is able to connect to the dependencies.

Refer to the [connections section]({{< ref "guides/author-apps/containers/overview#connections" >}}) to know the naming convention and the environment variables that are set for each connection.

## Step 4: Inspect control-plane logs

If you hit errors while deploying the application, look at the control plane logs to see if there are any errors. You can use the following command to view the logs:

     ```bash
     rad debug-logs
     ```
Inspect the UCP and DE logs to see if there are any errors  

>Also please make sure to [open an Issue](https://github.com/radius-project/radius/issues/new?assignees=&labels=kind%2Fbug&template=bug.md&title=%3CBUG+TITLE%3E) if you encounter a generic `Internal server error` message or an error message that is not self-serviceable, so we can address the root error not being forwarded to the user.

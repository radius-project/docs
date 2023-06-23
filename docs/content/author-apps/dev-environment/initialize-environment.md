---
type: docs
title: "How-To: Setup a development environment"
linkTitle: "Developer environments"
description: "Learn how to initialize a new Radius environment"
weight: 200
categories: "How-To"
tags: ["environments"]
---

## Pre-requisites

1. Have a [Kubernetes cluster]({{< ref "/operations/platforms/kubernetes" >}}) handy.

   *Visit the [Kubernetes platform docs]({{< ref "/operations/platforms/kubernetes" >}}) for a list of supported clusters and specific cluster requirements.*

1. Ensure your target kubectl context is set as the default:
   ```bash
   kubectl config current-context
   ```

## How-to: Initialize a new dev environment

1. Initialize a new [Radius environment]{{(< ref "operations/environments">)}} with `rad init --dev` command:
   ```bash
   rad init --dev
   ```
2. Verify the initialization by running:
   ```bash
   kubectl get deployments -n radius-system
   ```

   You should see:

   ```
   NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
   ucp                       1/1     1            1           53s
   appcore-rp                1/1     1            1           53s
   bicep-de                  1/1     1            1           53s
   contour-contour           1/1     1            1           46s
   ```

   You can also use [`rad env list`]({{< ref rad_env_list.md >}}) to see if the created environment gets listed:
   
   ```bash
   rad env list
   ```



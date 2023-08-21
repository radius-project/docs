---
type: docs
title: "How-To: Setup a development environment"
linkTitle: "Developer environments"
description: "Learn how to initialize a new Radius development environment"
weight: 100
categories: "How-To"
tags: ["environments"]
---

## Overview 

Radius development environments enable you to quickly get started with Radius and begin writing new applications. Dev environments come preloaded with a set of development [recipes]({{< ref "/recipe-section/overview" >}}) with lightweight containers for commonly used resources such as Redis and Mongo, helping you get up and running instantly.

## Pre-requisites

1. Have a [Kubernetes cluster]({{< ref "/operations/platforms/kubernetes" >}}) handy.

   *Visit the [Kubernetes platform docs]({{< ref "/operations/platforms/kubernetes" >}}) for a list of supported clusters and specific cluster requirements.*

1. Ensure your target kubectl context is set as the default:
   ```bash
   kubectl config current-context
   ```

## How-to: Initialize a new dev environment

1. Initialize a new [Radius environment]({{< ref "operations/environments/overview">}}) with [`rad init`]({{< ref rad_init >}}):
   ```bash
   rad init
   ```
   
   Select `Yes` to setup the app.bicep in the current directory

   ```
   Initializing Radius...                                                
                                                                      
   🕔 Install Radius 0.21                                             
      - Kubernetes cluster: kind
      - Kubernetes namespace: radius-system                              
   ⏳ Create new environment default                                     
      - Kubernetes namespace: default                                    
      - Recipe pack: dev                                                 
   ⏳ Scaffold application                                          
   ⏳ Update local configuration                                                 
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

   You can also use [`rad env list`]({{< ref rad_env_list.md >}}) to view your environment:
   
   ```bash
   rad env list
   ```
3. Use `rad recipe list` to see the list of available recipes:
   ```bash
   rad recipe list
   ```
   ```
   NAME      TYPE                              TEMPLATE KIND  TEMPLATE
   default   Applications.Link/mongoDatabases  bicep          radius.azurecr.io/recipes/dev/mongodatabases:latest
   default   Applications.Link/redisCaches     bicep          radius.azurecr.io/recipes/dev/rediscaches:latest
   ``` 
   You can follow the [recipes]({{< ref "/recipe-section/overview" >}}) documentation to learn more about the recipes and how to use them in your application.

## Resource schema 

- [Environment schema]({{< ref environment-schema >}})

## Further reading

Refer to the [environments]({{< ref "/tags/environments" >}}) tag for more guides on the environment resource.

---
type: docs
title: "Tutorial"
linkTitle: "Tutorial"
description: "Step-by-step guide to define and deploy a Radius application"
weight: 30
---

This hands-on tutorial guides you through deploying a To Do List application that demonstrates key Radius concepts and capabilities. This will take approximately 30-60 minutes to complete.

{{< image src="todolist.png" alt="Diagram of the application resources and their connections" width=600px >}} 

## Prerequisites

- A Kubernetes cluster (local using kind/minikube or cloud-based)
- `kubectl` installed
- Basic familiarity with YAML, Terraform and Bicep

## Learning Outcomes

After completing this tutorial, you'll be able to:

- Understand Radius concepts like Resource Types, Environments, and Recipes
- Create Radius Resource Types and Recipes for your applications
- Deploy your applications using Radius
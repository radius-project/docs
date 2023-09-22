---
type: docs
title: "Customize Kubernetes deployments"
linkTitle: "Customize Kubernetes"
description: "Learn how to apply custom Kubernetes configurations to Radius created containers"
weight: 300
categories: "How-To"
tags: ["containers","Kubernetes","incremental","adoption"]
---

<!-- link to incremental adoption how-to page -->

##### Supported resource types

Radius currently supports the following Kubernetes resource types for the `base` property: 

| Kubernetes Resource Types | number of resources | limitation |
|----|----|----|
| Deployment | 1 | Deployment name must match the name of radius container in the app-scoped namespace | 
| ServiceAccount | 1 | ServiceAccount name must match the name of radius container  in the app-scoped namespace| 
| Service | 1 | ServiceAccount name must match the name of radius container in the app-scoped namespace |
| Secrets | multiple | no limitation except in the app-scoped namespace |
| ConfigMap | multiple config maps | no limitation except in the app-scoped namespace |

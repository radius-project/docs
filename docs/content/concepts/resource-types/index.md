---
type: docs
title: "Resource Types Concepts"
linkTitle: "Resource Types"
description: "How Resource Types abstract deployed resources"
weight: 10
---

Radius Resource Types are the building blocks of Radius. They represent the various types of resources that developers use to build their applications. Radius ships with a number of common Resource Types including containers, secrets, and various databases. But the power of Resource Types is that they can model anything that can be deployed with Infrastructure as Code (IaC). A Resource Type can be a low-level application component such as a log collector or a high-level, abstract component such as a web service. This page goes into more depth on the concepts of Resource Types. 

## What is a Resource Type?

Resource Types define the abstraction for a resource that will be deployed to a cloud environment. They are:

- **Abstract** in that they do not represent a specific resource that gets deployed, but rather a generalization of a type of resource. 
- **Application oriented** because developers use these resource types to compose their applications
- **Infrastructure agnostic** because developers should not have to be infrastructure experts.
- **Cloud provider agnostic** because one of the goals of using Radius is to ensure portability of applications.

## Anatomy of a Resource Type

A Resource Type is defined in a Resource Type definition YAML file with four components:

- **Namespace**: A logical grouping of Resource Types. The convention used by Radius is to set the namespace to `Radius.<Category>`. For example: `Radius.Data/*` or `Radius.Security/*`. 
- **Name**: The name of the Resource Type can be anything but is typically formatted using camelCase and is plural. For example: `redisCaches`, `sqlDatabases`, or `rabbitMQQueues`.
- **Description**: This is the developer documentation for your organization. It is written in Markdown format and appears in the Dashboard. This is a large blob of text where you can write anything that is helpful for your developers. Examples and support email addresses are common.
- **API version**: Each Resource Type can have multiple API versions labeled with a date, and an optional `-preview` suffix. For example: `2025-10-29-preview`.  If material changes to the schema are needed, a new API version should be created to ensure backward compatibility. 
- **Schema**: Each API version has an OpenAPI schema which defines:
  - Required properties
  - Optional properties
  - Read-only properties (also referred to as output properties)
  - Developer documentation for each property
  - Data validation rules such as enums

## Resource Type Definitions

Resource Types are defined in YAML files. Below is an example of a simple PostgreSQL Resource Type. The description properties have been omitted for brevity. The `environment` property defines which Environment the resource is deployed to. However, in practice, this property is usually set by the Radius CLI when a developer runs `rad deploy`. The `application` property is typically set in the application definition Bicep file. 

Notice that the `host`, `port`, `username`, and `passwordSecretRef` properties are read only. These are properties set the Recipe after the resource has been deployed.

{{< image src="postgreSqlDatabases.png" alt="PostgreSQL Resource Type YAML" >}}

<br><br>
{{< button text="Next step: Read about Recipes concepts" page="concepts/recipes" >}}

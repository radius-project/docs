---
type: docs
title: Radius API
linkTitle: Radius API
description: Learn about the Radius API
weight: 200
categories: "Concept"
aliases:
  - /concepts/api-concept/
---

## Overview

Radius provides an HTTP-based API and supporting tools that can deploy and manage cloud-native applications as well as on-premises or cloud resources. The server-side API components are also sometimes called a control-plane. The Radius API can be hosted inside a Kubernetes cluster or as a standalone set of processes or containers. Tools that are used with Radius (like the `rad` CLI) communicate with the API.

This page serves as documentation about the overall API design of Radius to help educate contributors to the project or any user who wants a deeper understanding of the system and its capabilities.

## Resource management terminology

Before diving in to the details of the API, it is helpful to understand the terms **resource**, **resource manager**, and **resource provider**. Imagine a typical cloud service like a virtual machine. An API for working with virtual machines would include operations like:

- Creating new virtual machines
- Reading the configuration of a virtual machine
- Updating the configuration of a virtual machine
- Deleting existing virtual machines
- Listing all virtual machines in a cloud account

In the example provided, the virtual machine is the **resource** and the API providing the management operations for virtual machines listed above is the **resource provider**. These operations are often referred to as **CRUDL** (Create, Read, Update, Delete, List) and represent the standard set of operations that most **resource provider** provide. The overall system including authentication, authorization, routing, and other concerns is called a **resource manager**.

Resource providers sometimes provide operations in addition to the CRUDL operations that are specific to the type of resource. For a virtual machine, a resource provider might provide additional operations like:

- Rebooting a virtual machine
- Restoring a virtual machine from backup

As a result the set of operations is sometimes written as **CRUDL+**, meaning that a resource provider must implement the **CRUDL** operations at a minimum and sometimes more.

Resources have a type (in the programming sense) and a means of being identified (name or id). For example an AWS virtual machine's type would be `AWS::EC2::Instance` and might have a generated name like `i-0123456789abcdef`. The name must be provided to operations like Update so that the resource provider can identify which resource to update. The name and type can also be combined with additional context to form a unique identifier. For example on AWS the virtual machine name would be combined with the user's account id and the selected region to form a unique identifier called an [ARN](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html). These identifiers are useful because they provide a universal way to identify which resource is being named.

A resource could be anything that's useful to manage through an API. For example, a resource could be an on-premises networking configuration, a 3rd party SaaS account, a Kubernetes `Pod`, or a value stored in a cloud secret store. Resources with CRUDL+ operations, types, and universal identifiers are the central concepts in Radius' API because they are a tested approach for deployment and management of software systems.

## Principles for the Radius API

Radius provides a general resource manager that can manage cloud or on-premises resources as well as opinionated support cloud-native application concerns like containers and databases. Such an API needs to be powerful, flexible, and extensible enough to communicate with a variety of existing systems that were created by different organizations.

The design of the Radius API incorporates the following principles:

- Universal addressing: every resource has a unique identifier called a resource id.
- CRUDL+ lifecycle: resources their functionality through a common set of HTTP contracts in a consistent way.
- Federation based on metadata: rather that duplicate the functionality of existing resource managers, Radius delegates functionality to external APIs and is powered by the metadata of those APIs.

The rest of this page will illustrate these principles further and provide examples.

{{% alert title="💡 Additional Info" color="info" %}}
The overall design of the Radius API is based on the Azure Resource Manager API (ARM). Radius generalizes the design of ARM, removes proprietary Azure concepts, and extends the ARM contract to support the conventions of other resource managers like Kubernetes or AWS Cloud-Control. It is the goal of the Radius project that the Radius API can serve as a truly universal API for resource management.
{{% /alert %}}

## Resource ids

Each resource in Radius has a unique identifier called a resource id. Resource ids have a common structure that allows resources to reference one-another. Resource ids also map directly to the URLs used for a resource's lifecycle operations which is convenient for navigating the API.

The common structure of a resource id is the following:

```txt
{rootScope}/providers/{resourceNamespace}/{resourceType}/{resourceName}
```

### Root scope

A hierarchical set of key-value pairs that identify the origin of the resource. Root scopes answer questions like:

- *"What cloud is this resource from?"*
- *"What cloud account contains this resource?"*
- *"What Kubernetes cluster is running this Pod?"*.

### Resource namespace and resource type

The namespace and type of a resource. These are defined together because resource types are usually two segments - a vendor namespace and a type name.

### Resource name

The name of the resource.

### Examples

The following tables shows some examples of resource ids from different resource managers.

#### Resource manager: Radius

This example shows a Radius Application named `my-app` in the `my-group` resource group, running on the local cluster:

| Key                | Example                                                                                        |
| ------------------ | ---------------------------------------------------------------------------------------------- |
| **Root scope**     | `/planes/radius/local/resourceGroups/my-group`                                                 |
| **Namespace/Type** | `Applications.Core/applications`                                                               |
| **Name**           | `my-app`                                                                                       |
| **Resource id**    | `/planes/radius/local/resourceGroups/my-group/providers/Applications.Core/applications/my-app` |

#### Resource manager: AWS

This example shows an AWS Kinesis Stream named `my-stream` in the `0123456789` account, running in the `us-west-2` region:

| Key                | Example                                                                                         |
| ------------------ | ----------------------------------------------------------------------------------------------- |
| **Root scope**     | `/planes/aws/aws/accounts/01234556789/regions/us-west-2`                                        |
| **Namespace/Type** | `AWS.Kinesis/Stream`                                                                            |
| **Name**           | `my-stream`                                                                                     |
| **Resource id**    | `/planes/aws/aws/accounts/01234556789/regions/us-west-2/providers/AWS.Kinesis/Stream/my-stream` |

#### Resource manager: Azure

This example shows an Azure Storage Account named `myaccount` in the `00000000-0000-0000-0000-000000000000` subscription and `my-group` Azure resource group:

| Key                | Example                                                                                                                                                     |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Root scope**     | `/planes/azure/azurecloud/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-group`                                                       |
| **Namespace/Type** | `Microsoft.Storage/storageAccounts`                                                                                                                         |
| **Name**           | `myaccount`                                                                                                                                                 |
| **Resource id**    | `/planes/azure/azurecloud/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-group/providers/Microsoft.Storage/storageAccounts/myaccount` |

## Resource lifecycle

The lifecycle of a resource is modeled using the HTTP methods that best match each lifecycle operation. Some operations like List do not provide a resource name because they operate on a collection of resources, however most do. Where possible, operations are idempotent, meaning that performing the same operation many times will produce the same result.

This section includes an example based on the Radius `Applications.Core/applications` type which represents a cloud-native application.

| Operation     | HTTP Method | URL                                                          |
| ------------- | ----------- | ------------------------------------------------------------ |
| List          | GET         | `{rootScope}/providers/Applications.Core/applications`       |
| Read          | GET         | `{rootScope}/providers/Applications.Core/applictions/my-app` |
| Create/Update | PUT         | `{rootScope}/providers/Applications.Core/applictions/my-app` |
| Delete        | DELETE      | `{rootScope}/providers/Applications.Core/applictions/my-app` |

The example above demonstrates the CRUDL lifecycle APIs of a resource, all resource types provided by Radius follow this pattern.

{{% alert title="🚧🚧🚧 Under construction 🚧🚧🚧" color="info" %}}
We're working on providing a detailed protocol reference for the overall UCP protocol.
{{% /alert %}}

The [API Reference]({{< ref resource-schema >}}) provides a reference to Radius' APIs.

## Resource structure

The JSON body payloads in Radius follow a regular structure to enable clients to work with many resource types in a consistent way. Top-level fields in the JSON payload are reserved for protocol use and must have consistent definitions across resources. The `properties` property is reserved for the the resource type to specify its configuration and current state.

This section includes an example based on the Radius `Applications.Core/environments` type which represents a cloud-native deployment environment.

```json
{
  "id": "/planes/radius/local/resourcegroups/default/providers/Applications.Core/environments/default",
  "location": "global",
  "name": "default",
  "properties": {
    "compute": {
      "kind": "kubernetes",
      "namespace": "default"
    },
    "provisioningState": "Succeeded"
  },
  "systemData": {
    "createdAt": "0001-01-01T00:00:00Z",
    "createdBy": "",
    "createdByType": "",
    "lastModifiedAt": "0001-01-01T00:00:00Z",
    "lastModifiedBy": "",
    "lastModifiedByType": ""
  },
  "tags": {},
  "type": "Applications.Core/environments"
}
```

{{% alert title="🚧🚧🚧 Under construction 🚧🚧🚧" color="info" %}}
We're working on providing a detailed protocol reference for the overall UCP protocol.
{{% /alert %}}

## Versioning

All APIs provided by Radius are versioned using the `api-version` query-string parameter. API versioning allows clients to request a precise version they desire, and remain compatible as behaviors and APIs change over time.

## Federation

The API functionality provided by Radius for external systems like AWS or Azure relies on API federation. As a principle, Radius avoids storing data from external systems where possible. This avoids data-synchronization problems while also minimizing resource utilization.

For example, the Radius API to list all AWS Kinesis Streams will perform the following tasks to satisfy the request:

- Parse the resource id from the request URL to determine the AWS account id and region.
- Authenticate with AWS for the specified account.
- Make a request to AWS Cloud-Control to list the Kinesis Streams.
- Adapt the data retrieved from AWS to match the Radius API structure.

## References

ARM/Azure:

- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)
- [Azure REST API Guidelines](https://github.com/microsoft/api-guidelines/blob/vNext/azure/Guidelines.md)
- [Azure REST API Reference](https://learn.microsoft.com/en-us/rest/api/azure/)

AWS:

- [AWS Cloud-Control](https://aws.amazon.com/cloudcontrolapi/)
- [AWS ARN Reference](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html)

Radius:

- [API Reference]({{< ref resource-schema >}})

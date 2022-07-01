---
type: docs
title: "Connectors"
linkTitle: "Connectors"
description: "Learn how Radius Connectors enable infrastructure portability"
weight: 300
---

Connectors provide an **infrastructure abstraction** that enables **portability** for Radius applications. Connectors utilize open-source APIs, like Redis and MongoDB, to allow users to dynamically bind to platform resources. Instead of identifying a specific instance of a resource, users can specify a connector and the API it can talk to. Connectors support either spinning up a new resource or connecting directly to an existing resource.

TODO: insert image here

For example, when a user specifies a MongoDB connector, that connector could bind to an Azure CosmosDB, an AWS DynamoDB, or a Mongo Container based on which platform is targeted. An administrator could even specify the exact configurations of the database resource to spin up when a developer needs a database, enhancing a self-serve workflow.

<img width="578" alt="Screen Shot 2022-07-01 at 12 13 43 PM" src="https://user-images.githubusercontent.com/71398878/176956322-63cb7be6-4c51-4e2d-bf6a-143f817a89c7.png">

<h4>Underlying resource</h4>

In this example, a team wants to use a Mongodb Database on Azure (`underlyingdb`) to fulfill their app's Mongo storage requirement:

{{< rad file="snippets/connector-example.bicep" embed=true marker="//RESOURCE" >}}

<h4>Connector</h4>

Then, in the app definition, a developer defines a Mongo connector (`dbconnector`) that references the storage resource (`underlyingdb`). 

{{< rad file="snippets/connector-example.bicep" embed=true marker="//CONNECTOR" >}}

The developer can bind to that resource without any configuration or knowledge of the underlying resource.  


<h4>Container</h4>

Finally, the developer's container resource (`frontend`) connects to the Mongo connector (`dbconnector`) via the "connections" property:

{{< rad file="snippets/connector-example.bicep" embed=true marker="//CONTAINER" >}}

## Connector categories

For examples on using the various Radius connectors, see [Connector Schemas]({{< ref connector-schema >}}).
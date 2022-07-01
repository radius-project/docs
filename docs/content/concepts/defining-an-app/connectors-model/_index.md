---
type: docs
title: "Connectors"
linkTitle: "Connectors"
description: "Learn how Radius Connectors enable infrastructure portability"
weight: 300
---

Connectors provide **infrastructure abstraction** that enables **portability** for Radius applications. Connectors utilize open-source APIs, like Redis and MongoDB, to allow users to dynamically bind to platform resources. Instead of identifying a specific instance of a resource, users can specify a connector and the API it can talk to. Connectors support either spinning up a new resource or connecting directly to an existing resource.

TODO: insert image here

For example, when a user specifies a MongoDB connector, that connector could bind to an Azure CosmosDB, an AWS DynamoDB, or a Mongo Container based on which platform is targeted. An administrator could even specify the exact configurations of the database resource to spin up when a developer needs a database, enhancing a self-serve workflow.

<img width="578" alt="Screen Shot 2022-07-01 at 12 13 43 PM" src="https://user-images.githubusercontent.com/71398878/176956322-63cb7be6-4c51-4e2d-bf6a-143f817a89c7.png">

TODO: put in example code snippet

TODO: link to types of connector resources

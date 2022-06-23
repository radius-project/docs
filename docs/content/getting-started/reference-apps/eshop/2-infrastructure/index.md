---
type: docs
title: "Add eShop infrastructure to application"
linkTitle: "Infrastructure"
slug: "infrastructure"
description: "Learn how to model the eShop infrastructure in Bicep"
weight: 200
---

Begin by modeling all of your application's infrastructure. This example uses Radius starters to easily deploy [connector resources]({{< ref connectors >}}) for:

- SQL databases
- Redis caches
- Message bus: either Azure Service Bus or RabbitMQ
- MongoDB: either Azure Cosmos DB or MongoDB container

## Infrastructure types

{{< tabs "Containerized" "Microsoft Azure" >}}

{{< codetab >}}
All of the infrastructure services can be deployed as containers and routes:
<br /><br />
{{< rad file="snippets/infra.bicep" embed=true download=true >}}
{{< /codetab >}}

{{< codetab >}}
The infrastructure resources can also be deployed as Azure services:
<br /><br />
{{< rad file="snippets/infra.azure.bicep" embed=true download=true >}}

{{< /codetab >}}

{{< /tabs >}}

## Next steps

In the next step, you will learn about the eShop services.

{{< button text="Next: Model eShop services" page="3-services" >}}

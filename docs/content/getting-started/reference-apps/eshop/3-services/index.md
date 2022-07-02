---
type: docs
title: "Model eShop services in Radius"
linkTitle: "Services"
slug: "model-services"
description: "Learn how to model the eShop services in Radius"
weight: 300
---

Next, you can model the eShop services through [containers]({{< ref container-schema >}}), [HTTP Routes]({{< ref httproute >}}), and [Gateways]({{< ref gateway >}}).

Depending on if you chose RabbitMQ or Azure Service Bus for the message bus, eShop can be modeled as:

{{< tabs "RabbitMQ" "Azure Service Bus" >}}

{{< codetab >}}
{{< rad file="snippets/app.bicep" embed=true download=true >}}
{{< /codetab >}}

{{< codetab >}}
{{< rad file="snippets/app.azure.bicep" embed=true download=true >}}
{{< /codetab >}}

{{< /tabs >}}

## Next steps

Now that we have looked at the eShop infrastructure, and how we can model its services, let's now deploy it to a Radius environment.

{{< button text="Next: Deploy eShop application" page="4-deploy" >}}

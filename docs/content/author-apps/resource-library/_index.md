---
type: docs
title: "Add resources to your Radius application"
linkTitle: "Resources"
description: "Specs for resources supported in Radius apps"
weight: 200
no_list: true
---

Applications are made up of resources. Resources can be abstract and deployable to multiple Radius platforms (*eg. Container, MongoDB, etc*), or they can be platform specific and deployable to a single platform (*Azure CosmosDB, Kubernetes DaemonSet, etc*).

{{% alert title="Learn about the Radius app model" color="primary" %}}
To learn more about the Radius application model an how to define resources and relationships visit the [Radius concepts]({{< ref appmodel-concept >}}).
{{% /alert %}}

## Resource types

{{< cardpane >}}
{{< card header="**Services**" >}}
[<img src="services.png" alt="Services" style="width:300px"/>]({{< ref services >}})

Model your running code with services.<br /><br />
[Learn more]({{< ref services >}})
{{< /card >}}
{{< card header="**Networking**" >}}
[<img src="networking.png" alt="Networking" style="width:350px"/>]({{< ref networking >}})

Define your network relationships & requirements.<br /><br />
[Learn more]({{< ref networking >}})
{{< /card >}}
{{< card header="**Links**" >}}
[<img src="links.png" alt="Links" style="width:325px"/>]({{< ref links >}})

Add portability to your application with links.<br /><br />
[Learn more]({{< ref links >}})
{{< /card >}}
{{< /cardpane >}}
{{< cardpane >}}
{{< card header="**Kubernetes**" >}}
[<img src="kubernetes.svg" alt="Kubernetes" style="width:325px"/>]({{< ref kubernetes-resources >}})

Model and connect to Kubernetes resources.<br /><br />
[Learn more]({{< ref kubernetes-resources >}})
{{< /card >}}
{{< card header="**Microsoft Azure**" >}}
[<img src="azure.png" alt="Microsoft Azure" style="width:325px"/>]({{< ref azure-resources >}})

Model and connect to Microsoft Azure resources.<br /><br />
[Learn more]({{< ref azure-resources >}})
{{< /card >}}
{{< card header="**Custom/3rd Party**" >}}
<img src="custom.png" alt="Custom" style="width:300px"/>

Model and connect to external resources.<br /><br />
Coming soon!
{{< /card >}}
{{< /cardpane >}}

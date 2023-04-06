---
type: docs
title: "AWS resources"
linkTitle: "AWS"
description: "Deploy and connect to AWS resources in your application"
weight: 800
---

Radius applications are able to connect to and leverage AWS resource with Bicep. Simply model your AWS resources in Bicep and connect to them from Radius resources.

Radius uses the [AWS Cloud Control API](https://docs.aws.amazon.com/cloudcontrolapi/latest/userguide/what-is-cloudcontrolapi.html) to interact with AWS resources. This means that you can model your AWS resources in Bicep and Radius will be able to deploy and manage them.

## Resource library

{{< button text="AWS resource library" link="https://github.com/project-radius/bicep-types-aws/blob/main/artifacts/bicep/index.md" newtab="true" >}}
> *If you don't have access to the Bicep-types-aws github repo, please visit https://aka.ms/ProjectRadius/GitHubAccess to request access to the Project Radius GitHub organization.*

## Example

{{< tabs Bicep >}}

{{% codetab %}}
In the following example, a [Container]({{< ref container >}}) is connecting to an S3 bucket. 

{{< rad file="snippets/aws.bicep" embed=true >}}
{{% /codetab %}} 

{{< /tabs >}}
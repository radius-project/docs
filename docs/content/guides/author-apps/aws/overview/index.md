---
type: docs
title: "AWS resources"
linkTitle: "Overview"
description: "Deploy and connect to AWS resources in your application"
weight: 100
categories: "Overview"
tags: ["AWS"]
---

Radius applications are able to connect to and leverage AWS resource with Bicep. Simply model your AWS resources in Bicep and connect to them from Radius resources.

Radius uses the [AWS Cloud Control API](https://docs.aws.amazon.com/cloudcontrolapi/latest/userguide/what-is-cloudcontrolapi.html) to interact with AWS resources. This means that you can model your AWS resources in Bicep and Radius will be able to deploy and manage them.

## Configure an AWS Provider

The AWS provider allows you to deploy and connect to AWS resources from a Radius environment on an EKS cluster. To configure an AWS provider, you can follow the documentation [here]({{< ref "/guides/operations/providers/howto-aws-provider" >}}).

## Example

{{< tabs Bicep >}}

{{% codetab %}}
In the following example, a [Container]({{< ref "guides/author-apps/containers" >}}) is connecting to an S3 bucket. 

{{< rad file="snippets/aws.bicep" embed=true >}}
{{% /codetab %}} 

{{< /tabs >}}

## Resource library

{{< button text="AWS resource library" link="/reference/resource-schema/aws" newtab="true" >}}
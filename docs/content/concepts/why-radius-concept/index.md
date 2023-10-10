---
type: docs
title: "Why Radius?"
linkTitle: "Why Radius?"
description: "Describes the motivations for creating Radius."
weight: 300
---

## Our starting point

We started the Radius project to simplify and improve upon the tools that application developers use to deploy and manage applications. Our goal at first was just to create a platform for deployment that developers would love using. As we had conversations and researched, we quickly realized that almost every enterprise is creating a custom internal developer platform to standardize and modernize the way that developers think about their jobs.

Most enterprises are not dev-tools experts and as a result they struggle with the cost and complexity of building a home-grown solution. If we could use open-source to solve the same problems enterprises were solving we could have a big impact.

A few common problems rose to the top:

- Applications are more than just Kubernetes: applications developers are tasked with managing applications on Kubernetes and resources in the cloud where complexity is high, and compliance with best-practices is a full-time job.
- Developers and platform engineers need to collaborate: to manage the complexity of the cloud, enterprises have specialized disciplines like sec-ops, fin-ops, and centers of excellence. Application developers need to interface with all of these roles, and the tools they use should aid, not impede collaboration.
- Applications need a industry-standard definition: the IT operators, SREs and other specialists that support an application usually lack context about the architecture. Application developers lack context about the underlying cloud infrastructure. As application developers and IT operators collaborate they need a common understanding and vizualization of what an application **is**.

So, we started Radius to address these concerns and provide **our** opinions about how application management should work in today's complex cloud-native landscape. Along the way we came up with the concept of **Appi-ness**: the feeling of satisfaction one has when the application is at the center of every workflow.

## Applications are more than just Kubernetes

The modern cloud-native application includes much more than Kubernetes, applications use databases, message queues, identity systems, SaaS accounts, and observability platforms. However most of the tools that are available for developers are focused on the Kubernetes basics of compute, storage, and networking.

Our philosophy is to be inclusive when considering what is *part of the application*. Developers can use cloud resources directly or use Recipes configured by operators for on-demand provisioning of infrastructure. We automate best-practices like IAM/identity assignment, permissions management, diagnostics, and networking configuration based on the application architecture and developer intent. We hope that features like Connections feel like magic when its easy to wire up your dependencies.  IT operators control the templates and credentials used to interact with the cloud ensuring that provisioning is done in a supported way.

## Developers and platform engineers need to collaborate

Enterprises are creating specialized roles and initiatives to design the developer experience that are often referred to as platform engineering. Most often this looks like a platform engineering team supporting repository templates, cloud resource templates, and a software catalog for application developers to use. Unfortunately, the tools and assets that are frequently used don't encourage collaboration.

Radius provides concepts like Environments and Recipes that support a separation of concerns. Platform engineers can create repository templates with CI/CD pipelines and starter code for deployment. IT operators can deploy and govern the Environments where those pipelines deploy applications. Cloud experts can provide the Recipes used to create and update cloud resources. Developers are only responsible for describing the requirements and architecture of the application, understanding which environments to use, and choosing dependencies from the supported set of Recipes.

## Applications need an industry-standard definition

The myriad of operational roles that support applications in production rarely have the full picture of how the application is architected or a complete picture of the infrastructure resources that are in use. It can be difficult for an organization to understand the impact of an outage or what is causing high consumption and high cost for a cloud resource without a holistic understanding. Unless developers are creating the cloud resources themselves, its hard for them to understand the real infrastructure at work. Teams are adopting software catalogs to help address these problems but there is always drift between the catalog and the source of truth.

We wanted to do better by building a flexible and customizable picture of what an application *is*. To do this we capture the developer's understanding of the application during deployment and combine that picture with the cloud resources and Recipes used to provision the infrastructure. This data is used to build the Application Graph, a new kind of software catalog that describes the application's architecture, communication patterns, and dependencies as a shared view for the whole organization.

We hope that this holistic way of thinking about applications becomes the standard and that together with the rest of the cloud-native ecosystem we can build a set of tools that promote **Appi-ness**.

## What we're not rethinking

Many practices and technologies in cloud-native development are a success and don't need to be re-thought. 

- Radius makes it easy for application developers to adopt by supporting your existing containerized code, Dockerfiles, and Helm charts. 
- We believe that 12-factor is still a great set of ideas and so any 12-factor style application should be easy to use with Radius.
- We like infrastructure-as-code as for its repeatability and use it for both Recipes and application descriptions. 
- There are plenty of great CI/CD systems, application delivery pipelines, and Gitops systems out there and Radius can work with any of them.

## Open Source

@ryanwaite - what would you think about your section on OSS being included here instead?
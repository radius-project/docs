---
type: docs
title: "Concept: Why Radius?"
linkTitle: "Why Radius?"
description: "Describes the motivations for creating Radius."
weight: 300
categories: "Concept"
---

## Our starting point

We started Radius to simplify and improve upon tools application developers use to deploy and manage applications. Our initial goal was just to create a platform for deployment that developers would love but, as we talked to more cloud customers, we realized almost every enterprise is creating a custom internal developer platform to standardize the way they deploy and manage cloud-native applications

Most enterprises are not dev-tools experts and as a result they struggle with the cost and complexity of building a home-grown solution. If we could provide an open-source solution that solved these problems for enterprises we could have a big impact.

A few common problems rose to the top:

- **Applications are more than just Kubernetes:** standardizing on Kubernetes has been a successful strategy for most enterprises, but applications developers are tasked with managing applications on Kubernetes along with multiple resources in the cloud. Integrating Kubernetes with cloud services has added additional complexity while making compliance with best-practices almost a full-time job.
- **Developers, platform engineers, and  IT operators need to collaborate:** to manage the complexity of the cloud, enterprises have specialized disciplines like sec-ops, fin-ops, and cloud centers of excellence. Application developers need to interface with all of these roles, and the tools they use should aid, not impede collaboration.
- **Applications lack an industry-wide definition:** the IT operators, SREs and other specialists that support an application usually lack context about the architecture. Application developers lack context about the underlying cloud infrastructure. As application developers and IT operators collaborate they need a common understanding and visualization of what an application **is**.

So, we started Radius to address these concerns and provide **our** opinions about how application management should work in today's complex cloud-native landscape. Along the way we came up with the concept of **Appi-ness**: the feeling of satisfaction one has when the application is at the center of every workflow.

## Applications are more than just Kubernetes

The modern cloud-native application includes much more than Kubernetes. Applications use databases, message queues, identity systems, SaaS accounts, and observability platforms. However, most of the tools that are available for developers are focused on the Kubernetes basics of compute, storage, and networking.

Our philosophy is to be inclusive when considering what is *part of the application*. Developers can use cloud resources directly or use Recipes configured by operators for on-demand provisioning of infrastructure. We automate best-practices like IAM/identity assignment, permissions management, diagnostics, and networking configuration based on the application architecture and developer intent. We hope that features like Connections feel like magic when its easy to wire up your dependencies.  IT operators control the templates and credentials used to interact with the cloud ensuring that provisioning is done in a supported way.

## Developers and platform engineers need to collaborate

Enterprises are creating specialized roles and initiatives to improve their speed, efficiency, and security when adopting the cloud. Platform engineering is an emerging discipline that's combining a product mindset with learnings from DevOps and DevSecOps teams to create internal development platforms. When successful, platform engineers deliver a set of tools that provide sufficient automation, tracking, governance, and observability that guide development teams naturally fall “into the pit of success.” Often these endeavors can come up a little short, looking like a set of repository templates, cloud resource templates, and a software catalog for application developers to use. Unfortunately, the tools and assets that are frequently used don't encourage collaboration between developers and the platform engineers supporting those developers. Platform engineering is new as a discipline, and the patterns that will make enterprises successful long-term are still emerging.

Radius provides concepts like Environments and Recipes that support a separation of concerns. Platform engineers can create repository templates with CI/CD pipelines and starter code for deployment. IT operators can deploy and govern the Environments where those pipelines deploy applications. Cloud and security experts can provide the Recipes used to create and update cloud resources. Developers are only responsible for describing the requirements and architecture of the application, understanding which environments to use, and choosing dependencies from the supported set of Recipes.

## Applications need an industry-standard definition

The myriad of operational roles that support applications in production rarely have the full picture of how the application is architected or a complete picture of the infrastructure resources that are in use. It can be difficult for an organization to understand the impact of an outage or what is causing high consumption and high cost for a cloud resource without a holistic understanding of the application. Unless developers are creating the cloud resources themselves, its hard for them to understand the real infrastructure at work. Teams are adopting software catalogs to help address these problems but there is always drift between the catalog and the source of truth.

We wanted to do better by building a flexible and customizable picture of what an application *is*. To do this we capture the developer's understanding of the application during deployment and combine that picture with the cloud resources and Recipes used to provision the infrastructure. This data is used to build the Application Graph, a new kind of software catalog that describes the application's architecture, communication patterns, and dependencies as a shared view for the whole organization.

We hope that this holistic way of thinking about applications becomes the standard and that together with the rest of the cloud-native ecosystem we can build a set of tools that promote **Appi-ness**.

## What we're not rethinking

Many practices and technologies in cloud-native development are a success and don't need to be re-thought. 

- Radius makes is easy for application developers to adopt because it supports your existing containerized code, Dockerfiles, and Helm charts. 
- We believe that [twelve-factor](https://12factor.net/) is still a great set of ideas and so any twelve-factor style application should be easy to use with Radius.
- We like infrastructure-as-code as for its repeatability and use it for both Recipes and application descriptions. 
- There are plenty of great CI/CD systems, application delivery pipelines, and Gitops systems out there and Radius can work with any of them.

## Open-source from the start

We planned for Radius to be open-source from the start because we want to reach as many developers, organizations, and ecosystem partners as we can. Open-source can mean different things to different people. For Radius, open-source means that our source code is publicly available under an OSI-approved permissive license. It also means that the Radius project uses an neutral and open governance model to continue the evolution of Radius as a multi-cloud technology going forward. Anyone should be able to contribute to Radius, extend the platform, self-host Radius for internal use, or use it to build a business hosting other people's applications.

We know from our conversations with enterprises that customization, extensibility, and a large ecosystem are key. Every organization is unique and will make different policy, workflow, and technology choices. Every large organization has critical internal technologies. Extensibility is the way to put those internal technologies on even-footing with the cloud. A large ecosystem of partners and integrations enables everyone to keep using the technologies they are already committed to. By participating in open-source, users have a direct channel to propose changes, give feedback, add features, or customize the version of Radius they use. Our commitment to open-source and neutral, open governance means any technology vendor can join the ecosystem and benefit from the level playing-field that's being created.

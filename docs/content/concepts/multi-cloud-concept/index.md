---
type: docs
title: Concept: Open-source and multi-cloud  
linkTitle: Open-source and multi-cloud
description: For many enterprises, their cloud native computing strategy involves using multiple cloud providers. Open source projects, like Kubernetes, help ensure these enterprises achieve their strategy. As a result, Radius was designed to be open-source and multi-cloud from the start. 
weight: 300
categories: "Concept"
---

## Using multiple cloud providers
Radius is designed to meet customers where they are, integrating with existing best practices while providing new benefits through features like the Radius Application Graph and Radius Environments and Recipes. A majority of enterprises surveyed suggested that they were either using multiple cloud providers or were going to use multiple cloud providers. In short, multi-cloud is a trend that is accelerating in popularity.

What does multi-cloud really mean? In talking with a variety of enterprises and cloud native software vendors we found three types of multi-cloud use:

1. Multi-cloud enterprise: these enterprises deployed some application to one cloud provider and other applications to another cloud provider.
1. Cloud-agnostic applications: these enterprises deploy the same application to different cloud providers.
1. Multi-cloud application: these enterprises have a single application that is distributed across multiple clouds.

The third case, a single application that is running across multiple clouds, was incredibly rare. Enterprises that had experimented with multi-cloud applications cited almost insurmountable challenges with operations, security, and performance management. While Radius can help with these kinds of applications, supporting these kinds of applications was not a design goal for Radius.

Radius was designed to meet the first two types of multi-cloud use.

### Multi-cloud enterprise
The multi-cloud enterprise case was the most common case we encountered. Some enterprises explained that they were multi-cloud due to decentralized decision making, acquisitions, or inertia. For example, some enterprises let individual engineering teams decide which cloud worked best for the type of application they were building. These teams would select a cloud provider for a variety of reasons, such as prior experience with a cloud provider, unique cloud provider features, or the way a particular cloud provider integrated with other tools or practices used by the team.

Some enterprises explained that they were multi-cloud through acquisitions. Their new parent company might have selected a particular cloud provider that is different than their choice. For many customers we spoke with there was little to no requirement to migrate their existing applications from one cloud provider to another cloud provider.

Finally, some enterprises explained that they were multi-cloud due to inertia. They had started with one cloud provider, but later, switched to using a different provider as their primary choice for new applications. Like the acquisition case above, there was no requirement to move existing applications to the new cloud provider. 

Radius was designed with these enterprises in mind. Enterprises can "radify" their applications regardless of cloud provider, enabling these enterprises to use Radius regardless of whether or not the application is using a particular public cloud provider or a private cloud operated by the enterprise itself. Radius applications can use cloud vendor specific technologies, like Amazon's DynamoDB or Azure's Cosmos DB, or they can use open source technologies like Redis. 

### Cloud-agnostic applications
There were some enterprises that ran the same application in multiple clouds. Often these enterprises had business requirements that required them to use multiple cloud providers. For example, some financial services enterprises had to host their application and any data associated with the application in a particular country or geographic region. The enterprise would need their application to be deployable to whichever cloud provider was available in a specific country or region.

Radius was designed to support this specific use case from the start. We wanted to make it possible for IT teams, platform engineering teams, or cloud center of excellence teams to make decisions about which cloud provider an application would use. We wanted them to be able to make that decision without having an impact on their developers and the application logic those developers were writing. 

Radius supports cloud-agnostic applications in two ways. First, enterprises can use open source technologies in their applications. For example, developers that need a cache might use a Redis cache in their application. The platform engineering team would build Radius Recipes that, depending on the cloud provider, would use a different underlying Redis compatible service. This might mean using Azure Cache for Redis when deploying to Azure or Amazon ElastiCache for Redis on AWS. The developer's application logic should be the same, regardless of which cloud they're using.

The second way Radius supports cloud-agnostic applications is with Dapr, the Distributed Application Runtime. Dapr provides developers with APIs that abstract away the complexity of common challenges developers encounter regularly when building cloud native applications. These API building blocks abstract away services that provide state management, secrets management, or publish and subscribe systems. Developers can write to Dapr and platform engineering teams can use Radius to provide the underlying infrastructure for these Dapr based applications. For example, a Dapr application that's persisting state could use Azure Blob Storage or Amazon S3 as the underlying state store depending on which cloud provider was used to host the application.

Radius was designed from the start to support enterprises in implementing their multi-cloud strategy. Enterprises can use cloud vendor technologies, like DynamoDB, or they can build on open source technologies like Redis and Dapr.

## Open-source
Many enterprises use open-source technologies as a way of achieving their multi-cloud strategy. Kubernetes adoption is a great example of this trend. Customers building on Kubernetes can leverage their Kubernetes experience, tools, and practices with any cloud provider. 

Radius was designed to be an open-source project from the start as part of the way Radius would support multi-cloud strategies. Open-source can mean different things to different people. For Radius, open-source means that our source code is publicly available. It also means that the Radius project uses an neutral and open governance model to continue the evolution of Radius going forward. 

The Radius team has worked with the Cloud Native Computing Foundation (CNCF) to bring Radius into the CNCF as a new CNCF project. The Radius team is optimistic that Radius will be a success, both in helping enterprises achieve their multi-cloud strategies as well as in bringing powerful concepts, like Environments, Recipes, and the Application Graph, to the broader cloud native community.

---
type: docs
title: "Environments Concepts"
linkTitle: "Environments"
description: "How Environments define how and where resources are deployed"
weight: 30
---

Environments define the deployment location as well as the set of Recipes to use to deploy resources to that Environment. Environments can be modeled in many ways according to your preferences. When combines with Resource Groups, Environments can be organized in many different ways. They may be logical environments such as dev, test, stage, prod. Or they may be locations such as AWS us-east-1. They may be specific to an application or a team, or shared across the organization.

When defining an Environment, the deployment location is specified by `provider`:

- **Kubernetes**: The namespace
- **AWS**: The account and region
- **Azure**: The subscription and resource group

When a resource is deployed, these location details are provided to the Terraform module or Bicep template via the `context` object.

The second component of the Environment definition is the set of Recipes for each Resource Type. By assigning Recipes at the Environment level, it is possible for each Environment to have a unique set of Recipes. Take a PostgreSQL database Resource Type as an example, there may be:

- A development environment running on a local workstation that deploys the database to a local Kind or k3d cluster
- A test environment which deploys to a shared Kubernetes cluster but also assigns more CPU and memory to the database
- A staging environment that deploys the database to AWS using RDS
- A production environment that also uses AWS RDS but configures the database with high availability and backups

Finally, each Recipe in an Environment definition can also have Environment-level Recipe parameters. Recipe parameters are useful for injecting additional environmental information into the Recipe. Take, for example, a Recipe which deploys a PostgreSQL database using AWS RDS or Azure Database for PostgreSQL. Ideally, the database is created with an endpoint in an existing VPC/virtual network. The virtual network ID can be passed to the Recipe via a Recipe parameter defined within the Environment.

<br>
{{< button text="Next step: Read about Applications concepts" page="concepts/applications" >}}

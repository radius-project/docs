---
type: docs
title: "Contributing to Project Radius"
linkTitle: "Contributing"
description: "Guides and requirements for contributing to Project Radius"
weight: 70
---

## Contributing Links

Project Radius can be best understood as the combination of the following components:

- The **`rad` CLI** for deploying and managing environments and applications. S
- The **application model** for describing applications as a set of components, groupings, and relationships
- The **Bicep** language and tools which includes the application model as a set of types
- The **ARM Deployment Engine** which process the output of the Bicep compiler
- The **Radius API** which interfaces with the ARM deployment engine and other actors to handle individual operations on the application model
- The **Radius Control Plane** that implements operations on the application model as a sequence of resource management operations on a hosting platform
- The **Hosting Platform** that provides the underlying capabilies used by the application model such as running containers and databases

| Component | Description | Project Link  |
|---|---|---|
| **`rad` CLI**   | Handles deploying and managing environments and applications | https://github.com/project-radius/radius/blob/main/docs/contributing/contributing-code/contributing-code-cli/running-rad-cli.md |
| **Bicep**  | Language and tools which includes the application model as a set of types | https://github.com/project-radius/bicep/blob/radius-compiler/CONTRIBUTING.md, will eventually be merged with https://github.com/azure/bicep |
| **ARM Deployment Engine**  | Process the output of the Bicep compiler and deploys resources. | https://github.com/project-radius/deployment-engine/blob/main/CONTRIBUTING.md |
| **Radius Control Plane**  | Implements operations on the application model as a sequence of resource management operations | https://github.com/project-radius/radius/tree/main/docs/contributing/contributing-code |
| **Templates**  | Deployable starter templates for getting up and running with Radius | https://github.com/project-radius/templates |

---
type: docs
title: "Overview: Deleting applications from a Radius environment"
linkTitle: "Delete applications"
description: "Learn how to delete a Radius application"
weight: 300
categories: "Overview"
tags: ["deletion"]
---

## Delete a Radius application

You can delete a Radius application from the environment using the [`rad app delete`]({{< ref rad_application_delete >}}) command.

```bash
 rad app delete app.bicep
 ```

 This will delete the following resources from the default Radius environment
 
  1. All the resources created by Radius in the cluster environment
  2. All the resources provisioned by Recipes
  
 This will not delete the following resources from the default Radius environment
 
 1. Any resources already provisioned by the user outside of Radius (e.g. manually created resources)
 2. Any cloud resources provisioned by Radius (e.g. Azure/AWS resources)
 
 You can find more examples on deleting applications [here]({{< ref "rad_application_delete#examples" >}}).

## Delete Cloud resources

For Azure, delete the deployed Azure resources from the Azure portal or the Azure CLI . For AWS, delete the deployed AWS resources from the AWS console or the AWS CLI.


 
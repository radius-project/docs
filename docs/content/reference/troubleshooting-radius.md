---
type: docs
title: "Troubleshoot issues and common problems"
linkTitle: "Troubleshooting"
description: "Common issues users may have with Project Radius and how to address them"
weight: 900
---

## Cloning repo

### Visual Studio not authorized for single sign-on

If you receive an error saying Visual Studio or another application is not authorized to clone the Radius repo and you need to re-authorize the app, follow these steps:
1. Open a browser to https://github.com/project-radius/radius
1. Select your profile and click on Settings
1. Select Applications from the left navbar
1. Select the Authorized OAuth Apps tab
1. Find the conflicting app and select Revoke
1. Reopen app on local machine and re-auth


## Creating environment

### Error response cannot be parsed: """ error: EOF

If you get an error when configuring Azure cloud provider after selecting a Resource Group name, make sure you set your subscription to one within the Microsoft tenant:

```bash
az account set --subscription <SUB-ID>
```

### Doskey is not recognized

If you receive an error about the `doskey` binary, such as below:

```bash
Invoking Azure CLI failed with the following error: 'doskey' is not recognized as an internal or external command, operable program or batch file.
```

try some of these solutions:
- Make sure C:\Windows\System32 is part of your PATH
- Make sure you don't have any custom scripts that launch at startup that use doskey to configure special aliases

## Application deployment

Issues faced when deploying applications

## Troubleshooting Radius Service 

To troubleshoot radius serice user has to fetch the logs from the radius service containers

1. Run the kubectl command to list the applications running in your cluster under the namespace radius-system to get the pod details of appcore-rp, ucp and deployment engine.

```
kubectl get pods -n radius-system
```

2. Get the logs from radius appcore-rp, ucp and deployment engine container by using the pod names captured from the previous step and running the following command.

```
kubectl logs -f <appcore-rp pod name> -n radius-system
kubectl logs -f <deployment engine pod name> -n radius-system
kubectl logs -f <ucp pod> -n radius-system
```

## Troubleshooting issues with Azure Cloud Provider

To troubleshoot issues with the Azure cloud provider and deployments to user's Azure subscription and resource group, refer to ARM logs. Log in to https://portal.azure.com and within the target resource group navigate to the "Activity logs" from the menu. For details refer https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log?tabs=powershell#view-the-activity-log  

## Examples

Deploying an application to Azure with a service principle with incorrect scope returns an error from deployment engine

```
rad deploy test.bicep
Building test.bicep...
Deploying Application into workspace 'w2'...
Deployment In Progress...

Error: ResourceDeploymentClient#CreateOrUpdate: Failure sending request: StatusCode=0 -- Original Error: Code="InternalServerError" Message="Internal server error."
```

Deployment engine logs
```
kubectl logs -f bicep-de-6d4546df86-rhthn -n radius-system

fail: Microsoft.AspNetCore.Diagnostics.ExceptionHandlerMiddleware[1]
An unhandled exception has occurred while executing the request.
Azure.RequestFailedException: The client '81082ee4-ace0-4922-a80a-2c02cb0d2207' with object id '81082ee4-ace0-4922-a80a-2c02cb0d2207' does not have authorization to perform action 'Microsoft.Resources/subscriptions/resourcegroups/read' over scope '/subscriptions/66d1209e-1382-45d3-99bb-650e6bf63fc0/resourcegroups/radius-rg-MZ94f' or the scope is invalid. If access was recently granted, please refresh your credentials.
Status: 403 (Forbidden)
ErrorCode: AuthorizationFailed
```
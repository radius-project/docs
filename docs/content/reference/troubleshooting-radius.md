---
type: docs
title: "Troubleshoot issues and common problems"
linkTitle: "Troubleshooting"
description: "Common issues users may have with Project Radius and how to address them"
weight: 900
categories: "How-To"
tags: ["troubleshooting"]
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

## Troubleshooting the Radius control-plane

To troubleshoot the Radius control-plane, you can use the command [`rad debug-logs`]({{< ref rad_debug-logs >}}) to get logs from each of control plane pods.

1. Run `rad debug-logs` to get a zip of log files for each of the pods running in the Radius control-plane. You should see the `appcore-rp`, `ucp`, and `bicep-de` logs:

   ```bash
   rad debug-logs
   Capturing logs from the Radius workspace "myworkspace"
   Wrote zip file debug-logs.zip. Please inspect each log file and remove any private information before sharing feedback.
   ```


2. In these log files, look for the text "panic", "error", or "Exception" in the logs, and if you find it inspect the error message. Also please open an issue at [project-radius/radius](https://github.com/project-radius/radius/issues/new?assignees=&labels=kind%2Fbug&template=bug.md&title=%3CBUG+TITLE%3E) with the details of your error and if possible, how to recreate. Please ensure that no sensitive information is in the logs prior to attaching them to an issue.

> Visit https://aka.ms/ProjectRadius/GitHubAccess if you need access to the repo to open a bug.

## Troubleshooting issues with Azure Cloud Provider

To troubleshoot issues with the [Azure cloud provider]({{< ref providers >}}) and deployments to a Microsoft Azure subscription and resource group, refer to your [ARM activity logs](https://docs.microsoft.com/azure/azure-monitor/essentials/activity-log):

1. Visit https://portal.azure.com
1. Navigate to your target subscription and resource group
1. Select "Activity logs" from the menu
1. Inspect the logs for any errors of failed deployments

Note that Activity logs may take up to 10 minutes to be available in Azure.

## Example

In this example, a failure is returned after attempting to deploy a Bicep template that contains a Radius application plus Azure resources:

```bash
rad deploy test.bicep
Building test.bicep...
Deploying Application into workspace 'w2'...
Deployment In Progress...

Error: ResourceDeploymentClient#CreateOrUpdate: Failure sending request: StatusCode=0 -- Original Error: Code="InternalServerError" Message="Internal server error."
```

This error isn't very descriptive. Let's take a look at the control-plane logs to see if they can tell us more:

```bash
rad debug-logs
```

After inspecting the log files, we see in the bicep-de-... log:

```
fail: Microsoft.AspNetCore.Diagnostics.ExceptionHandlerMiddleware[1]
An unhandled exception has occurred while executing the request.
Azure.RequestFailedException: The client 'APP_ID' with object id 'OBJECT_ID' does not have authorization to perform action 'Microsoft.Resources/subscriptions/resourcegroups/read' over scope '/subscriptions/SUBSCRIPTION_ID/resourcegroups/radius-rg-MZ94f' or the scope is invalid. If access was recently granted, please refresh your credentials.
Status: 403 (Forbidden)
ErrorCode: AuthorizationFailed
```

This tells us the service principal that was configured with the Azure cloud provider was not properly configured on the target resource group. You can now add your service principal to your resource group and try your deployment again.

Also please make sure to [open an Issue](https://github.com/project-radius/radius/issues/new?assignees=&labels=kind%2Fbug&template=bug.md&title=%3CBUG+TITLE%3E) if you encounter a generic `Internal server error` message, so we can address the root error not being forwarded to the user.

---
type: docs
title: "How-To: Interact with the UCP API in Postman"
linkTitle: "UCP API with Postman"
weight: 300
description: "How-To: Interact directly with the UCP API using the Postman API Platform"
---

## Pre-requisites

Before you can start using Postman with to interact with the UCP API, you will need the following:

- [Postman](https://www.postman.com/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- A [Radius environment](https://docs.radapp.dev/getting-started/)

## Step 1: Create Kubernetes Objects

1. Create a new file, `postman.yaml` and add the following Kubernetes objects:
   
   - A `ServiceAccount` named `postman-account`
   - A `ClusterRole` named `postman-role` with full access to all `api.ucp.dev` resources
   - A `ClusterRoleBinding` named `postman-role-binding` that binds the `postman-account` to the `postman-role`

   ```yaml
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: postman-account
     namespace: radius-system
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRole
   metadata:
     name: postman-role
     namespace: radius-system
   rules:
     - apiGroups: ["", "api.ucp.dev"]
       resources: ["*"]
       verbs: ["*"]
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRoleBinding
   metadata:
     name: postman-role-binding
     namespace: radius-system
   subjects:
     - kind: ServiceAccount
       name: postman-account
       namespace: radius-system
   roleRef:
     kind: ClusterRole
     name: postman-role
     apiGroup: rbac.authorization.k8s.io
   ```

2. Apply the `postman.yaml` file:

   ```bash
   kubectl apply -f postman.yaml
   ```

## Step 2: Generate a token

1. Generate a token that can be used to authenticate to the Kubernetes API:

   > **Note**: the default expiration time for this token is 1 hour. You can use the `--duration` flag to set a different expiration time, up to 48 hours.

   ```bash
   kubectl create token postman-account -n radius-system
   ```

## Step 3: Get your Kubernetes API host

1. Get the control plane API endpoint for your Kubernetes cluster:

   ```bash
   kubectl cluster-info
   ```

## Step 4: Use Postman

1. Open Postman and create a new request:

   - Set the method to `GET`
   - Set the URL to `https://<your-cluster>/apis/api.ucp.dev/v1alpha3/planes/radius/local/resourcegroups?api-version=2022-09-01-privatepreview`
   - Open the `Authorization` tab and select `Bearer Token` from the `Type` dropdown. Paste the token you generated in the previous step into the `Token` field.

2. Click 'Send' to send the request. You should now see all of your UCP resource groups:

   ```
   {
       "value": [
           {
               "id": "/planes/radius/local/resourcegroups/default",
               "location": "global",
               "name": "default",
               "tags": {},
               "type": "System.Resources/resourceGroups"
           }
       ]
   }
   ```
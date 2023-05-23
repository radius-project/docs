---
type: docs
title: "How-To: Interact with the UCP API in Postman"
linkTitle: "UCP API with Postman"
weight: 300
description: "How-To: Interact directly with the UCP API using the Postman API Platform"
---

If you're a user looking to use Postman with Radius, you've come to the right place! In this guide, we'll show you how to use Postman to interact with the UCP API using a Radius environment.

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [Postman](https://www.postman.com/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Radius environment](https://docs.radapp.dev/getting-started/)

### Step 1: Create Kubernetes objects

The first step is to create the necessary Kubernetes objects. You can do this by creating a new file named `postman.yaml` and adding the following contents:

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

Save the file and then apply it using the following command:

```bash
kubectl apply -f postman.yaml
```

This will create a `ServiceAccount` named `postman-account`, a `ClusterRole` named `postman-role` with full access to all `api.ucp.dev` resources, and a `ClusterRoleBinding` named `postman-role-binding` that binds the `postman-account` to the `postman-role`.

### Step 2: Generate a token

Now that you have created the necessary Kubernetes objects, you can generate a token that can be used to authenticate to the Kubernetes API. To do this, run the following command:

```bash
kubectl create token postman-account -n radius-system 
```

This will create a token with the default expiration time of 1 hour. If you want to set a different expiration time, you can use the `--duration` flag to specify a duration in seconds (up to 48 hours).

### Step 3: Get your Kubernetes API host

Next, you'll need to get the control plane API endpoint for your Kubernetes cluster. You can do this by running the following command:

```bash
kubectl cluster-info
```

This will output information about your Kubernetes cluster, including the control plane API endpoint.

### Step 4: Use Postman

Now that you have your Kubernetes API endpoint and token, you can use Postman to interact with the UCP API. Here's how:

1. Open Postman and create a new request.
2. Set the method to `GET`.
3. Set the URL to `https://<your-cluster>/apis/api.ucp.dev/v1alpha3/planes/radius/local/resourcegroups?api-version=2022-09-01-privatepreview`.
4. Open the `Authorization` tab and select `Bearer Token` from the `Type` dropdown. Paste the token you generated in step 2 into the `Token` field.
5. Click the 'Send' button to send the request.

You should now see all of your UCP resource groups in the response.


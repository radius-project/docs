---
type: docs
title: "How-To: Interact with the UCP API in Postman"
linkTitle: "UCP API with Postman"
weight: 300
description: "How-To: Interact directly with the UCP API using the Postman API Platform"
---

## Prerequisites
- Postman API Platform installed on your machine
- A Radius environment running inside a Kubernetes cluster
- Access to the Kubernetes cluster using kubectl command line tool


## Steps

1. Download the UCP API schema file openapi.yaml from the [UCP API reference page]()
1. Deploy the schema file to the Kubernetes cluster by running the following command:

```bash
kubectl apply -f openapi.yaml
```

1. Generate a service account (SA) token for the UCP API by running the following command:
```bash
kubectl get secret $(kubectl get sa ucp-serviceaccount -o jsonpath='{.secrets[0].name}') -o go-template='{{.data.token | base64decode}}'
```

1. Open Postman on your machine.
1. In Postman, click on the Import button and select Import from Link.
1. Paste the URL of the UCP API schema file openapi.yaml.
1. Click on Import.
1. In Postman, click on the Authorization tab.
1. Set the Type field to Bearer Token.
1. Paste the service account token generated in step 3 into the Token field.
1. Click on the Send button to make a request to the UCP API.
1. You should receive a response from the UCP API in Postman.

Congratulations, you have successfully interacted directly with the UCP API using the Postman API Platform!
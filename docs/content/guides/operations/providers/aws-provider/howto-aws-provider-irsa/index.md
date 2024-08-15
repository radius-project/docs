---
type: docs
title: "How-To: Configure the AWS cloud provider with IAM Roles for Service Accounts (IRSA)"
linkTitle: "AWS provider with IRSA"
description: "Learn how to configure the AWS provider with IAM Roles for Service Accounts(IRSA) for your Radius Environment"
weight: 200
categories: "How-To"
tags: ["AWS"]
---

The AWS provider allows you to deploy and connect to AWS resources from a Radius Environment on an EKS cluster. It can be configured:

- [Interactively via `rad init`](#interactive-configuration)
- [Manually via `rad env update` and `rad credential register`](#manual-configuration)

## Prerequisites

- [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account) and an [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)
- [Setup AWS CLI with your AWS credentials. ](https://docs.aws.amazon.com/cli/latest/reference/configure/)
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Setup a supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
  - You will need the cluster's OIDC Issuer URL. [EKS Example](https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html)
- [Create an IAM Policy] (https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html)


## Setup the AWS IAM Roles for Service Accounts(IRSA) for Radius

To authorize Radius to connect to AWS using AWS IAM Roles for Service Accounts(IRSA), you should assign IAM roles to Kubernetes service accounts.
To associate an IAM role with a Kubernetes service account Create an IAM role and associate it with a Kubernetes service account.
- Go to Identity and Access Management (IAM) on AWS portal and create a new role.
{{< image src="./create-role.png" width=500px alt="Screenshot of Create Role page in AWS portal" >}}
- Select `Trusted entity type` as `Web Identity` and `Identity Provider` as the cluster OIDC url.
{{< image src="./select-trust-entity.png" width=500px alt="Screenshot of options to pass while selecting trust entity." >}}
- Select the created IAM policy to attach to your new role.
- Add `Role Name` and create role using the default trust policy.
- Update the Trust Policy to match to the below format.
    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Federated": "arn:aws:iam::<account-id>:oidc-provider/<oidc-url>"
                },
                "Action": "sts:AssumeRoleWithWebIdentity",
                "Condition": {
                    "StringEquals": {
                        "<oidc-url>:aud": "sts.amazonaws.com",
                        "<oidc-url>:sub": "system:serviceaccount:radius-system:ucp"
                    }
                }
            },
            {
                "Sid": "Statement1",
                "Effect": "Allow",
                "Principal": {
                    "Federated": "arn:aws:iam::<account-id>:oidc-provider/<oidc-url>"
                },
                "Action": "sts:AssumeRoleWithWebIdentity",
                "Condition": {
                    "StringEquals": {
                        "<oidc-url>:aud": "sts.amazonaws.com",
                        "<oidc-url>:sub": "system:serviceaccount:radius-system:applications-rp"
                    }
                }
            }
        ]
    }
    ```
Now that the setup is complete, you can install Radius with AWS IRSA enabled.

## Interactive configuration

1. Initialize a new environment with [`rad init --full`]({{< ref rad_init >}}):

   ```bash
   rad init --full
   ```

1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Add an AWS provider** 
        1. Select the "IRSA" option
        2. Enter IAM Role ARN.
            Find the ARN from the role created in the setup step.
            {{< image src="./get-role-arn.png" width=500px alt="Screenshot of role details to get role ARN." >}}
        3. Confirm the AWS account ID or provide the account ID you would like to use.
        4. Select a region to deploy your AWS resources to.
   - **Environment name** - The name of the environment to create

   You should see the following output:

      ```
      Initializing Radius. This may take a minute or two...

    ✅ Install Radius {{< param version >}}
        - Kubernetes cluster: k3d-k3s-default
        - Kubernetes namespace: radius-system
        - AWS credential: IRSA
        - IAM Role ARN: arn:aws:iam::myAccountID:role/radius-role-new
    ✅ Create new environment default
        - Kubernetes namespace: default
        - AWS: account myAccountID and region us-east-2
    ✅ Update local configuration

        Initialization complete! Have a RAD time 😎
      ```

## Manual configuration

1. Use [`rad install kubernetes`]({{< ref rad_install_kubernetes >}}) to install Radius with AWS AWS IAM Roles for Service Accounts(IRSA) enabled:

    ```bash
    rad install kubernetes --set global.aws.irsa.enabled=true
    ```

1. Create your resource group and environment:

    ```bash
    rad group create default
    rad env create default
    ```

1. Use [`rad env update`]({{< ref rad_env_update >}}) to update your Radius Environment with your your AWS region and AWS account ID:

    ```bash
    rad env update myEnvironment --aws-region myAwsRegion --aws-account-id myAwsAccountId
    ```

1. Use [`rad credential register aws irsa`]({{< ref rad_credential_register_aws_irsa >}}) to add the AWS IRSA credentials:

    ```bash
    rad credential register aws irsa --iam-role myRoleARN
    ```

    Radius will use the provided roleARN for all interactions with AWS, including Bicep and Recipe deployments.

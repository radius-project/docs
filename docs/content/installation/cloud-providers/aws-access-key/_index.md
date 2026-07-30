---
type: docs
title: "How to configure AWS credentials using an IAM access key"
linkTitle: "AWS IAM Access key"
description: "Learn how to configure an AWS credential using an IAM access key in the Radius control plane"
weight: 100
aliases:
  - /guides/installation/cloud-providers/aws/access-key/
---

Radius authenticates to AWS with an IAM user's access key to deploy and connect to AWS resources. This guide creates an access key and registers it as an AWS credential in the Radius control plane.

## Step 1: Obtain the access key ID and key

Radius authenticates to AWS with an IAM user's access key. If you don't already have one, create an access key for the IAM user Radius will use:

1. Sign in to the [AWS Management Console](https://console.aws.amazon.com/) and open the IAM console.
1. Select **Users**, then select the IAM user.
1. On the **Security credentials** tab, under **Access keys**, select **Create access key**.
1. Select a use case (for example, **Command Line Interface (CLI)**), acknowledge the recommendations, and select **Create access key**.
1. Copy the **Access key ID** and **Secret access key**. The secret access key is shown only once, so store it securely.

Alternatively, create an access key with the AWS CLI:

```bash
aws iam create-access-key --user-name myIamUser
```

For more information, see [Manage access keys for IAM users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) in the AWS documentation.

## Step 2a: Interactively via `rad initialize`

If Radius has not been installed already, [`rad initialize --full`]({{< ref rad_initialize >}}) can be used to interactively install Radius and configure an AWS access key at the same time.

<!-- TODO: Remove the `--preview` flag from `rad initialize --full` below once it is no longer required. -->
```bash
rad initialize --full --preview
```

Follow the prompts:

1. When prompted with **"Add cloud providers for cloud resources?"**, select **Yes**.
1. Select **AWS**, then **Access Key**.
1. Enter the **IAM access key ID** and **secret access key** recorded in [Step 1](#step-1-obtain-the-access-key-id-and-key).
1. Enter the **AWS account ID** and **region** to use for the `default` Environment.

## Step 2b: Manual configuration

Create the AWS credential in the Radius control plane with [`rad credential register aws access-key`]({{< ref rad_credential_register_aws_access-key >}}):

```bash
rad credential register aws access-key --access-key-id myAccessKeyId --secret-access-key mySecretAccessKey
```

Radius will use the provided access key for all interactions with AWS.

## Step 3: Update existing Environments

If you have existing Environments, you must also update your Environments with your AWS region and AWS account ID:

<!-- TODO: Remove the `--preview` flag from `rad environment` below once it is no longer required. -->
```bash
rad environment update myEnvironment \
  --aws-region myAwsRegion \
  --aws-account-id myAwsAccountId \
  --preview
```

This command updates the configuration of an environment for properties that are able to be changed. For more information visit [`rad environment update`]({{< ref rad_environment_update >}}).

## Next steps

Once AWS or Azure credentials are configured, set up access to the Radius Dashboard.

{{< button text="Next step: How to configure access to the Radius dashboard" page="installation/dashboard" >}}

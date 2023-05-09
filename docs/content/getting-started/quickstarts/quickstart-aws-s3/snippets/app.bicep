import aws as aws

import radius as radius

param environment string

param application string

@description('IAM Access Key ID')
@secure()
param aws_access_key_id string

@description('IAM Access Key Secret')
@secure()
param aws_secret_access_key string

@description('AWS region (default: us-east-2)')
param aws_region string = 'us-east-2'

// get a radius container which uses the s3 bucket
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 's3app'
  properties: {
    environment: environment
  }
}

@description('The name of your S3 bucket.The AWS S3 Bucket name must follow the [following naming conventions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).')
param bucket string ='mys3bucketres-${uniqueString(application)}'
resource s3 'AWS.S3/Bucket@default' = {
  alias: bucket
  properties: {
    BucketName: bucket
    AccessControl: 'Private'
  }
}

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      env: {
        BUCKET_NAME: s3.properties.BucketName
        AWS_ACCESS_KEY_ID: aws_access_key_id
        AWS_SECRET_ACCESS_KEY: aws_secret_access_key
        AWS_DEFAULT_REGION: aws_region
      }
      image: 'radius.azurecr.io/reference-apps/aws:edge'
    }
  }
}

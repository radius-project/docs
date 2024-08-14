extension aws

extension radius

param environment string

param bucket string = 'mybucket'

@secure()
param aws_access_key_id string

@secure()
param aws_secret_access_key string

param aws_region string

resource s3 'AWS.S3/Bucket@default' = {
  alias: 's3'
  properties: {
    BucketName: bucket
    AccessControl: 'PublicRead'
  }
}

// get a radius container which uses the s3 bucket
resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 's3app'
  properties: {
    environment: environment
  }
}

resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 's3container'
  properties: {
    application: app.id
    container: {
      env: {
        BUCKET_NAME: s3.properties.BucketName
        AWS_ACCESS_KEY_ID: aws_access_key_id
        AWS_SECRET_ACCESS_KEY: aws_secret_access_key
        AWS_DEFAULT_REGION: aws_region
      }
      image: 'ghcr.io/radius-project/samples/aws:latest'
    }
  }
}

extension aws

extension radius

@description('The name of your S3 bucket.The AWS S3 Bucket name must follow the [following naming conventions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).')
param bucket string ='mys3bucket'

resource s3 'AWS.S3/Bucket@default' = {
  alias: bucket
  properties: {
    BucketName: bucket
  }
}

//S3APP
@description('The environment ID of your Radius Application. Set automatically by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 's3app'
  properties: {
    environment: environment
  }
}

@description('IAM Access Key ID')
@secure()
param aws_access_key_id string

@description('IAM Access Key Secret')
@secure()
param aws_secret_access_key string

@description('Region where the S3 bucket is created. This will be the same region that you input when adding AWS cloud provider to an environment in Radius.')
param aws_region string = 'us-west-2'

// get a radius container which uses the s3 bucket
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
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
      image: 'ghcr.io/radius-project/samples/aws:latest'
    }
  }
}
//S3APP

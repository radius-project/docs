import aws as aws

@description('The name of your S3 bucket.The AWS S3 Bucket name must follow the [following naming conventions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).')
param bucket string ='mys3bucket-${uniqueString(resourceGroup().id)}'
resource s3 'AWS.S3/Bucket@default' = {
  alias: bucket
  properties: {
    BucketName: bucket
    AccessControl: 'Private'
  }
}

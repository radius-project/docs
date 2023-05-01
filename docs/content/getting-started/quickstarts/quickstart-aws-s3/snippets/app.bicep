import aws as aws
import radius as radius

param environment string

param bucket string

@secure()
param aws_access_key_id string

@secure()
param aws_secret_access_key string

param aws_region string

resource s3 'AWS.S3/Bucket@default' = {
  alias: bucket
  properties: {
<<<<<<< HEAD:docs/content/getting-started/quickstarts/quickstart-aws-s3/snippets/app.bicep
    BucketName: 'mys3bucket'
    AccessControl: 'PublicRead'
=======
    BucketName: bucket
    AccessControl: 'Private'
>>>>>>> edge:docs/content/getting-started/reference-apps/aws-s3/snippets/app.bicep
  }
}

// get a radius container which uses the s3 bucket
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'webapp'
  properties: {
    environment: environment
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

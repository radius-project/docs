//ENV
resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'my-env'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'my-namespace'
    }
    recipeConfig: {
      bicep:{
        authentication:{
          //  The hostname of your container registry, such as 'docker.io' or '<registry-name>.azurecr.io'
          '<account-id>.dkr.ecr.<region>.amazonaws.com':{
            secret: registrySecrets.id
          }
        }
      }
    }
    recipes: {
      'Applications.Messaging/rabbitMQQueues': {
        default: {
          templateKind: 'bicep'
          templatePath: '<account-id>.dkr.ecr.<region>.amazonaws.com/test-private-ecr:2.0'
        }
      }
    }
  }
}
//ENV

//SECRETSTORE
resource registrySecrets 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'registry-secrets'
  properties: {
    resource: 'registry-secrets/ecr'
    type: 'awsIRSA'
    data: {
      roleARN: {
        value: 'arn:aws:iam::<account-id>:role/test-role'
      }
    }
  }
}
//SECRETSTORE

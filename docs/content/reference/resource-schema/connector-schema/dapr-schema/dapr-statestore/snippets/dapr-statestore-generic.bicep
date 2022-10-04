import radius as radius

param radEnvironment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-statestore-generic'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}
//SAMPLE
resource statestore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  location: 'global'
  properties: {
    environment: radEnvironment
    application: app.id
    kind: 'generic'
    type: 'state.couchbase'
    metadata: {
      couchbaseURL: '***'
      username: 'admin'
      password: '***'
      bucketName: 'dapr'
    }
    version: 'v1'
  }
}
//SAMPLE


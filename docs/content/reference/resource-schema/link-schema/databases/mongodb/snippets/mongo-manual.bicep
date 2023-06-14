import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

@description('Mock account object.')
param account object

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container-usermanaged'
  properties: {
    environment: environment
  }
}

//MONGO
resource db 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    host: 'https://mymongo.cluster.svc.local'
    database: 'mongodb-prod'
    username: 'admin'
    port: 4242
    resources: [
      { id: account.id }
    ]
    secrets: {
      connectionString: 'https://mymongo.cluster.svc.local,password=*****,....'
      password: '*********'
    }
  }
}
//MONGO

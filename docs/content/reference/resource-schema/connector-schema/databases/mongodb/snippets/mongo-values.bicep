import radius as radius

param environmentId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container-usermanaged'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

//MONGO
resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: 'global'
  properties: {
    environment: environmentId
    application: app.id
    host: 'https://mymongo.cluster.svc.local'
    port: 4242
    secrets: {
      connectionString: 'https://mymongo.cluster.svc.local,password=*****,....'
      password: '*********'
      username: 'admin'
    }
  }
}
//MONGO

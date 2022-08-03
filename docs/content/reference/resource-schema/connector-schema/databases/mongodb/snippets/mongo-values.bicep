import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container-usermanaged'
  location: location
  properties: {
    environment: environment
  }
}

//MONGO
resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
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

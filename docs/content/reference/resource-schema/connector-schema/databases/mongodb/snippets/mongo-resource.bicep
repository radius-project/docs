import radius as radius

param radEnvironment string

param cosmosDatabase string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container-usermanaged'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

//MONGO
resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: 'global'
  properties: {
    environment: radEnvironment
    application: app.id
    resource: cosmosDatabase
  }
}
//MONGO

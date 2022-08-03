import radius as radius

param location string = resourceGroup().location
param environment string

param cosmosDatabase string

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
    resource: cosmosDatabase
  }
}
//MONGO

import radius as radius

param environment string
param location string = resourceGroup().location

//APPBASE
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'webapp'
  location: 'global'
  properties: {
    environment: environment
  }
}
//APPBASE

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
      ports: {
        web: {
          containerPort: 3000
          provides: frontendRoute.id
        }
      }
    }
    connections: {
      itemstore: {
        source: db.id
      }
    }
  }
}

resource frontendRoute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'http-route'
  location: 'global'
  properties: {
    application: app.id
  }
}
//CONTAINER

//GATEWAY
resource gateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'public'
  location: 'global'
  properties: {
    application: app.id
    routes: [
      {
         path: '/'
         destination: frontendRoute.id
      }
    ]
  }
}
//GATEWAY

//DATABASE LINK
resource db 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: 'global'
  properties: {
    environment: app.properties.environment
    application: app.id
    // Automatically build the link from the resource ID
    resource: mongo.outputs.cosmosDatabaseId
  }
}
//DATABASE LINK

//MONGOMODULE
module mongo 'azure-cosmosdb.bicep' = {
  name: 'mongo-module'
  params: {
    location: location
  }
}
//MONGOMODULE

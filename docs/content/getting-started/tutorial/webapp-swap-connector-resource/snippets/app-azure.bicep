//APPBASE
import radius as radius

param environment string

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
      image: 'radius.azurecr.io/webapptutorial-todoapp'
      ports: {
        web: {
          containerPort: 3000
          provides: frontendRoute.id
        }
      }
      env: {
        DBCONNECTION: db.connectionString()
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
         destination: frontendRoute.id
      }
    ]
  }
}
//GATEWAY

//DATABASE
resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: 'global'
  dependsOn: [
    mongo
  ]
  properties: {
    environment: app.properties.environment
    application: app.id
    secrets: {
      connectionString: 'mongodb://db:27017/db?authSource=admin'
    }
  }
}
//DATABASE

//MONGOMODULE
module mongo 'azure-cosmosdb.bicep' = {
  name: 'mongo-module'
  params: {
    name: 'webappdb'
  }
}
//MONGOMODULE

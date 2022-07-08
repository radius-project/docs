import radius as radius

param environment string

param location string = 'global'

param RGLocation string = resourceGroup().location

param accountName string = 'todoapp-cosmos-${uniqueString(resourceGroup().id)}'

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    environment: environment
  }
}

resource todoFrontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/webapptutorial-todoapp'
      ports: {
        web: {
          containerPort: 3000
          provides: todoRoute.id
        }
      }
    }
    connections: {
      mongodb: {
        source: db.id
      }
    }
  }
}

resource todoRoute 'Applications.Core/httproutes@2022-03-15-privatepreview' = {
  name: 'frontend-route'
  location: location

  properties: {
    application: app.id
  }
}

resource todoGateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'gateway'
  location: location

  properties: {
    application: app.id
    routes: [
      {
        path: '/'
        destination: todoRoute.id
      }
    ]
  }
}

resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    resource: cosmosAccount::cosmosDb.id
  }
}

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: toLower(accountName)
  location: RGLocation
  kind: 'MongoDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: RGLocation
      }
    ]
  }
  

  resource cosmosDb 'mongodbDatabases' = {
    name: 'db'
    properties: {
      resource: {
        id: 'db'
      }
      options: {
        throughput: 400
      }
    }
  }

}

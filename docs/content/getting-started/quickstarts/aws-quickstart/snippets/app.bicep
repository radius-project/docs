import radius as radius

param environment string
param location string = 'global'

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'webapp'
  location: location
  properties: {
    environment: environment
  }
}

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
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
      redis: {
        source: db.id
      }
    }
  }
}

resource frontendRoute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'http-route'
  location: location
  properties: {
    application: app.id
  }
}

resource gateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'public'
  location: location
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

resource db 'Applications.Connector/redisCaches@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    secrets: {
      connectionString: memoryDB.outputs.memoryDBConnectionString
    }
  }
}

module memoryDB 'aws-memorydb.bicep' = {
  name: 'memorydb-module'
  params: {
    eksClusterName: 'YOUR-EKS-CLUSTER-NAME' // Replace this value
  }
}

import radius as radius

param eksClusterName string

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
    }
    connections: {
      redis: {
        source: db.id
      }
    }
  }
}

// We utilize the memoryDB module to create a Redis instance then access the bicep module outputs to access the connection string and host.
resource db 'Applications.Link/redisCaches@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    mode: 'values'
    host: memoryDB.outputs.memoryDBHost
    port: memoryDB.outputs.memoryDBPort
    secrets: {
      connectionString: memoryDB.outputs.memoryDBConnectionString
    }
  }
}

// We call the memoryDB module here and pass in the name of the EKS cluster.
module memoryDB 'aws-memorydb.bicep' = {
  name: 'memorydb-module'
  params: {
    eksClusterName: eksClusterName
  }
}

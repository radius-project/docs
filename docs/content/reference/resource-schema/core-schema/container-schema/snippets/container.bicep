import radius as radius

param location string = resourceGroup().location
param environment string

param fileShare resource 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-06-01'
param mongoDB resource 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2021-07-01-preview'

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      env:{
        DEPLOYMENT_ENV: 'prod'
        DB_CONNECTION: db.connectionString()
      }
      ports: {
        http: {
          containerPort: 80
          protocol: 'TCP'
          provides: http.id
        }
      }
      volumes: {
        tempdir: {
          kind: 'ephemeral'
          mountPath: '/tmpfs'
          managedStore: 'memory'
        }
        persistentVolume:{
          kind: 'persistent'
          mountPath:'/tmpfs2'
          source: myshare.id
          rbac: 'read'
        }
      }
      readinessProbe:{
        kind:'httpGet'
        containerPort:8080
        path: '/healthz'
        initialDelaySeconds:3
        failureThreshold:4
        periodSeconds:20
      }
      livenessProbe:{
        kind:'exec'
        command:'ls /tmp'
      }
    }
    connections: {
      inventory: {
        kind: 'mongo.com/MongoDB'
        source: db.id
      }
    }
  }
}
//CONTAINER
  
resource myshare 'Applications.Core/volumes@2022-03-15-privatepreview' = {
  name: 'myshare'
  location: location
  properties:{
    application: app.id
    kind: 'azure.com.fileshare'
    resource: fileShare.id
  }
}

resource http 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'http'
  location: location
  properties: {
    application: app.id
  }
}

resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'database'
  location: location
  properties: {
    environment: environment
    application: app.id
    resource: mongoDB.id
  }
}

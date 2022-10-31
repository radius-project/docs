import radius as radius

param environment string

param mongoDbId string
param azureStorage string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environment
  }
}

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: 'global'
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
        source: db.id
      }
      azureStorage: {
        source: azureStorage
        iam: {
          kind: 'azure'
          roles: [
            'Storage Blob Data Contributor'
          ]
        }
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'frontend'
      }
    ]
  }
}
//CONTAINER

resource http 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'http'
  location: 'global'
  properties: {
    application: app.id
  }
}

resource db 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'database'
  location: 'global'
  properties: {
    environment: environment
    application: app.id
    resource: mongoDbId
  }
}

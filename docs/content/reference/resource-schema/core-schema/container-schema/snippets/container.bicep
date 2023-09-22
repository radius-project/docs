import radius as radius

param environment string

param azureStorage string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource volume 'Applications.Core/volumes@2022-03-15-privatepreview' existing = {
  name: 'myvolume'
}

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
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
        ephemeralVolume: {
          kind: 'ephemeral'
          mountPath: '/tmpfs'
          managedStore: 'memory'
        }
        persistentVolume: {
          kind: 'persistent'
          source: volume.id
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
      command: [
        '/bin/sh'
      ]
      args: [
        '-c'
        'while true; do echo hello; sleep 10;done'
      ]
      workingDir: '/app'
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
      {
        kind:  'manualScaling'
        replicas: 5
      }
      {
        kind: 'kubernetesMetadata'
        labels: {
          'team.contact.name': 'frontend'
        }
      }
    ]
    runtimes: {
      kubernetes: {
        base: loadTextContent('sidecar.yaml')
        pod: {
          containers: [
            {
              name: 'log-collector'
              image: 'radiusdev.azurecr.io/fluent/fluent-bit:2.1.8'
            }
          ]
          hostNetwork: true
        }
      }
    }
  }
}
//CONTAINER

resource http 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'http'
  properties: {
    application: app.id
  }
}

resource db 'Applications.Datastores/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'database'
  properties: {
    environment: environment
    application: app.id
  }
}

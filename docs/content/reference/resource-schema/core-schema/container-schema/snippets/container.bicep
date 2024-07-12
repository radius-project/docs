extension radius

param environment string

param azureStorage string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource volume 'Applications.Core/volumes@2023-10-01-preview' existing = {
  name: 'myvolume'
}

//CONTAINER
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      env:{
        DEPLOYMENT_ENV: 'prod'
        DB_CONNECTION: db.listSecrets().connectionString
      }
      ports: {
        http: {
          containerPort: 80
          protocol: 'TCP'
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
        base: loadTextContent('base-container.yaml')
        pod: {
          containers: [
            {
              name: 'log-collector'
              image: 'ghcr.io/radius-project/fluent-bit:2.1.8'
            }
          ]
          hostNetwork: true
        }
      }
    }
  }
}
//CONTAINER

resource db 'Applications.Datastores/mongoDatabases@2023-10-01-preview' = {
  name: 'database'
  properties: {
    environment: environment
    application: app.id
  }
}

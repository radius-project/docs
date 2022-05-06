param fileshare resource 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-06-01'

resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  //SAMPLE
  resource myshare 'Volume' = {
    name: 'myshare'
    properties: {
      kind: 'azure.com.fileshare'
      resource: fileshare.id
    }
  }

  resource frontend 'Container' = {
    name: 'frontend'
    properties: {
      container: {
        image: 'registry/container:tag'
        volumes: {
          myPersistentVolume: {
            kind: 'persistent'
            mountPath: '/tmpfs2'
            source: myshare.id
            rbac: 'read'
          }
        }
      }
    }
  }
  //SAMPLE
}


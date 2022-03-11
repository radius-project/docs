resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  //SAMPLE
  resource myshare 'Volume' existing = {
    name: 'myshare'
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

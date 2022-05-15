resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  //CONTAINER
  resource container 'Container' = {
    name: 'mycontainer'
    properties: {
      container: {
        image: 'myimage'
      }
      traits: [
        {
          kind: 'dapr.io/Sidecar@v1alpha1'
          appId: 'mycontainer'
        }
      ]
    }
  }
  //CONTAINER

}

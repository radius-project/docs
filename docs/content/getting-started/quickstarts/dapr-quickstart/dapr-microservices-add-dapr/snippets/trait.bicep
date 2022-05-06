//SAMPLE
resource app 'radius.dev/Application@v1alpha3' = {
  name: 'dapr-tutorial'

  resource backend 'Container' = {
    name: 'backend'
    properties: {
      //CONTAINER
      container: {
        image: 'radius.azurecr.io/daprtutorial-backend'
        ports: {
          orders: {
            containerPort: 3000
          }
        }
      }
      //CONTAINER
      traits: [
        {
          kind: 'dapr.io/Sidecar@v1alpha1'
          appId: 'backend'
          appPort: 3000
        }
      ]
    }
  }
}
//SAMPLE

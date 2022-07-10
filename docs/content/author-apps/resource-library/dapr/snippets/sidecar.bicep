import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

//CONTAINER
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: location
  properties: {
    application: app.id
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

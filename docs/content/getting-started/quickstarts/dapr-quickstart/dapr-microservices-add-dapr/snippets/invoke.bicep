//SAMPLE
import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-tutorial'
  location: location
  properties: {
    environment: environment
  }
}

resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/daprtutorial-backend'
      ports: {
        orders: {
          containerPort: 3000
        }
      }
    }
    traits: [
      {
        kind: 'dapr.io/Sidecar@v1alpha1'
        appId: 'backend'
        appPort: 3000
      }
    ]
  }
}
//SAMPLE

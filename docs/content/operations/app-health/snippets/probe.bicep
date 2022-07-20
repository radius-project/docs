import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

//SAMPLE
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      readinessProbe:{
        kind:'httpGet'
        containerPort:8080
        path: '/healthz'
        initialDelaySeconds:3
        failureThreshold:4
        periodSeconds:20
      }
    }
  }
}
//SAMPLE

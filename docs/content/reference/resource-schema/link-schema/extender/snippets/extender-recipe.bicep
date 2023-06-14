import radius as radius

param application string
param environment string

resource mycontainer 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/magpie:latest'
    }
    connections: {
      twilio: {
        source: twilio.id
      }
    }
  }
}
  
//SAMPLE
resource twilio 'Applications.Link/extenders@2022-03-15-privatepreview' = {
  name: 'twilio'
  properties: {
    application: application
    environment: environment
  }
}
//SAMPLE


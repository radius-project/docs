import radius as radius

param application string
param environment string

// EXTENDER
resource twilio 'Applications.Link/extenders@2022-03-15-privatepreview' = {
  name: 'twilio'
  properties: {
    application: application
    environment: environment
    recipe: {
      name: 'twilio'
    }
  }
}
//EXTENDER

resource publisher 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'publisher'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/magpie:latest'
      env: {
        TWILIO_NUMBER: twilio.properties.fromNumber
        TWILIO_SID: twilio.secrets('accountSid')
        TWILIO_ACCOUNT: twilio.secrets('authToken')
      }
    }
  }
}
  



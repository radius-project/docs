extension radius

param application string
param environment string

// EXTENDER
resource twilio 'Applications.Core/extenders@2023-10-01-preview' = {
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

resource publisher 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'publisher'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/magpiego:latest'
      env: {
        TWILIO_NUMBER: twilio.properties.fromNumber
        TWILIO_SID: twilio.listSecrets().accountSid
        TWILIO_ACCOUNT: twilio.listSecrets().authToken
      }
    }
  }
}

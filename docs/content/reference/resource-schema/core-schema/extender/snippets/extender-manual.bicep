import radius as radius

param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//EXTENDER
resource twilio 'Applications.Core/extenders@2023-10-01-preview' = {
  name: 'twilio'
  properties: {
    application: app.id
    environment: environment
    resourceProvisioning: 'manual'
    fromNumber: '222-222-2222'
    secrets: {
      accountSid: 'sid'
      authToken: 'token'
    }
  }
}
//EXTENDER

resource publisher 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'publisher'
  properties: {
    application: app.id
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

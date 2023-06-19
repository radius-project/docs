import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//EXTENDER
resource twilio 'Applications.Link/extenders@2022-03-15-privatepreview' = {
  name: 'twilio'
  properties: {
    application: app.id
    environment: environment
    fromNumber: '222-222-2222'
    secrets: {
      accountSid: 'sid'
      authToken: 'token'
    }
    resourceProvisioning: 'manual'
  }
}
//EXTENDER

resource publisher 'Applications.Core/containers@2022-03-15-privatepreview' = {
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

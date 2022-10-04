import radius as radius

param radEnvironment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

//EXTENDER
resource twilio 'Applications.Connector/extenders@2022-03-15-privatepreview' = {
  name: 'twilio'
  location: 'global'
  properties: {
    application: app.id
    environment: radEnvironment
    fromNumber: '222-222-2222'
    secrets: {
      accountSid: 'sid'
      authToken: 'token'
    }
  }
}
//EXTENDER

resource publisher 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'publisher'
  location: 'global'
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

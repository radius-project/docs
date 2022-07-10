import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'text-translation-app'
  location: location
  properties: {
    environment: environment
  }
}

resource store 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'translation-service'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
    }
    connections: {
      translationresource: {
        kind:'azure'
        source: cognitiveServicesAccount.id
        roles: [
          'Cognitive Services User'
        ]
      }
    }
  }
}

resource cognitiveServicesAccount 'Microsoft.CognitiveServices/accounts@2017-04-18' = {
  name: 'TextTranslationAccount-${guid(resourceGroup().name)}'
  location: resourceGroup().location
  kind: 'TextTranslation'
  sku: {
    name: 'F0'
  }
}


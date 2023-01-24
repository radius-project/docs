resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview'= {
  name: 'mylink'
  properties: {
    mode: 'recipe'
    recipe: {
      name: 'prod'
      parameters: {
        location: 'global'
        minimumTlsVersion: '1.2'
      }
    }
  }
}


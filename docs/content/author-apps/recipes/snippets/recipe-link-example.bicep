//BASIC
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview'= {
  name: 'mylink'
  properties: {
    mode: 'recipe'
    recipe: {
      name: '<RECIPE-NAME-EXAMPLE>'
    }
  }
}
//BASIC


//PARAMETERS
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview'= {
  name: 'mylink'
  properties: {
    mode: 'recipe'
    recipe: {
      name: '<RECIPE-NAME-EXAMPLE>'
      parameters: {
        subnetId: "<EXAMPLE>"
      }
    }
  }
}
//PARAMETERS
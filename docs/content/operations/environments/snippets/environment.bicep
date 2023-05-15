import radius as rad

//ENV
resource environment 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'myenv'
  properties: {
    compute: {
      kind: 'kubernetes'   // What kind of container runtime to use
      namespace: 'default' // Where application resources are rendered
    }
  }
}
//ENV

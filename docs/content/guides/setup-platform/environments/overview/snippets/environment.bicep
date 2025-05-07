extension radius

//ENV
resource environment 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'myenv'
  properties: {
    compute: {
      kind: 'kubernetes'   // What kind of container runtime to use
      namespace: 'default' // Where application resources are rendered
    }
  }
}
//ENV


import aws as aws

resource webapp 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'rmq-app-ctnr'
  location: location
  properties: {
    application: app.id
    container: {
      image: <image>
    connections: {
      memorydb: {
        source: memorydb.id
      }
    }
  }
}

resource memorydb 'AWS.MemoryDB/Cluster@default' = {
  name: 'my-test-cluster'
    properties: {
      NodeType: 'db.t4g.small' // https://aws.amazon.com/memorydb/pricing/
      ACLName: 'open-access'
      ClusterName: 'my-test-cluster'
    }
  }

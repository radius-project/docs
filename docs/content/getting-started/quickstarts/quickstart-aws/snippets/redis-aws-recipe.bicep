import aws as aws

@description('Radius-provided object containing information about the resouce calling the Recipe')
param context object

@description('Name of the EKS cluster used for app deployment')
param eksClusterName string

@description('List of subnetIds for the subnet group')
param subnetIds array = []

resource eksCluster 'AWS.EKS/Cluster@default' existing = {
  alias: eksClusterName
  properties: {
    Name: eksClusterName
  }
}

param subnetGroupName string = 'recipe-memorydb-subnet-group'
resource subnetGroup 'AWS.MemoryDB/SubnetGroup@default' = {
  alias:subnetGroupName
  properties: {
    SubnetGroupName: subnetGroupName
    SubnetIds: ((empty(subnetIds)) ? eksCluster.properties.ResourcesVpcConfig.SubnetIds : concat(subnetIds,eksCluster.properties.ResourcesVpcConfig.SubnetIds))
}
}

param memoryDBClusterName string = 'awscache-${uniqueString(context.resource.id)}'
resource memoryDBCluster 'AWS.MemoryDB/Cluster@default' = {
  alias: memoryDBClusterName
  properties: {
    ClusterName: memoryDBClusterName
    NodeType: 'db.t4g.small'
    ACLName: 'open-access'
    SecurityGroupIds: [eksCluster.properties.ClusterSecurityGroupId] 
    SubnetGroupName: subnetGroup.name
    NumReplicasPerShard: 0
  }
}

output result object = {
  values: {
    host: memoryDBCluster.properties.ClusterEndpoint.Address
    port: memoryDBCluster.properties.ClusterEndpoint.Port
  }
  secrets: {
    connectionString: 'rediss://${memoryDBCluster.properties.ClusterEndpoint.Address}:${memoryDBCluster.properties.ClusterEndpoint.Port}'
  }
}

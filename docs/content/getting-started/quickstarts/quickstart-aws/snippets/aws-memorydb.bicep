import aws as aws

// Bicep params are used in this module for reusability. You can also hardcode the values in the module.
param eksClusterName string

// We need to reference the existing EKS cluster to get the VPC and subnet IDs. This is done by using the existing keyword.
resource eksCluster 'AWS.EKS/Cluster@default' existing = {
  alias: eksClusterName
  properties: {
    Name: eksClusterName
  }
}

// Here we are using a param but providing a default value. This allows the user to override the value if they want.
param subnetGroupName string = 'demo-memorydb-subnet-group'

// Here we use the eksCluster resource to get the VPC and subnet IDs. We also use the param for the subnet group name.
resource subnetGroup 'AWS.MemoryDB/SubnetGroup@default' = {
  alias:subnetGroupName
  properties: {
    SubnetGroupName: subnetGroupName
    SubnetIds: eksCluster.properties.ResourcesVpcConfig.SubnetIds
  }
}

param memoryDBClusterName string = 'demo-memorydb-cluster'

// Here we are using the eksCluster resource to get the security group ID and the subnet group resource to get the subnet group name.
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

// Bicep modules use the output keyword to expose values to the parent module. This allows you to use the module in a nested fashion.
output memoryDBConnectionString string = 'rediss://${memoryDBCluster.properties.ClusterEndpoint.Address}:${memoryDBCluster.properties.ClusterEndpoint.Port}'
output memoryDBHost string = memoryDBCluster.properties.ClusterEndpoint.Address
output memoryDBPort int = memoryDBCluster.properties.ClusterEndpoint.Port

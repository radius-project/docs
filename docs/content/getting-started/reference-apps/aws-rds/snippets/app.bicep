import radius as radius
import aws as aws

param location string = 'global'
param environment string

@description('Database name (default: wordpress)')
param databaseName string = 'wordpress'

@description('Database username (default: admin)')
param databaseUsername string = 'admin'

@description('Database password. Pass at deployment time as a parameter.')
@secure()
param databasePassword string

@description('This should equal the name of an existing EKS cluster.')
param eksClusterName string

@description('''
The name of your database subnet group.

Naming constraints: Must contain no more than 255 lowercase alphanumeric characters or hyphens. Must not be "Default".
''')
param subnetGroupName string

@description('''
The name of your database instance.

Naming constraints: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Limits.html#RDS_Limits.Constraints
''')
param databaseIdentifier string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'wordpress-app'
  location: location
  properties: {
    environment: environment
  }
}

resource wordpress 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'wordpress-container'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'wordpress:6.1.1'
      ports: {
        web: {
          containerPort: 80
        }
      }
      env: {
        WORDPRESS_DB_HOST: '${db.properties.Endpoint.Address}:${db.properties.Endpoint.Port}'
        WORDPRESS_DB_USER: databaseUsername
        WORDPRESS_DB_PASSWORD: databasePassword
        WORDPRESS_DB_NAME: databaseName
      }
    }
  }
}

resource eksCluster 'AWS.EKS/Cluster@default' existing = {
  properties: {
    Name: eksClusterName
  }
}

resource subnetGroup 'AWS.RDS/DBSubnetGroup@default' = {
  properties: {
    DBSubnetGroupName: subnetGroupName
    DBSubnetGroupDescription: subnetGroupName
    SubnetIds: eksCluster.properties.ResourcesVpcConfig.SubnetIds
  }
}

resource db 'AWS.RDS/DBInstance@default' = {
  properties: {
    DBInstanceIdentifier: databaseIdentifier
    Engine: 'mysql'
    DBInstanceClass: 'db.t3.micro'
    AllocatedStorage: '20'
    DBName: databaseName
    VPCSecurityGroups: [eksCluster.properties.ClusterSecurityGroupId]
    DBSubnetGroupName: subnetGroup.properties.DBSubnetGroupName
    MasterUsername: databaseUsername
    MasterUserPassword: databasePassword
  }
}

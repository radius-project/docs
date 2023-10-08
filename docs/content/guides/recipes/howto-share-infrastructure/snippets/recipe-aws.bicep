@description('Environment information passed in automatically by Radius')
param context object

@description('Name of the shared SQL server')
param sqlServerName string

import aws as aws

//TODO

@description('Values/secrets passed back to the Recipe')
param result object = {
  values: {
    username: ''
    server: ''
    database: ''
  }
  secrets: {
    password: ''
  }
}

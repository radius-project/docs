@description('Radius-provided object containing information about the resource calling the Recipe')
param context object

var resourceName = context.resource.name
var namespace = context.runtime.kubernetes.namespace

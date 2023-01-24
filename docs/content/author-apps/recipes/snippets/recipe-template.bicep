import radius as rad 

 
param context object 
param location string
param minimumTlsVersion
 

resource redisCache 'Microsoft.Cache/redis@2021-06-01' = { 
  name: 'redis-${uniqueString(context.link.id)}' 
  location: location  
  properties: { 
    sku: { 
      capacity: 0 
      family: 'C' 
      name: 'Standard' 
    } 
    minimumTlsVersion: minimumTlsVersion
  } 

  resource firewall 'firewallRules' = { 
    name: 'contoso' 
    properties: { 
      // Contoso IP range 
      endIP: '2.2.3.2' 
      startIP: '2.2.2.2' 
    } 
  } 

  resource patchSchedule 'patchSchedules' = { 
    name: 'default' 
    properties: { 
    scheduleEntries: [ 
        { 
        dayOfWeek: 'Saturday' 
        startHourUtc: 3 
        maintenanceWindow: 'PT2H30M' 
        } 
      ] 
    } 
    } 
} 

output values object = { 
  host: redisCache.properties.hostName 
  port: redisCache.properties.port 
  secrets: { 
    password: redisCache.listKeys().primaryKey 
  } 
} 

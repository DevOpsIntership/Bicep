param ServerName string
param sqlDBname string
param location string
param administratorLogin string
@secure()
param administratorPassword string
param skuTier string
param skuName string
param monthlyRetention string
param weeklyRetention string
param weekOfYear int 
param yearlyRetention string
param diffBackupIntervalInHours int
param retentionDays int

param IpRange array  = [
  {
    name: 'Rule'
    startIpAddress: '89.151.39.134'
    endIpAddress :  '89.151.39.134'

  } 
]

resource SqlServer 'Microsoft.Sql/servers@2022-02-01-preview'={
  name:ServerName
  location:location
  properties:{
    administratorLogin:administratorLogin
    administratorLoginPassword:administratorPassword
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-02-01-preview'={
  parent:SqlServer
  name:sqlDBname
  location:location
  sku:{

    name: skuName
    tier: skuTier
  }
}

resource PolicyLong 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2022-02-01-preview'={
  parent:sqlDb
  name: 'default'
  properties:{
    monthlyRetention: monthlyRetention
    weeklyRetention: weeklyRetention
    weekOfYear: weekOfYear
    yearlyRetention: yearlyRetention
  }
}



  resource PolicyShort 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2022-02-01-preview'={
    parent:sqlDb
    name: 'default'
    properties:{
    diffBackupIntervalInHours: diffBackupIntervalInHours
    retentionDays: retentionDays
    }
  }

  resource FireWallRules 'Microsoft.Sql/servers/firewallRules@2022-02-01-preview'=[for IpRang in IpRange:{
  parent:SqlServer
  name:IpRang.name
  properties:{
    startIpAddress:IpRang.startIpAddress
    endIpAddress:IpRang.endIpAddress
  }
  }]
  
   
  
    

  
  

  

  
  

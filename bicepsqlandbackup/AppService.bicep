param webAppName string = uniqueString(resourceGroup().id) 
param sku string = 'B1' 
param linuxFxVersion string = 'DOCKER|docker/getting-started:latest' 
param location string = resourceGroup().location 
var appServicePlanName = toLower('AppServicePlan-${webAppName}')
var webSiteName = toLower('wapp-${webAppName}')
param  numberOfWorkers int = 1
param tier string = 'Basic'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
    
  }
  sku: {
    name: sku
    tier: tier
  }
  kind: 'linux'
}
resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      numberOfWorkers:numberOfWorkers

    }
  }
}

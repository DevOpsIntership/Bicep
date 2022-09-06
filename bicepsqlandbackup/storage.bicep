param storageaccountname string = uniqueString(resourceGroup().id)
param location string=resourceGroup().location
param sku string
param containerName string


resource StorageAccount 'Microsoft.Storage/storageAccounts@2021-08-01'={
  name: storageaccountname
  location:location
  sku:{
    name:sku
  }
  kind:'StorageV2'
  properties:{
    accessTier:'Hot'
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01'={
  name:'${StorageAccount.name}/default/${containerName}'
  properties:{
    publicAccess:'None'
  }
}

param Vnets object


resource MyVnet 'Microsoft.Network/virtualNetworks@2022-01-01'={
  name:Vnets.name
  location: resourceGroup().location
  properties:{
    addressSpace:{
      addressPrefixes:[
        Vnets.VnetCidr
      ]
    }
  }
}

resource Nsg 'Microsoft.Network/networkSecurityGroups@2022-01-01'=[for subnet in Vnets.VnetSubnets:{
  location:resourceGroup().location
  name:subnet.nsg.name
  properties:{
    securityRules:[for rule in subnet.nsg.NsgRules:{
      name:rule.name
      properties:{
        access:rule.access
        priority:rule.priority
        direction: rule.direction
        protocol: rule.protocol
        destinationPortRange:rule.port
        sourceAddressPrefix:rule.cidr
        sourcePortRange:'*'
        destinationAddressPrefix:'*'
      
      }
    }]
  }
}]


@batchSize(1)
resource subnets 'Microsoft.Network/virtualNetworks/subnets@2022-01-01'=[for subnet in Vnets.VnetSubnets:{
  parent:MyVnet
  dependsOn:[Nsg]
  name: subnet.name
  properties:{
    addressPrefix:subnet.cidr
    networkSecurityGroup:{
      id:resourceId('Microsoft.Network/networkSecurityGroups',subnet.nsg.name)
    }
  }

 
}]

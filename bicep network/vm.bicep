param Vms array
var uid = uniqueString(resourceGroup().id)
var vnet = 'agentsVnet'


resource PublicIp 'Microsoft.Network/publicIPAddresses@2022-01-01'=[for Ip in Vms:{
location:resourceGroup().location
name:Ip.Ipname
properties:{
  publicIPAllocationMethod:Ip.publicIPAllocationMethod
  dnsSettings:{
    domainNameLabel:'${Ip.name}-${uid}'
  }
}
}]
resource Nic 'Microsoft.Network/networkInterfaces@2022-01-01'=[for Nic in Vms:{
  dependsOn:[PublicIp]
  name:'${Nic.name}-Nic'
  location:resourceGroup().location
  properties:{      
    ipConfigurations:[
      {
        name:'ipconfig1'

        properties:{
        privateIPAllocationMethod: 'Dynamic'

        publicIPAddress:{
        id:resourceId('Microsoft.Network/publicIPAddresses',Nic.IpName)
        }
        subnet:{
         id: resourceId('Microsoft.Network/virtualNetworks/subnets',vnet,Nic.subnet)}
      }
        
     }
    ] 
  }
}]

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = [for vm in Vms:{
  dependsOn:[Nic]
  name:vm.name
  location:resourceGroup().location
   properties:{
    hardwareProfile:{
      vmSize:vm.Vmsize
    }
    osProfile:{
      computerName: vm.name
      adminUsername: 'adminUsername'
      adminPassword: 'Lpu06528@123'
    }
    storageProfile:{
      imageReference:{
        publisher: vm.publisher
        offer: vm.offer
        sku: vm.sku
        version: 'latest'
      }
      osDisk:{
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: vm.disksku
        }
      }
    }
    networkProfile:{
      networkInterfaces:[
        {
          id:resourceId('Microsoft.Network/networkInterfaces','${vm.name}-Nic')
        }
      ]
    }
   }
   
}]
  


//  Imported params
param environment  string
param appName  string
param region string = resourceGroup().location
param subnetName_CosmosDb  string
param subnetName_ACRegistry  string
param subnetName_ApiApp  string
param subnetName_WfeApp  string
param subnetName_FontDoor  string

// Local params
param addressSpaces array = [
  '192.168.4.0/24'
]

param subnets array = [
  {
    name: subnetName_CosmosDb
    properties: {
      addressPrefix: '192.168.4.0/27'
    }
  }
  {
    name: subnetName_ACRegistry
    properties: {
      addressPrefix: '192.168.4.32/27'
    }
  }
  {
    name: subnetName_ApiApp
    properties: {
      addressPrefix: '192.168.4.64/27'
      delegations:[
        {
          name:'delegation'
          properties: {
            serviceName: 'Microsoft.Web/serverfarms'
          }
        }
      ]
    }
  }
  {
    name: subnetName_WfeApp
    properties: {
      addressPrefix: '192.168.4.96/27'
      delegations:[
        {
          name:'delegation'
          properties: {
            serviceName: 'Microsoft.Web/serverfarms'
          }
        }
      ]
    }
  }
  {
    name: subnetName_FontDoor
    properties: {
      addressPrefix: '192.168.4.128/27'
    }
  }
]

// Resource Definition
resource vNet 'Microsoft.Network/virtualNetworks@2021-02-01' ={
  name:'vnet-${environment}-${region}-${appName}'
  location:region
  properties: {
    addressSpace: {
      addressPrefixes: addressSpaces
    }
    subnets: subnets
  }
}

resource subnet_cosmosdb 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: vNet
  name: 'subnet-cosmosdb'
  properties: {
    addressPrefix: '192.168.4.0/27'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

output id string = vNet.id
output name string = vNet.name

output id_subnet_cosmosdb string = subnet_cosmosdb.id

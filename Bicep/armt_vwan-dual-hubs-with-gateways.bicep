targetScope = 'subscription'

@description('The name of the resource group the Virtual WAN should be created in.')
@metadata({ displayName: 'Virtual WAN Resource Group Name' })
@minLength(1)
@maxLength(80)
param VWAN_ResourceGroup_Name string

@description('The name of the Virtual WAN.')
@metadata({ displayName: 'Virtual WAN Name' })
@minLength(1)
@maxLength(80)
param VWAN_Name string = 'Lab-VWAN-Core-01'

@description('The name of the Azure Region which the Virtual WAN should be created in.')
@metadata({ displayName: 'Virtual WAN Region' })
param VWAN_Region string

@description('The name of the resource group the first Virtual Hub should be created in.')
@metadata({ displayName: 'Virtual Hub 01 Resource Group Name' })
@minLength(1)
@maxLength(80)
param VWANHub01_ResourceGroup_Name string

@description('The name of the first Virtual Hub.')
@metadata({ displayName: 'Virtual Hub 01 Name' })
@minLength(1)
@maxLength(80)
param VWANHub01_Name string = 'Lab-Hub-Core-01'

@description('The name of the Azure Region which the first Virtual Hub should be created in.')
@metadata({ displayName: 'Virtual Hub 01 Region' })
param VWANHub01_Region string

@description('The address space which the first Virtual Hub will use. Must be unique and unused.')
@metadata({ displayName: 'Virtual Hub 01 Address Prefix' })
@minLength(9)
@maxLength(18)
param VWANHub01_AddressPrefix string

@description('The name of the VPN Gateway for the first Virtual Hub.')
@metadata({ displayName: 'Virtual Hub 01 VPN Gateway Name' })
@minLength(1)
@maxLength(80)
param VWANHub01_VPNGateway_Name string

@description('The name of the ExpressRoute Gateway for the first Virtual Hub.')
@metadata({ displayName: 'Virtual Hub 01 ExpressRoute Gateway Name' })
@minLength(1)
@maxLength(80)
param VWANHub01_ExpressRouteGateway_Name string

@description('The name of the resource group the second Virtual Hub should be created in.')
@metadata({ displayName: 'Virtual Hub 02 Resource Group Name' })
@minLength(1)
@maxLength(80)
param VWANHub02_ResourceGroup_Name string

@description('The name of the second Virtual Hub.')
@metadata({ displayName: 'Virtual Hub 02 Name' })
@minLength(1)
@maxLength(80)
param VWANHub02_Name string = 'Lab-Hub-Core-02'

@description('The name of the Azure Region which the second Virtual Hub should be created in.')
@metadata({ displayName: 'Virtual Hub 02 Region' })
param VWANHub02_Region string

@description('The address space which the second Virtual Hub will use. Must be unique and unused.')
@metadata({ displayName: 'Virtual Hub 02 Address Prefix' })
@minLength(9)
@maxLength(18)
param VWANHub02_AddressPrefix string

@description('The name of the VPN Gateway for the second Virtual Hub.')
@metadata({ displayName: 'Virtual Hub 02 VPN Gateway Name' })
@minLength(1)
@maxLength(80)
param VWANHub02_VPNGateway_Name string

@description('The name of the ExpressRoute Gateway for the second Virtual Hub.')
@metadata({ displayName: 'Virtual Hub 02 ExpressRoute Gateway Name' })
@minLength(1)
@maxLength(80)
param VWANHub02_ExpressRouteGateway_Name string

@description('Controls whether the Virtual WAN is deployed.')
@metadata({ displayName: 'Deploy Virtual WAN' })
param DeployVWAN bool = true

@description('Controls whether the first VWAN Hub is deployed.')
@metadata({ displayName: 'Deploy First Virtual Hub' })
param DeployFirstVWANHub bool = true

@description('Controls whether the first VWAN Hub\'s VPN Gateway is deployed.')
@metadata({ displayName: 'Deploy First Virtual Hub VPN Gateway' })
param DeployFirstVWANHubVPNGateway bool = true

@description('Controls whether the first VWAN Hub\'s ExpressRoute Gateway is deployed.')
@metadata({ displayName: 'Deploy First Virtual Hub ExpressRoute Gateway' })
param DeployFirstVWANHubExpressRouteGateway bool = true

@description('Controls whether the second VWAN Hub is deployed.')
@metadata({ displayName: 'Deploy Second Virtual Hub' })
param DeploySecondVWANHub bool = true

@description('Controls whether the second VWAN Hub\'s VPN Gateway is deployed.')
@metadata({ displayName: 'Deploy Second Virtual Hub VPN Gateway' })
param DeploySecondVWANHubVPNGateway bool = true

@description('Controls whether the second VWAN Hub\'s ExpressRoute Gateway is deployed.')
@metadata({ displayName: 'Deploy Second Virtual Hub ExpressRoute Gateway' })
param DeploySecondVWANHubExpressRouteGateway bool = true

@description('Please do not modify the value of this parameter. It is used as part of the name of resource group scope-level deployments.')
@metadata({ displayName: 'Current Date and Time' })
param DateTimeNow string = utcNow()

var vwan_deployment_name_var = 'Azure-VWAN_${DateTimeNow}'
var vwan_resource_id = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${VWAN_ResourceGroup_Name}/providers/Microsoft.Network/virtualWans/${VWAN_Name}'
var vwanhub01_deployment_name_var = 'Azure-VWAN-Hub-01_${DateTimeNow}'
var vwanhub01_resource_id = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${VWANHub01_ResourceGroup_Name}/providers/Microsoft.Network/virtualHubs/${VWANHub01_Name}'
var vwanhub02_deployment_name_var = 'Azure-VWAN-Hub-02_${DateTimeNow}'
var vwanhub02_resource_id = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${VWANHub02_ResourceGroup_Name}/providers/Microsoft.Network/virtualHubs/${VWANHub02_Name}'

resource VWAN_ResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' =
  if (DeployVWAN) {
    location: VWAN_Region
    name: VWAN_ResourceGroup_Name
  }

resource VWANHub01_ResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' =
  if (DeployVWAN && DeployFirstVWANHub) {
    location: VWANHub01_Region
    name: VWANHub01_ResourceGroup_Name
  }

resource VWANHub02_ResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' =
  if (DeployVWAN && DeploySecondVWANHub) {
    location: VWANHub02_Region
    name: VWANHub02_ResourceGroup_Name
  }

module vwan_deployment_name './nested_vwan_deployment_name.bicep' =
  if (DeployVWAN) {
    name: vwan_deployment_name_var
    scope: resourceGroup(VWAN_ResourceGroup_Name)
    params: {
      resourceId_Microsoft_Network_virtualWans_parameters_VWAN_Name: resourceId(
        'Microsoft.Network/virtualWans',
        VWAN_Name
      )
      VWAN_Name: VWAN_Name
      VWAN_Region: VWAN_Region
    }
    dependsOn: [
      VWAN_ResourceGroup
    ]
  }

module vwanhub01_deployment_name './nested_vwanhub01_deployment_name.bicep' =
  if (DeployVWAN && DeployFirstVWANHub) {
    name: vwanhub01_deployment_name_var
    scope: resourceGroup(VWANHub01_ResourceGroup_Name)
    params: {
      variables_vwan_resource_id: vwan_resource_id
      variables_vwanhub01_resource_id: vwanhub01_resource_id
      VWANHub01_Name: VWANHub01_Name
      VWANHub01_Region: VWANHub01_Region
      DeployVWAN: DeployVWAN
      DeployFirstVWANHub: DeployFirstVWANHub
      VWANHub01_AddressPrefix: VWANHub01_AddressPrefix
      VWANHub01_VPNGateway_Name: VWANHub01_VPNGateway_Name
      DeployFirstVWANHubVPNGateway: DeployFirstVWANHubVPNGateway
      VWANHub01_ExpressRouteGateway_Name: VWANHub01_ExpressRouteGateway_Name
      DeployFirstVWANHubExpressRouteGateway: DeployFirstVWANHubExpressRouteGateway
    }
    dependsOn: [
      VWANHub01_ResourceGroup
      vwan_deployment_name
    ]
  }

module vwanhub02_deployment_name './nested_vwanhub02_deployment_name.bicep' =
  if (DeployVWAN && DeploySecondVWANHub) {
    name: vwanhub02_deployment_name_var
    scope: resourceGroup(VWANHub02_ResourceGroup_Name)
    params: {
      variables_vwan_resource_id: vwan_resource_id
      variables_vwanhub02_resource_id: vwanhub02_resource_id
      VWANHub02_Name: VWANHub02_Name
      VWANHub02_Region: VWANHub02_Region
      DeployVWAN: DeployVWAN
      DeploySecondVWANHub: DeploySecondVWANHub
      VWANHub02_AddressPrefix: VWANHub02_AddressPrefix
      VWANHub02_VPNGateway_Name: VWANHub02_VPNGateway_Name
      DeploySecondVWANHubVPNGateway: DeploySecondVWANHubVPNGateway
      VWANHub02_ExpressRouteGateway_Name: VWANHub02_ExpressRouteGateway_Name
      DeploySecondVWANHubExpressRouteGateway: DeploySecondVWANHubExpressRouteGateway
    }
    dependsOn: [
      VWANHub02_ResourceGroup
      vwan_deployment_name
    ]
  }

output VWANResourceIDGenerated string = vwan_resource_id

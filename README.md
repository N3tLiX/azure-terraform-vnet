# azure-terraform-vnet

Create a simple Virtual Network in Azure.

## Usage in Terraform 0.13
```hcl
module "example" {
  source  = "github.com/N3tLiX/modules//vnet"
}
```
## Used Terraform Modules

- [```azurerm_virtual_network```](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
- [```azurerm_virtual_network_dns_servers```](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers)
- [```azurerm_subnet```](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)

## Inputs

| **Name**            	| **Description**                                                                                                                   | **Type**             	|  **Default**  	| **Required** 	|
|---------------------	|---------------------------------------------------------------------------------------------------------------------------------  |----------------------	|:-------------:	|:------------:	|
| vnet_name           	| The name of the virtual network                                                                                                   | ```string```         	|    ```""```   	|      yes     	|
| resource_group_name 	| The name of the resource group in which to create the virtual network.                                                            | ```string```         	|    ```""```   	|      yes     	|
| location            	| The location/region where the virtual network is created.                                                                         | ```string```         	|    ```""```   	|      yes     	|
| address_space       	| The address space that is used the virtual network.<br>You can supply more than one address space.                                | ```list(string)```   	|    ```[]```   	|      yes     	|
| dns_servers         	| List of IP addresses of DNS servers.                                                                                              | ```list(string)```   	|    ```[]```   	|      no      	|
| subnets             	| Can be specified multiple times to define multiple subnets.<br>Each subnet block supports fields documented [below](###subnets).  | ```list(object())``` 	| ```[{...}]``` 	|      yes     	|
| tags                	| A mapping of tags to assign to the resource.                                                                                      | ```map()```          	|    ```{}```   	|      no      	|

### Block: subnets

| **Name**                                      	| **Description**                                                                 | **Type**             	|  **Default**  	| **Required** 	|
|-----------------------------------------------	|-------------------------------------------------------------------------------- |----------------------	|:-------------:	|:------------:	|
| name                                          	| The name of the subnet. Changing this forces a new resource to be created.      | ```string```         	|    ```""```   	|      yes     	|
| address_prefixes                                | The address prefixes to use for the subnet.                                     | ```string```         	|    ```""```   	|      yes     	|
| enforce_private_link_endpoint_network_policies  | Enable or Disable network policies for the private link endpoint on the subnet. | ```bool```          	|    ```true```   |      no     	|
| enforce_private_link_service_network_policies   | Enable or Disable network policies for the private link service on the subnet.  | ```bool```          	|    ```false```  |      no     	|
| service_endpoints                               | The list of Service endpoints to associate with the subnet.                     | ```list(string)```   	|    ```null```  	|      no      	|

```service_endpoints``` Possible values: 
- Microsoft.AzureActiveDirectory
- Microsoft.AzureCosmosDB
- Microsoft.ContainerRegistry
- Microsoft.EventHub
- Microsoft.KeyVault
- Microsoft.ServiceBus
- Microsoft.Sql
- Microsoft.Storage
- Microsoft.Web

### Block: subnets.deligation

| **Name**                  	| **Description**                                                                                     | **Type**             	|  **Default**  	| **Required** 	|
|---------------------------	|---------------------------------------------------------------------------------------------------- |----------------------	|:-------------:	|:------------:	|
| name                 	      | A name for this delegation.                                                                         | ```string```         	|    ```null```   |      no     	|
| service_delegation.actions  | A list of Actions which should be delegated. This list is specific to the service to delegate to.   | ```list(string)```   	|    ```null```   |      no      	|
| service_delegation.name     | The name of service to delegate to.                                                                 | ```string```         	|    ```null``` 	|      no     	|

```service_delegation.actions``` Possible values:
- Microsoft.Network/networkinterfaces/*,
- Microsoft.Network/virtualNetworks/subnets/action, 
- Microsoft.Network/virtualNetworks/subnets/join/action, 
- Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action
- Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action

```service_delegation.name``` Possible values:
- Microsoft.ApiManagement/service, 
- Microsoft.AzureCosmosDB/clusters, 
- Microsoft.BareMetal/AzureVMware, 
- Microsoft.BareMetal/CrayServers, 
- Microsoft.Batch/batchAccounts, 
- Microsoft.ContainerInstance/containerGroups, 
- Microsoft.ContainerService/managedClusters, 
- Microsoft.Databricks/workspaces, 
- Microsoft.DBforMySQL/flexibleServers, 
- Microsoft.DBforMySQL/serversv2, 
- Microsoft.DBforPostgreSQL/flexibleServers, 
- Microsoft.DBforPostgreSQL/serversv2,
- Microsoft.DBforPostgreSQL/singleServers, 
- Microsoft.HardwareSecurityModules/dedicatedHSMs, 
- Microsoft.Kusto/clusters, 
- Microsoft.Logic/integrationServiceEnvironments, 
- Microsoft.MachineLearningServices/workspaces, 
- Microsoft.Netapp/volumes, 
- Microsoft.Network/managedResolvers, 
- Microsoft.PowerPlatform/vnetaccesslinks, 
- Microsoft.ServiceFabricMesh/networks, 
- Microsoft.Sql/managedInstances, 
- Microsoft.Sql/servers, 
- Microsoft.StoragePool/diskPools, 
- Microsoft.StreamAnalytics/streamingJobs, 
- Microsoft.Synapse/workspaces, 
- Microsoft.Web/hostingEnvironments,
- Microsoft.Web/serverFarms.

## Example Usage

```hcl
resource "azurerm_resource_group" "this" {
  name     = "rg-example"
  location = "westeurope""
}

module "network" {
  source              = "github.com/N3tLiX/modules//vnet"
  vnet_name           = "vn-example"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.255.0.0/24"]
  dns_servers         = ["8.8.8.8"]
  subnets = [
    {
      name : "AzureBastionSubnet"
      address_prefixes : ["10.255.0.0/26"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory"
      ]
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    },
    {
      name : "sn-example-endpoints"
      address_prefixes : ["10.255.0.64/26"]
      enforce_private_link_endpoint_network_policies : false
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory",
        "Microsoft.Storage",
      ]
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    }
  ]
  tags = {
    Created : "Terraform",
    Project : "Simple Example Virtual Network"
  }
}
```

Find an example, and more documentation at https://github.com/n3tlix/examples
## Authors

Originally created by [Patrick Hayo](http://github.com/adminph-de)

## License

[MIT](LICENSE)
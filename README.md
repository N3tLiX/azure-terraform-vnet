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

| **Name**            	| **Description**                                                                                                                 	| **Type**             	|  **Default**  	| **Required** 	|
|---------------------	|---------------------------------------------------------------------------------------------------------------------------------	|----------------------	|:-------------:	|:------------:	|
| vnet_name           	| The name of the virtual network                                                                                                 	| ```string```         	|    ```""```   	|      yes     	|
| resource_group_name 	| The name of the resource group in which to create the virtual network.                                                          	| ```string```         	|    ```""```   	|      yes     	|
| location            	| The location/region where the virtual network is created.                                                                       	| ```string```         	|    ```""```   	|      yes     	|
| address_space       	| The address space that is used the virtual network.<br>You can supply more than one address space.                              	| ```list(string)```   	|    ```[]```   	|      yes     	|
| dns_servers         	| List of IP addresses of DNS servers.                                                                                            	| ```list(string)```   	|    ```[]```   	|      no      	|
| subnets             	| Can be specified multiple times to define multiple subnets.<br>Each subnet block supports fields documented [below](###subnets). 	| ```list(object())``` 	| ```[{...}]``` 	|      yes     	|
| tags                	| A mapping of tags to assign to the resource.                                                                                    	| ```map()```          	|    ```{}```   	|      no      	|

```hcl
variable "subnets" {
  description = "(Required) Manages a subnet. Subnets represent network segments within the IP space defined by the virtual network ."
  type = list(object({
    name                                           = string
    address_prefixes                               = list(string)
    enforce_private_link_endpoint_network_policies = bool
    enforce_private_link_service_network_policies  = bool
    service_endpoints                              = list(string)
    deligation = object({
      name = string
      service_delegation = object({
        actions = list(string)
        name    = string
      })
    })
  }))
}
```

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
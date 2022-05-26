# azure-terraform-vnet

[![Build Status](https://app.travis-ci.com/N3tLiX/azure-terraform-vnet.svg?token=zqBsce6sEvHGqTtKVRyh&branch=main)](https://app.travis-ci.com/N3tLiX/azure-terraform-vnet)
## Create a simple VNET in Azure

This Terraform module deploys a Virtual Network in Azure with a subnet or a set of subnets.

The module does not create or expose a security group or a route table.
You could use https://github.com/n3tlix/terraform-azurerm-network to assign network security group and routing tables to the subnets.

## Usage in Terraform 0.13
```hcl
module "network" {
  source              = "azure-terraform-vnet"
  vnet_name           = "vn-example"
  resource_group_name = "rg-example-vnet"
  location            = "westeurope"
  address_space       = ["10.255.0.0/16"]
  dns_servers         = [ ]
  subnets = [
    {
      name : "sn-expample-services"
      address_prefixes : ["10.255.1.0/24"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory",
        "Microsoft.Storage",
        "Microsoft.KeyVault",
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
      name : "sn-example-postgress"
      address_prefixes : ["10.255.2.0/27"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory",
        "Microsoft.Storage",
        "Microsoft.KeyVault",
      ]
      deligation : {
        name : null
        service_delegation : {
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          name    = "Microsoft.DBforPostgreSQL/flexibleServers"
        }
      }
    }
  ]
}
```

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

### Native (Mac/Linux)

#### Prerequisites

- [Terraform **(~> 0.14.9")**](https://www.terraform.io/downloads.html)

## Authors

Originally created by [Patrick Hayo](http://github.com/adminph-de)

## License

[MIT](LICENSE)
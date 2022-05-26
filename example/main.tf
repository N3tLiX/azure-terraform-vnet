terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

data "azurerm_client_config" "this" {}

resource "azurerm_resource_group" "this" {
  name     = "rg-example-vnet"
  location = "westeurope"
}

data "azurerm_resource_group" "this" {
  name = azurerm_resource_group.this.name
}

module "network" {
  source              = "azure-terraform-vnet"
  vnet_name           = "vn-example"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  address_space       = local.address_space
  dns_servers         = ["192.168.255.4"]
  subnets = [
    {
      name : "AzureFirewallSubnet"
      address_prefixes : ["192.168.255.0/26"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : null
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    },
    {
      name : "sn-expample-endpoints"
      address_prefixes : ["192.168.255.192/26"]
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
      name : "sn-example-workloads"
      address_prefixes : ["10.200.0.0/27"]
      enforce_private_link_endpoint_network_policies : false
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
      address_prefixes : ["10.200.0.128/27"]
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

variable "subscription_id" {
  description = "(Required) Set to the Azure Client ID (Application Object ID)"
  type        = string
}

variable "client_id" {
  description = "(Required) Set to the Azure Client ID (Application Object ID)"
  type        = string
}

variable "client_secret" {
  description = "(Required) Set to the Azure Client ID (Application Object ID)."
  type        = string
}
variable "tenant_id" {
  description = "(Required) Set to the Azure Tenant ID."
  type        = string
}

output "network" {
  description = "Network deployment output."
  value       = module.network.this
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  required_version = ">= 0.14.9"
}

locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.tags, local.module_tag)
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
  lifecycle {
    ignore_changes = [
      bgp_community,
      ddos_protection_plan,
      edge_zone,
      flow_timeout_in_minutes,
      tags
    ]
  }
}

resource "azurerm_virtual_network_dns_servers" "this" {
  count              = var.dns_servers != null ? 1 : 0
  virtual_network_id = azurerm_virtual_network.this.id
  dns_servers        = var.dns_servers
}

resource "azurerm_subnet" "this" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                                           = each.key
  resource_group_name                            = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name                           = data.azurerm_virtual_network.this.name
  address_prefixes                               = each.value.address_prefixes
  enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = each.value.enforce_private_link_service_network_policies
  service_endpoints                              = each.value.service_endpoints != null ? each.value.service_endpoints : null
  dynamic "delegation" {
    for_each = each.value.deligation.name != null ? [1] : []
    content {
      name = each.value.deligation.name
      service_delegation {
        actions = each.value.deligation.service_delegation.actions
        name    = each.value.deligation.service_delegation.name
      }
    }
  }
  lifecycle {
    ignore_changes = [
      service_endpoints,
      service_endpoint_policy_ids,
    ]
  }
}

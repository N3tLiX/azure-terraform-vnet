output "vnet_name" {
  description = "Specifies the name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "vnet_id" {
  description = "Specifies the resource id of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_dns" {
  description = "Specifies the configured DNS servers."
  value       = azurerm_virtual_network.this.dns_servers
}

output "vnet_address_space" {
  description = "Conatins a list of address spaces of the virtual network."
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_names" {
  description = "Contains a list of the resource name of the subnets."
  value = [for subnet in azurerm_subnet.this : subnet.name
    if subnet.name != "GatewaySubnet" && subnet.name != "AzureFirewallSubnet" && subnet.name != "AzureFirewallManagementSubnet" && subnet.name != "AzureBastionSubnet" && subnet.name != "RouteServerSubnet"
  ]
}

output "subnet_names_services" {
  description = "Contains a list of the resource name of the azure reserved subnets."
  value = [for subnet in azurerm_subnet.this : subnet.name
    if subnet.name == "GatewaySubnet" || subnet.name == "AzureFirewallSubnet" || subnet.name == "AzureFirewallManagementSubnet" || subnet.name == "AzureBastionSubnet" || subnet.name == "RouteServerSubnet"
  ]
}

output "subnet_ids" {
  description = "Contains a list of the resource id of the subnets."
  value       = { for subnet in azurerm_subnet.this : subnet.name => subnet.id }
}

output "subnet_address_prefixes" {
  description = "Contains a list of the address prefixes of the subnets."
  value       = { for subnet in azurerm_subnet.this : subnet.name => subnet.address_prefixes }
}

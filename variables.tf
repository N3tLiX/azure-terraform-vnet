variable "vnet_name" {
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the virtual network."
  type        = string
}

variable "location" {
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "address_space" {
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space."
  type        = list(string)
}

variable "dns_servers" {
  description = "(Optional) List of IP addresses of DNS servers."
  type        = list(string)
  default     = null
}

variable "subnets" {
  description = "(Required) Manages a subnet. Subnets represent network segments within the IP space defined by the virtual network (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)."
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

variable "tags" {
  description = "(Optional) Specifies the tags of the storage account"
  default     = {}
}

provider "azurerm" {
  version = "=2.20.0"
  features {}
}

# Create an "anchor" resource group for ARO
resource "azurerm_resource_group" "main" {
  name     = var.resource_group
  location = var.location
}

# Create a virtual network within the resource group for ARO
resource "azurerm_virtual_network" "main" {
  name                = var.vnet 
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = var.address_space
}

#resource "azurerm_subnet" "master" {
#  count                = length(var.subnet_names)
#  name                 = var.subnet_names[count.index]
#  resource_group_name  = azurerm_resource_group.main.name
#  virutal_network_name = azurerm_virtual_network.main.name 
#  address_prefixes     = [var.subnet_prefixes[count.index]]
#}

locals {
  subnet_settings = {
    "master" = { enforce_private_link_endpoint_network_policies = true, address_prefixes =  ["10.0.0.0/23"]},
    "worker" = { enforce_private_link_endpoint_network_policies = false, address_prefixes = ["10.0.2.0/23"]}
  }
}

resource "azurerm_subnet" "subnet" {
  for_each = local.subnet_settings

  name                 = each.key
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes
  enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies
}


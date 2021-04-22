variable "location" {
  default = "West US"
}

variable "resource_group_name" {
  default = "cat-playground-rab-v2-aks"
}

variable "vnet_name" {
  default = "vnetDT38"
}

variable "vnet_resource_group_name" {
  default = "spokeVnetRg"
}

variable "tags" {}

resource "azurerm_resource_group" "i" {
  location = var.location
  name = var.resource_group_name
  tags = var.tags
}

resource "azurerm_subnet" "apim" {
  name = "apim"
  resource_group_name = var.vnet_resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes = ["10.28.169.96/27"] //vnDT38sn076
}

resource "azurerm_subnet" "app_gateway" {
  name = "app-gateway"
  resource_group_name = var.vnet_resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes = ["10.28.169.64/27"] //vnDT38sn075
}

resource "azurerm_public_ip" "i" {
  name                = "app-gw-public-ip"
  location            = azurerm_resource_group.i.location
  resource_group_name = azurerm_resource_group.i.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}
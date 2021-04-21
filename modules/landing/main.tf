variable "location" {
  default = "West US"
}
variable "name" {
  default = "apim-appgw"
}

resource "azurerm_resource_group" "i" {
  location = var.location
  name = var.name
}

resource "azurerm_virtual_network" "i" {
  address_space = ["10.0.0.0/16"]
  location = var.location
  name = "${var.name}-vnet"
  resource_group_name = azurerm_resource_group.i.name
}

resource "azurerm_subnet" "apim" {
  name = "apim"
  resource_group_name = azurerm_resource_group.i.name
  virtual_network_name = azurerm_virtual_network.i.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "app_gateway" {
  name = "app-gateway"
  resource_group_name = azurerm_resource_group.i.name
  virtual_network_name = azurerm_virtual_network.i.name
  address_prefixes = ["10.0.1.0/24"]
}

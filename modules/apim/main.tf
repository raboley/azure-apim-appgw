variable "location" {}
variable "name" {}

variable "resource_group_name" {
}
variable "subnet_id" {
}

resource "azurerm_api_management" "i" {
  name = var.name
  location = var.location
  resource_group_name = var.resource_group_name
  publisher_name = "Russell Boley"
  publisher_email = "raboley@gmail.com"

  sku_name = "Developer_1"
  virtual_network_type = "Internal"
  virtual_network_configuration {
    subnet_id = var.subnet_id
  }
}
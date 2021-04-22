variable "location" {}
variable "name" {}

variable "resource_group_name" {
}
variable "subnet_id" {
}
variable "api_domain" {}

resource "azurerm_api_management" "i" {
  name = var.name
  location = var.location
  resource_group_name = var.resource_group_name
  publisher_name = "Russell Boley"
  publisher_email = "russell.boley@standard.com"

  sku_name = "Developer_1"
  virtual_network_type = "Internal"
  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  tags = {
    backup = "no"
  }
}

# step 2 - https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway#step-2-3
resource "azurerm_api_management_custom_domain" "i" {
  api_management_id = azurerm_api_management.i.id

  proxy {
    host_name = var.api_domain
    certificate = filebase64("${path.module}/fabrikam.pfx")
    certificate_password = "1234"
  }
}

variable "location" {
  default = "West US"
}

variable "name" {
  default = "apim-appgw"
}

// Resources
module "landing" {
  source = "./modules/landing/"

  name = var.name
  location = var.location
}

module "apim" {
  source = "./modules/apim/"

  name = var.name
  location = var.location
  resource_group_name = module.landing.resource_group_name
  subnet_id = module.landing.subnet_apim_id
}

provider "azurerm" {
  features {}
}
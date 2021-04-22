variable "location" {
  default = "West US"
}

variable "name" {
  default = "rab-apim-appgw"
}

variable "tags" {

}
module "landing" {
  source = "./modules/landing"

  tags = var.tags
}

module "apim" {
  source = "./modules/apim/"

  name = var.name
  location = var.location
  resource_group_name = module.landing.resource_group_name
  subnet_id = module.landing.subnet_apim_id
  api_domain = "${var.dns_subdomain}.${var.dns_zone}"
}

module "app_gateway" {
  source = "./modules/app_gateway"

  internal_ip = module.landing.subnet_app_gateway_internal_ip
  public_ip_id = module.landing.app_gateway_public_ip_id
  resource_group_location = module.landing.resource_group_location
  resource_group_name = module.landing.resource_group_name
  subnet_id = module.landing.subnet_app_gateway_id
  api_domain = "${var.dns_subdomain}.${var.dns_zone}"
  apim_private_ip_address = module.apim.private_ip_address
}


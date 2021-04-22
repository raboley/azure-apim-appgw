variable "dns_zone" {
  default = "eb.standard.com"
}

variable "dns_subdomain" {
  default = "api.playground"
}

variable "infoblox_server_name" {
  description = "the server name that the infoblox server is reachable as"
  default     = "ipamadm.standard.com"
}

module "dns" {
  source = "app.terraform.io/Standard-CAT/dns/cat"
  version = "1.3.5"

  dns_subdomain = var.dns_subdomain
  dns_zone = var.dns_zone
  dns_record_ip_address = module.landing.subnet_app_gateway_internal_ip
  dns_record_ip_address_cidr_block = module.landing.subnet_app_gateway_address_prefix
}
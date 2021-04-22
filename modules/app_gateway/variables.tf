// Defaults are okay /////////////////////////////
variable "app_gateway_autoscale_min_capacity" {
  default = "1"
}
variable "app_gateway_autoscale_max_capacity" {
  default = "5"
}

variable "app_gateway_sku" {
  description = "Name of the Application Gateway SKU."
  default     = "WAF_v2"
}

variable "app_gateway_tier" {
  description = "Tier of the Application Gateway SKU."
  default     = "WAF_v2"
}
variable "waf_firewall_mode" {
  description = "The Web Application Firewall Mode"
  default     = "Detection"
}
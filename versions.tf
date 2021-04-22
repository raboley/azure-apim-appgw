terraform {
  required_providers {
//    venafi = {
//      source = "venafi/venafi"
//    }
    infoblox = {
      source  = "terraform-providers/infoblox"
      version = "~> 1.0"
    }
  }
  required_version = ">= 0.13"
}
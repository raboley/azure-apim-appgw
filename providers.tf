provider "azurerm" {
  features {}
}

provider "infoblox" {
  //  export INFOBLOX_USERNAME="infoblox_user"
  //  export INFOBLOX_PASSWORD="infoblox"
  server = var.infoblox_server_name
}

// Resource Group
output "resource_group_id" {
  value = azurerm_resource_group.i.id
}

output "resource_group_name" {
  value = azurerm_resource_group.i.name
}

output "resource_group_location" {
  value = azurerm_resource_group.i.location
}


// Vnet
output "subnet_apim_id" {
  value = azurerm_subnet.apim.id
}

output "subnet_app_gateway_id" {
  value = azurerm_subnet.app_gateway.id
}

output "subnet_app_gateway_address_prefix" {
  value = azurerm_subnet.app_gateway.address_prefixes[0]
}

output "subnet_app_gateway_internal_ip" {
  value = cidrhost(azurerm_subnet.app_gateway.address_prefixes[0], 10)
}

// public ip
output "app_gateway_public_ip_id" {
  value = azurerm_public_ip.i.id
}


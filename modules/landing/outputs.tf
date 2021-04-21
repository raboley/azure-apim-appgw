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
output "vnet_id" {
  value = azurerm_virtual_network.i.id
}

output "vnet_name" {
  value = azurerm_virtual_network.i.name
}

output "subnet_apim_id" {
  value = azurerm_subnet.apim.id
}

output "subnet_app_gateway_id" {
  value = azurerm_subnet.app_gateway.id
}

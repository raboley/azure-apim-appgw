output "private_ip_address" {
  value = azurerm_api_management.i.private_ip_addresses[0]
}
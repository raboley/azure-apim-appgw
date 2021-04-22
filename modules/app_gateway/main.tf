variable "public_ip_id" {}
variable "internal_ip" {}
variable "subnet_id" {}


variable "resource_group_name" {}
variable "resource_group_location" {}

variable "api_domain" {
}
variable "apim_private_ip_address" {
}


resource "azurerm_application_gateway" "app_gateway" {
  name                = "app-gw"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  sku {
    name = var.app_gateway_sku
    tier = var.app_gateway_tier
  }

  autoscale_configuration {
    min_capacity = var.app_gateway_autoscale_min_capacity # 0
    max_capacity = var.app_gateway_autoscale_max_capacity # 5
  }



  waf_configuration {
    enabled          = true
    firewall_mode    = var.waf_firewall_mode
    rule_set_version = "3.1"
  }
  // # This is set by Azure Ingress controller in the AKS cluster
//  dynamic "ssl_certificate" {
//    for_each = module.ssl
//    content {
//      name     = module.ssl[0].certificate_name
//      data     = module.ssl[0].certificate_azure_key_vault_pfx
//      password = module.ssl[0].certificate_private_key_password
//    }
//  }

  // SSL Policy that uses up to date SSL Settings and ciphers that will pass DAST scans.
//  ssl_policy {
//    policy_name          = "default-dast-compliant"
//    policy_type          = "Custom"
//    min_protocol_version = "TLSv1_2"
//    cipher_suites = [
//      "TLS_RSA_WITH_AES_256_GCM_SHA384",
//      "TLS_RSA_WITH_AES_128_GCM_SHA256",
//      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
//      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
//    ]
//  }

  //  trusted_root_certificate {
  //    data = ""
  //    name = ""
  //  }

  //  authentication_certificate {
  //    data = module.ssl.certificate
  //    name = module.ssl.certificate_name
  //  }

  // BEGIN - NONE OF THIS IS USED -> MANAGED BY AZURE APP GATEWAY KUBERNETES INGRESS CONTROLLER


  frontend_port {
    name = "http"
    port = 80
  }



  frontend_ip_configuration {
    name                 = "unused-public-ipcfg"
    public_ip_address_id = var.public_ip_id
  }



  backend_address_pool {
    name = "default-address-pool"
  }

  backend_http_settings {
    name                  = "default-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "default-http-listener"
    frontend_ip_configuration_name = "unused-public-ipcfg"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule-80"
    rule_type                  = "Basic"
    http_listener_name         = "default-http-listener"
    backend_address_pool_name  = "default-address-pool"
    backend_http_settings_name = "default-http-settings"
  }

  // port ->
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "https"
    port = 443
  }

  frontend_ip_configuration {
    name                          = "private-ipcfg"
    private_ip_address            = var.internal_ip
    private_ip_address_allocation = "Static"
    subnet_id                     = var.subnet_id
  }

//  trusted_root_certificate {
//    name = "api-apim-trusted-root-ca"
//    data = filebase64("${path.module}/contoso.cer")
//  }

  ssl_certificate {
    name = "apim-pfx"
    data = filebase64("${path.module}/fabrikam.pfx")
    password = "1234"
  }

  http_listener {
    frontend_ip_configuration_name = "private-ipcfg"
    frontend_port_name = "https"
    name = "apim"
    protocol = "Https"
    host_name = var.api_domain
    ssl_certificate_name = "apim-pfx"
  }

  # Step 7
  probe {
    interval = 30
    name = "apimproxyprobe"
    path = "/status-0123456789abcdef"
    protocol = "Https"
    timeout = 120
    unhealthy_threshold = 8
    host = var.api_domain
  }

  # Step 8
  trusted_root_certificate {
    name = "trusted-root"
    data = filebase64("${path.module}/contoso.cer")
  }

  # Step 9
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name = "apimproxy"
    port = 443
    protocol = "Https"
    trusted_root_certificate_names = ["trusted-root"]
    host_name = var.api_domain
  }

  # Step 10
  backend_address_pool {
    name = "apim"
    ip_addresses = [var.apim_private_ip_address]

  }

  # Step 11
  request_routing_rule {
    name = "apim-rul"

    http_listener_name = "apim"
    rule_type = "Basic"
    backend_address_pool_name = "apim"
    backend_http_settings_name = "apimproxy"
  }

  // END - NONE OF THIS IS USED -> MANAGED BY AZURE APP GATEWAY KUBERNETES INGRESS CONTROLLER



  // ignoring changes in all these properties on update to ensure terraform doesn't clobber changes
  // that the ingress controller makes
//  lifecycle {
//    ignore_changes = [
//      frontend_port,
//      frontend_ip_configuration,
//      backend_address_pool,
//      backend_http_settings,
//      http_listener,
//      request_routing_rule,
//      probe,
//      ssl_certificate,
//      trusted_root_certificate,
//      url_path_map,
//      tags,
//      redirect_configuration
//    ]
//  }

  depends_on = [var.public_ip_id]
  tags = {
    backup = "no"
  }
}
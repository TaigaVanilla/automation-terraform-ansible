resource "azurerm_public_ip" "lb_pip" {
  name                = var.lb_pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = var.lb_sku
  domain_name_label   = var.lb_pip_domain_name_label
  tags                = var.tags
}

resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.lb_sku
  frontend_ip_configuration {
    name                 = var.lb_frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = var.lb_backend_pool_name
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "health_probe" {
  name                = var.lb_probe_name
  loadbalancer_id     = azurerm_lb.lb.id
  port                = var.lb_probe_port
  protocol            = "Http"
  request_path        = var.lb_probe_request_path
  interval_in_seconds = 15
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "http_rule" {
  name                           = var.lb_rule_name
  loadbalancer_id                = azurerm_lb.lb.id
  frontend_ip_configuration_name = var.lb_frontend_ip_config_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.health_probe.id
  protocol                       = var.lb_rule_protocol
  frontend_port                  = var.lb_rule_frontend_port
  backend_port                   = var.lb_rule_backend_port
  idle_timeout_in_minutes        = 5
  load_distribution              = "Default"
}

resource "azurerm_network_interface_backend_address_pool_association" "assoc" {
  count                   = length(var.linux_vm_nic_ids)
  network_interface_id    = var.linux_vm_nic_ids[count.index]
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

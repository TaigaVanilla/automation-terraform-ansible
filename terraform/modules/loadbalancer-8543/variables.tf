variable "resource_group_name" {}
variable "location" {}
variable "lb_name" {}
variable "lb_pip_name" {}
variable "lb_sku" {}
variable "lb_pip_domain_name_label" {}
variable "lb_frontend_ip_config_name" {}
variable "lb_backend_pool_name" {}
variable "lb_probe_name" {}
variable "lb_probe_port" {}
variable "lb_probe_request_path" {}
variable "lb_rule_name" {}
variable "lb_rule_protocol" {}
variable "lb_rule_frontend_port" {}
variable "lb_rule_backend_port" {}
variable "linux_vm_nic_ids" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}

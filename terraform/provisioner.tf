resource "null_resource" "ansible_provisioning" {
  depends_on = [
    module.linux_vms,
    module.windows_vm,
    module.datadisks,
    module.loadbalancer,
    module.postgres
  ]

  provisioner "local-exec" {
    command = "ansible-playbook -i ${local.ansible_inventory_path} ${local.ansible_playbook_path}"
  }
}